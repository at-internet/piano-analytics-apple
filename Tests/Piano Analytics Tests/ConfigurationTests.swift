//
//  Configuration.swift
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

class ConfigurationTests: XCTestCase {

//    var pa = PianoAnalytics.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        self.pa = PianoAnalytics(configFileLocation: "test-default.json")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDefaultConfigurationInit() throws {
        let configuration = Configuration(file: nil)

        XCTAssertEqual(configuration.get(ConfigurationKey.CollectDomain), "")
        XCTAssertEqual(configuration.get(ConfigurationKey.CrashDetection), "true")
        XCTAssertEqual(configuration.get(ConfigurationKey.CustomUserAgent), "")
        XCTAssertEqual(configuration.get(ConfigurationKey.PrivacyDefaultMode), "optin")
        XCTAssertEqual(configuration.get(ConfigurationKey.IgnoreLimitedAdTracking), "false")
        XCTAssertEqual(configuration.get(ConfigurationKey.OfflineEncryptionMode), "ifCompatible")
        XCTAssertEqual(configuration.get(ConfigurationKey.OfflineSendInterval), "500")
        XCTAssertEqual(configuration.get(ConfigurationKey.OfflineStorageMode), "required")
        XCTAssertEqual(configuration.get(ConfigurationKey.Path), "event")
        XCTAssertEqual(configuration.get(ConfigurationKey.SendEventWhenOptout), "true")
        XCTAssertEqual(configuration.get(ConfigurationKey.SessionBackgroundDuration), "30")
        XCTAssertEqual(configuration.get(ConfigurationKey.Site), "")
        XCTAssertEqual(configuration.get(ConfigurationKey.StorageLifetimePrivacy), "395")
        XCTAssertEqual(configuration.get(ConfigurationKey.StorageLifetimeUser), "395")
        XCTAssertEqual(configuration.get(ConfigurationKey.StorageLifetimeVisitor), "395")
        XCTAssertEqual(configuration.get(ConfigurationKey.VisitorStorageMode), "fixed")
        XCTAssertEqual(configuration.get(ConfigurationKey.VisitorIdType), "uuid")
    }

    func testDefaultConfigurationBuilderInit() throws {
//        let configuration = ConfigurationBuilder().build()
        let expectation = self.expectation(description: "Configuration")
        var defaultConfiguration: Configuration?

        pa.setConfiguration(ConfigurationBuilder().withSite(123456).build())
        pa.getModel { m in
            defaultConfiguration = m.configuration
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.CollectDomain), "")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.CrashDetection), "true")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.CustomUserAgent), "")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.PrivacyDefaultMode), "optin")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.IgnoreLimitedAdTracking), "false")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.OfflineEncryptionMode), "ifCompatible")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.OfflineSendInterval), "500")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.OfflineStorageMode), "required")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.Path), "event")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.SendEventWhenOptout), "true")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.SessionBackgroundDuration), "30")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.Site), "123456")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.StorageLifetimePrivacy), "395")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.StorageLifetimeUser), "395")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.StorageLifetimeVisitor), "395")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.VisitorStorageMode), "fixed")
        XCTAssertEqual(defaultConfiguration?.get(ConfigurationKey.VisitorIdType), "uuid")
    }

    func testWithPath() throws {
        let key = ConfigurationKey.Path
        let value = "/custom_path"
        let configuration = ConfigurationBuilder().withPath(value).build()

        XCTAssertEqual(configuration.get(key), value, "Error in the withPath function")
    }

    // TODO all the with... functions
    // TODO test all the public functions

}
