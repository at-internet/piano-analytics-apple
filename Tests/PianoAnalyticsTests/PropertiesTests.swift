//
//  PropertiesTests.swift
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

class TestProtocol: PianoAnalyticsWorkProtocol {

    var builtModel: BuiltModel?
    var completionHandler: ((_: BuiltModel?, _: [String: BuiltModel]?) -> Void)

    init(_ completionHandler: @escaping (_: BuiltModel?, _: [String: BuiltModel]?) -> Void) {
        self.completionHandler = completionHandler
    }

    func onBeforeBuild(model: inout Model) -> Bool {
        return true
    }

    func onBeforeSend(built: BuiltModel?, stored: [String: BuiltModel]?) -> Bool {
        builtModel = built
        completionHandler(built, stored)
        return false
    }
}

class PropertiesTests: XCTestCase {

    var pa = PianoAnalytics()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clearStorage()
        self.pa = PianoAnalytics(configFileLocation: "default-test.json")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func clearStorage() {
        let modes = [PA.Privacy.Mode.OptIn.Name, PA.Privacy.Mode.OptOut.Name, PA.Privacy.Mode.NoConsent.Name, PA.Privacy.Mode.NoStorage.Name, PA.Privacy.Mode.Exempt.Name]

        for mode in modes {
            clearStorageFromVisitorMode(mode)
        }
    }

    func clearStorageFromVisitorMode(_ visitorMode: String) {
        let userDefaults = UserDefaults.standard
        PrivacyStep.storageKeysByFeature.forEach { (entry) in
            entry.value.forEach { (key) in
                userDefaults.removeObject(forKey: key)
            }
        }
        userDefaults.synchronize()
    }

