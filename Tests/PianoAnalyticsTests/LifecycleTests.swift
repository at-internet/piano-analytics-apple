//
//  LifecycleTests.swift
//  PianoAnalyticsTests
//
//  This SDK is licensed under the MIT license (MIT)
//  Copyright (c) 2015- Applied Technologies Internet SAS (registration number B 403 261 258 - Trade and Companies Register of Bordeaux – France)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import XCTest
@testable import PianoAnalytics

class LifecycleTests: XCTestCase {

    var pa = PianoAnalytics.shared

    override func setUpWithError() throws {
        clearStorage()
        self.pa = PianoAnalytics(configFileLocation: "default-test.json")
        self.pa.privacySetMode(PA.Privacy.Mode.OptIn.Name)
        // Any background period longer than 0 seconds starts a new session
        self.pa.setConfiguration(ConfigurationBuilder().withSessionBackgroundDuration(0).build())
        waitForQueue()
    }

    override func tearDownWithError() throws {
        self.pa.setConfiguration(ConfigurationBuilder().withSessionBackgroundDuration(30).build())
        waitForQueue()
    }

    // MARK: - Helpers

    func clearStorage() {
        let userDefaults = UserDefaults.standard
        PrivacyStep.storageKeysByFeature.values.forEach { keys in
            keys.forEach { userDefaults.removeObject(forKey: $0) }
        }
        userDefaults.synchronize()
    }

    func waitForQueue() {
        _ = getProperties()
    }

    /// Returns context properties computed for the next event; triggers lazy lifecycle initialization
    func getProperties() -> [String: Any] {
        var properties: [String: Any] = [:]
        let expectation = self.expectation(description: "Context properties")

        self.pa.getModel { m in
            m.contextProperties.forEach { properties[$0.key] = $0.value.value }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        return properties
    }

    /// Waits for a condition without querying the model, which would trigger lazy lifecycle initialization like an event does
    func waitUntil(timeout: TimeInterval = 5, _ condition: () -> Bool) {
        let deadline = Date().addingTimeInterval(timeout)
        while !condition() && Date() < deadline {
            Thread.sleep(forTimeInterval: 0.01)
        }
        XCTAssertTrue(condition(), "Condition not met in \(timeout) seconds")
    }

    /// Simulates the application staying in background longer than the session background duration
    func returnFromLongBackground() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name("UIApplicationDidEnterBackgroundNotification"), object: nil)
        Thread.sleep(forTimeInterval: 1.1)
        notificationCenter.post(name: Notification.Name("UIApplicationDidBecomeActiveNotification"), object: nil)
    }

    /// LifecycleStep resets this flag when the SDK is created on application launch
    func simulateApplicationRelaunch() {
        UserDefaults.standard.removeObject(forKey: LifeCycleKeys.InitLifecycleDone.rawValue)
    }

    func requireApplicationVersion() throws -> String {
        guard let version = PianoAnalyticsUtils.applicationInfo?.1 else {
            throw XCTSkip("Test host has no CFBundleShortVersionString")
        }
        return version
    }

    // MARK: - Sessions

    // "Should mark the first session on a fresh install"
    func testFirstSession() throws {
        let properties = getProperties()

        XCTAssertEqual(properties["app_fs"] as? Bool, true)
        XCTAssertEqual(properties["app_fsau"] as? Bool, false)
        XCTAssertEqual(properties["app_sc"] as? Int, 1)
        XCTAssertNil(properties["app_fsdau"])
    }

    // "Should start a new session when returning from a long background"
    func testNewSessionAfterLongBackground() throws {
        let firstSessionId = getProperties()["app_sessionid"] as? String

        returnFromLongBackground()
        let properties = getProperties()

        XCTAssertEqual(properties["app_fs"] as? Bool, false)
        XCTAssertEqual(properties["app_fsau"] as? Bool, false)
        XCTAssertEqual(properties["app_sc"] as? Int, 2)
        XCTAssertNotEqual(properties["app_sessionid"] as? String, firstSessionId)
    }

    // "Should count a session once when the application returns from background before the first event"
    func testSessionStartedBeforeFirstEventIsCountedOnce() throws {
        _ = getProperties()

        simulateApplicationRelaunch()
        returnFromLongBackground()
        let properties = getProperties()

        XCTAssertEqual(properties["app_sc"] as? Int, 2)
        XCTAssertEqual(properties["app_fs"] as? Bool, false)
    }

    // MARK: - Lifecycle storage cleared by a privacy mode switch

    // "Should start over as a first session, not as an update, after lifecycle storage is cleared"
    func testFirstSessionAfterPrivacyModeSwitchAndLongBackground() throws {
        _ = getProperties()
        returnFromLongBackground()
        XCTAssertEqual(getProperties()["app_sc"] as? Int, 2)

        // Switching to a mode without lifecycle storage clears it, along with the visitor ID.
        // No event is sent until the application returns from background.
        self.pa.privacySetMode(PA.Privacy.Mode.OptOut.Name)
        self.pa.privacySetMode(PA.Privacy.Mode.OptIn.Name)
        waitUntil {
            UserDefaults.standard.string(forKey: PrivacyKeys.PrivacyMode.rawValue) == PA.Privacy.Mode.OptIn.Name
                && UserDefaults.standard.object(forKey: LifeCycleKeys.SessionCount.rawValue) == nil
        }
        returnFromLongBackground()
        let properties = getProperties()

        XCTAssertEqual(properties["app_fs"] as? Bool, true)
        XCTAssertEqual(properties["app_fsau"] as? Bool, false)
        XCTAssertEqual(properties["app_sc"] as? Int, 1)
    }

    // "Should reset the first session after update flag on first session initialization"
    func testFirstSessionResetsFirstSessionAfterUpdateFlag() throws {
        clearStorage()
        UserDefaults.standard.set(true, forKey: LifeCycleKeys.FirstSessionAfterUpdate.rawValue)

        let properties = getProperties()

        XCTAssertEqual(properties["app_fs"] as? Bool, true)
        XCTAssertEqual(properties["app_fsau"] as? Bool, false)
    }

    // MARK: - Application updates

    // "Should not consider a missing stored application version as an update"
    func testMissingStoredApplicationVersionIsNotAnUpdate() throws {
        let version = try requireApplicationVersion()
        _ = getProperties()
        UserDefaults.standard.removeObject(forKey: LifeCycleKeys.LastApplicationVersion.rawValue)

        returnFromLongBackground()
        let properties = getProperties()

        XCTAssertEqual(properties["app_fsau"] as? Bool, false)
        XCTAssertEqual(properties["app_sc"] as? Int, 2)
        XCTAssertEqual(UserDefaults.standard.string(forKey: LifeCycleKeys.LastApplicationVersion.rawValue), version)
    }

    // "Should detect an application update when the stored version differs"
    func testApplicationVersionChangeIsAnUpdate() throws {
        let version = try requireApplicationVersion()
        _ = getProperties()
        UserDefaults.standard.set("\(version)-previous", forKey: LifeCycleKeys.LastApplicationVersion.rawValue)

        returnFromLongBackground()
        let properties = getProperties()

        XCTAssertEqual(properties["app_fs"] as? Bool, false)
        XCTAssertEqual(properties["app_fsau"] as? Bool, true)
        XCTAssertEqual(properties["app_sc"] as? Int, 2)
        XCTAssertEqual(properties["app_scsu"] as? Int, 1)
        XCTAssertNotNil(properties["app_fsdau"])
        XCTAssertEqual(UserDefaults.standard.string(forKey: LifeCycleKeys.LastApplicationVersion.rawValue), version)
    }
}