    func parseEvents(_ stringified: String) -> [Event] {
        let jsonData: Data = stringified.data(using: .utf8) ?? Data()
        var result: [Event] = []
        do {
            let obj: [String: Any] = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] ?? [:]
            let events: [Any] = obj["events"] as? [Any] ?? []
            for event in events {
                let event: [String: Any] = event as? [String: Any] ?? [:]
                let name: String = event["name"] as? String ?? ""
                let data: [String: Any] = event["data"] as? [String: Any] ?? [:]
                result.append(Event(name, data: data))
            }
            return result
        } catch {
            print("JSONDecoder error: \(error)")
            return [Event("", data: [:])]
        }
    }

    // MARK: - SET PROPERTY
    // "Should add a property for the next sendEvent (prop without options)"
    func testSetPropertyWithoutOptions() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setProperty(key: "custom", value: true)
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvent(Event("tata", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, nil)
    }
    // "Should add a property for the next sendEvent(s) (prop with persistent option)"
    func testSetPropertyWithPersistentOption() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setProperty(key: "custom", value: true, persistent: true)
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvent(Event("tata", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, true)
    }
    // "Should add a property for the next sendEvent (prop with events option)"
    func testSetPropertyWithEventsOption() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?
        var localBuilt3: BuiltModel?

        self.pa.setProperty(key: "custom", value: true, events: ["toto", "tata"])
        self.pa.sendEvent(Event("another", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
        })
        self.pa.sendEvent(Event("tata", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt3 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        let events3 = parseEvents(localBuilt3?.body ?? "")
        XCTAssertEqual(events1.first?.name, "another")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events2.first?.name, "toto")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events3.first?.name, "tata")
        XCTAssertEqual(events3.first?.data["custom"] as? Bool, nil)
    }
    // "Should add a property for the next sendEvent (prop with events and persistent option)"
    func testSetPropertyWithEventsAndPersistentOptions() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?
        var localBuilt3: BuiltModel?

        self.pa.setProperty(key: "custom", value: true, persistent: true, events: ["toto", "tata"])
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvent(Event("tutu", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
        })
        self.pa.sendEvent(Event("tata", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt3 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        let events3 = parseEvents(localBuilt3?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events2.first?.name, "tutu")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events3.first?.name, "tata")
        XCTAssertEqual(events3.first?.data["custom"] as? Bool, true)
    }
    // "Should add a property for the next sendEvents (prop without options)"
    func testSetPropertyForSendEventsWithoutOptions() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?

        self.pa.setProperty(key: "custom", value: true)
        self.pa.sendEvents([
            Event("toto", data: [:]),
            Event("tata", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.last?.name, "tata")
        XCTAssertEqual(events1.last?.data["custom"] as? Bool, true)
    }
    // "Should add a property for the next sendEvents(s) (prop with persistent option)"
    func testSetPropertyForSendEventsWithPersistentOption() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setProperty(key: "custom", value: true, persistent: true)
        self.pa.sendEvents([
            Event("toto", data: [:]),
            Event("another", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvents([
            Event("tata", data: [:]),
            Event("another2", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.last?.name, "another")
        XCTAssertEqual(events1.last?.data["custom"] as? Bool, true)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events2.last?.name, "another2")
        XCTAssertEqual(events2.last?.data["custom"] as? Bool, true)
    }
    // "Should add a property for the next sendEvents (prop with events option)"
    func testSetPropertyForSendEventsWithEventsOption() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setProperty(key: "custom", value: true, events: ["toto", "tata"])
        self.pa.sendEvents([
            Event("toto", data: [:]),
            Event("another", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvents([
            Event("tata", data: [:]),
            Event("another2", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.last?.name, "another")
        XCTAssertEqual(events1.last?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events2.last?.name, "another2")
        XCTAssertEqual(events2.last?.data["custom"] as? Bool, nil)
    }
    // "Should add a property for the next sendEvents (prop with events and persistent option)"
    func testSetPropertyForSendEventsWithEventsAndPersistentOptions() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setProperty(key: "custom", value: true, persistent: true, events: ["toto", "tata"])
        self.pa.sendEvents([
            Event("toto", data: [:]),
            Event("another", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvents([
            Event("tata", data: [:]),
            Event("another2", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.last?.name, "another")
        XCTAssertEqual(events1.last?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events2.last?.name, "another2")
        XCTAssertEqual(events2.last?.data["custom"] as? Bool, nil)
    }
    // "Should not override values of metadata specific properties"
    func testSetPropertyShouldNotOverrideMetadataSpecificProperties() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?

        self.pa.setProperty(key: "event_collection_platform", value: "1")
        self.pa.setProperty(key: "event_collection_version", value: "2")
        self.pa.setProperty(key: "device_timestamp_utc", value: "3")
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertNotEqual(events1.first?.data["event_collection_platform"] as? String, "1")
        XCTAssertNotEqual(events1.first?.data["event_collection_platform"] as? String, nil)
        XCTAssertNotEqual(events1.first?.data["event_collection_version"] as? String, "2")
        XCTAssertNotEqual(events1.first?.data["event_collection_version"] as? String, nil)
        XCTAssertNotEqual(events1.first?.data["device_timestamp_utc"] as? String, "3")
        XCTAssertNotEqual(events1.first?.data["device_timestamp_utc"] as? TimeInterval, nil)
    }

    // MARK: - SET PROPERTIES
    // "Should add a properties for the next sendEvent (prop without options)"
    func testSetPropertiesWithoutOptions() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setProperties(["custom": true, "another": "1"])
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvent(Event("tata", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.first?.data["another"] as? String, "1")
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events2.first?.data["another"] as? String, nil)
    }
    // "Should add a properties for the next sendEvent(s) (prop with persistent option)"
    func testSetPropertiesWithPersistentOption() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setProperties(["custom": true, "another": "1"], persistent: true)
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvent(Event("tata", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.first?.data["another"] as? String, "1")
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events2.first?.data["another"] as? String, "1")
    }
    // "Should add a properties for the next sendEvent (prop with events option)"
    func testSetPropertiesWithEventsOption() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?
        var localBuilt3: BuiltModel?

        self.pa.setProperties(["custom": true, "another": "1"], events: ["toto", "tata"])
        self.pa.sendEvent(Event("another", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
        })
        self.pa.sendEvent(Event("tata", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt3 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        let events3 = parseEvents(localBuilt3?.body ?? "")
        XCTAssertEqual(events1.first?.name, "another")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events1.first?.data["another"] as? String, nil)
        XCTAssertEqual(events2.first?.name, "toto")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events2.first?.data["another"] as? String, "1")
        XCTAssertEqual(events3.first?.name, "tata")
        XCTAssertEqual(events3.first?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events3.first?.data["another"] as? String, nil)
    }
    // "Should add a properties for the next sendEvent (prop with events and persistent option)"
    func testSetPropertiesWithEventsAndPersistentOptions() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?
        var localBuilt3: BuiltModel?

        self.pa.setProperties(["custom": true, "another": "1"], persistent: true, events: ["toto", "tata"])
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvent(Event("tutu", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
        })
        self.pa.sendEvent(Event("tata", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt3 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        let events3 = parseEvents(localBuilt3?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.first?.data["another"] as? String, "1")
        XCTAssertEqual(events2.first?.name, "tutu")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events2.first?.data["another"] as? String, nil)
        XCTAssertEqual(events3.first?.name, "tata")
        XCTAssertEqual(events3.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events3.first?.data["another"] as? String, "1")
    }
    // "Should add a properties for the next sendEvents (prop without options)"
    func testSetPropertiesForSendEventsWithoutOptions() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setProperties(["custom": true, "another": "1"])
        self.pa.sendEvents([
            Event("toto", data: [:]),
            Event("another", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvents([
            Event("tata", data: [:]),
            Event("another2", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.first?.data["another"] as? String, "1")
        XCTAssertEqual(events1.last?.name, "another")
        XCTAssertEqual(events1.last?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.last?.data["another"] as? String, "1")
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events2.first?.data["another"] as? String, nil)
        XCTAssertEqual(events2.last?.name, "another2")
        XCTAssertEqual(events2.last?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events2.last?.data["another"] as? String, nil)
    }
    // "Should add a properties for the next sendEvents(s) (prop with persistent option)"
    func testSetPropertiesForSendEventsWithPersistentOption() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setProperties(["custom": true, "another": "1"], persistent: true)
        self.pa.sendEvents([
            Event("toto", data: [:]),
            Event("another", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvents([
            Event("tata", data: [:]),
            Event("another2", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.first?.data["another"] as? String, "1")
        XCTAssertEqual(events1.last?.name, "another")
        XCTAssertEqual(events1.last?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.last?.data["another"] as? String, "1")
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events2.first?.data["another"] as? String, "1")
        XCTAssertEqual(events2.last?.name, "another2")
        XCTAssertEqual(events2.last?.data["custom"] as? Bool, true)
        XCTAssertEqual(events2.last?.data["another"] as? String, "1")
    }
    // "Should add a properties for the next sendEvents (prop with events option)"
    func testSetPropertiesForSendEventsWithEventsOption() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setProperties(["custom": true, "another": "1"], events: ["toto", "tata"])
        self.pa.sendEvents([
            Event("toto", data: [:]),
            Event("another", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvents([
            Event("tata", data: [:]),
            Event("another2", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.first?.data["another"] as? String, "1")
        XCTAssertEqual(events1.last?.name, "another")
        XCTAssertEqual(events1.last?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events1.last?.data["another"] as? String, nil)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events2.first?.data["another"] as? String, nil)
        XCTAssertEqual(events2.last?.name, "another2")
        XCTAssertEqual(events2.last?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events2.last?.data["another"] as? String, nil)
    }
    // "Should add a properties for the next sendEvents (prop with events and persistent option)"
    func testSetPropertiesForSendEventsWithEventsAndPersistentOptions() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setProperties(["custom": true, "another": "1"], persistent: true, events: ["toto", "tata"])
        self.pa.sendEvents([
            Event("toto", data: [:]),
            Event("another", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })
        self.pa.sendEvents([
            Event("tata", data: [:]),
            Event("another2", data: [:])
        ], config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events1.first?.data["another"] as? String, "1")
        XCTAssertEqual(events1.last?.name, "another")
        XCTAssertEqual(events1.last?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events1.last?.data["another"] as? String, nil)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["custom"] as? Bool, true)
        XCTAssertEqual(events2.first?.data["another"] as? String, "1")
        XCTAssertEqual(events2.last?.name, "another2")
        XCTAssertEqual(events2.last?.data["custom"] as? Bool, nil)
        XCTAssertEqual(events2.last?.data["another"] as? String, nil)
    }
    // "Should not override values of metadata specific properties"
    func testSetPropertiesShouldNotOverrideMetadataSpecificProperties() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?

        self.pa.setProperties(["event_collection_platform": "1", "event_collection_version": "2", "device_timestamp_utc": "3"])
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertNotEqual(events1.first?.data["event_collection_platform"] as? String, "1")
        XCTAssertNotEqual(events1.first?.data["event_collection_platform"] as? String, nil)
        XCTAssertNotEqual(events1.first?.data["event_collection_version"] as? String, "2")
        XCTAssertNotEqual(events1.first?.data["event_collection_version"] as? String, nil)
        XCTAssertNotEqual(events1.first?.data["device_timestamp_utc"] as? String, "3")
        XCTAssertNotEqual(events1.first?.data["device_timestamp_utc"] as? TimeInterval, nil)
    }

    // MARK: - DELETE PROPERTY
    // "Should delete a property"
    func testDeleteProperty() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?

        self.pa.setProperty(key: "custom", value: true)
        self.pa.deleteProperty(key: "custom")
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, nil)
    }
    // "Should delete a persistent property"
    func testDeletePropertyWithOptionPersistent() throws {
        let expectation = self.expectation(description: "Before send")
        var localBuilt1: BuiltModel?

        self.pa.setProperty(key: "custom", value: true, persistent: true)
        self.pa.deleteProperty(key: "custom")
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

        let events1 = parseEvents(localBuilt1?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["custom"] as? Bool, nil)
    }
}
