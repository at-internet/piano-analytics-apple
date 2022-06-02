//
//  PrivacyTests.swift
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

class PrivacyTests: XCTestCase {

    var testEvents: [Event] = [
        Event("custom.specific.event", data: [
            "custom.specific.event": "custom.specific.event",
            "customprop1_sub1": "11",
            "customprop1_sub1_deep1": "111",
            "customprop1_sub1_deep2": "112",
            "customprop1_sub2": "12",
            "customprop1_sub2_deep1": "121",
            "customprop1_sub2_deep2": "122",
            "customprop1_sub3": "13",
            "customprop1_sub3_deep1": "131",
            "customprop1_sub3_deep2": "132",
            "customprop2_sub1": "21",
            "customprop2_sub1_deep1": "211",
            "customprop2_sub1_deep2": "212",
            "customprop2_sub2": "22",
            "customprop2_sub2_deep1": "221",
            "customprop2_sub2_deep2": "222",
            "customprop2andmore1": "2a1",
            "customprop2andmore1_sub1": "2a1",
            "customprop2andmore1_sub2": "2a2",
            "customprop2andmore2": "2a2",
            "customprop3": "3",
            "customprop3_sub1": "31",
            "customprop3_sub1_deep1": "311",
            "customprop3_sub1_deep2": "312",
            "customprop3_sub2": "32",
            "customprop3_sub2_deep1": "321",
            "customprop3_sub2_deep2": "322",
            "customprop3andmore1": "3a1",
            "customprop3andmore2": "3a2"
        ]),
        Event("custom.all.one", data: [
            "custom.all.one": "custom.all.one",
            "customprop1_sub1": "11",
            "customprop1_sub1_deep1": "111",
            "customprop1_sub1_deep2": "112",
            "customprop1_sub2": "12",
            "customprop1_sub2_deep1": "121",
            "customprop1_sub2_deep2": "122",
            "customprop1_sub3": "13",
            "customprop1_sub3_deep1": "131",
            "customprop1_sub3_deep2": "132",
            "customprop2_sub1": "21",
            "customprop2_sub1_deep1": "211",
            "customprop2_sub1_deep2": "212",
            "customprop2_sub2": "22",
            "customprop2_sub2_deep1": "221",
            "customprop2_sub2_deep2": "222",
            "customprop2andmore1": "2a1",
            "customprop2andmore1_sub1": "2a1",
            "customprop2andmore1_sub2": "2a2",
            "customprop2andmore2": "2a2",
            "customprop3": "3",
            "customprop3_sub1": "31",
            "customprop3_sub1_deep1": "311",
            "customprop3_sub1_deep2": "312",
            "customprop3_sub2": "32",
            "customprop3_sub2_deep1": "321",
            "customprop3_sub2_deep2": "322",
            "customprop3andmore1": "3a1",
            "customprop3andmore2": "3a2"
        ]),
        Event("custom.all.two", data: [
            "custom.all.two": "custom.all.two",
            "customprop1_sub1": "11",
            "customprop1_sub1_deep1": "111",
            "customprop1_sub1_deep2": "112",
            "customprop1_sub2": "12",
            "customprop1_sub2_deep1": "121",
            "customprop1_sub2_deep2": "122",
            "customprop1_sub3": "13",
            "customprop1_sub3_deep1": "131",
            "customprop1_sub3_deep2": "132",
            "customprop2_sub1": "21",
            "customprop2_sub1_deep1": "211",
            "customprop2_sub1_deep2": "212",
            "customprop2_sub2": "22",
            "customprop2_sub2_deep1": "221",
            "customprop2_sub2_deep2": "222",
            "customprop2andmore1": "2a1",
            "customprop2andmore1_sub1": "2a1",
            "customprop2andmore1_sub2": "2a2",
            "customprop2andmore2": "2a2",
            "customprop3": "3",
            "customprop3_sub1": "31",
            "customprop3_sub1_deep1": "311",
            "customprop3_sub1_deep2": "312",
            "customprop3_sub2": "32",
            "customprop3_sub2_deep1": "321",
            "customprop3_sub2_deep2": "322",
            "customprop3andmore1": "3a1",
            "customprop3andmore2": "3a2"
        ]),
        Event("custom.allisgreen", data: [
            "custom.allisgreen": "custom.allisgreen",
            "customprop1_sub1": "11",
            "customprop1_sub1_deep1": "111",
            "customprop1_sub1_deep2": "112",
            "customprop1_sub2": "12",
            "customprop1_sub2_deep1": "121",
            "customprop1_sub2_deep2": "122",
            "customprop1_sub3": "13",
            "customprop1_sub3_deep1": "131",
            "customprop1_sub3_deep2": "132",
            "customprop2_sub1": "21",
            "customprop2_sub1_deep1": "211",
            "customprop2_sub1_deep2": "212",
            "customprop2_sub2": "22",
            "customprop2_sub2_deep1": "221",
            "customprop2_sub2_deep2": "222",
            "customprop2andmore1": "2a1",
            "customprop2andmore1_sub1": "2a1",
            "customprop2andmore1_sub2": "2a2",
            "customprop2andmore2": "2a2",
            "customprop3": "3",
            "customprop3_sub1": "31",
            "customprop3_sub1_deep1": "311",
            "customprop3_sub1_deep2": "312",
            "customprop3_sub2": "32",
            "customprop3_sub2_deep1": "321",
            "customprop3_sub2_deep2": "322",
            "customprop3andmore1": "3a1",
            "customprop3andmore2": "3a2"
        ]),
        Event("click.exit", data: [
            "click": "click exit",
            "click_chapter1": "click chapter 1",
            "click_chapter2": "click chapter 2",
            "click_chapter3": "click chapter 3",
            "page": "page name",
            "page_chapter1": "chapter 1",
            "page_chapter2": "chapter 2",
            "page_chapter3": "chapter 3",
            "customprop1_sub1": "11",
            "customprop1_sub1_deep1": "111",
            "customprop1_sub1_deep2": "112",
            "customprop1_sub2": "12",
            "customprop1_sub2_deep1": "121",
            "customprop1_sub2_deep2": "122",
            "customprop1_sub3": "13",
            "customprop1_sub3_deep1": "131",
            "customprop1_sub3_deep2": "132",
            "customprop2_sub1": "21",
            "customprop2_sub1_deep1": "211",
            "customprop2_sub1_deep2": "212",
            "customprop2_sub2": "22",
            "customprop2_sub2_deep1": "221",
            "customprop2_sub2_deep2": "222",
            "customprop2andmore1": "2a1",
            "customprop2andmore1_sub1": "2a1",
            "customprop2andmore1_sub2": "2a2",
            "customprop2andmore2": "2a2",
            "customprop3": "3",
            "customprop3_sub1": "31",
            "customprop3_sub1_deep1": "311",
            "customprop3_sub1_deep2": "312",
            "customprop3_sub2": "32",
            "customprop3_sub2_deep1": "321",
            "customprop3_sub2_deep2": "322",
            "customprop3andmore1": "3a1",
            "customprop3andmore2": "3a2"
        ]),
        Event("click.navigation", data: [
            "click": "click navigation",
            "click_chapter1": "click chapter 1",
            "click_chapter2": "click chapter 2",
            "click_chapter3": "click chapter 3",
            "page": "page name",
            "page_chapter1": "chapter 1",
            "page_chapter2": "chapter 2",
            "page_chapter3": "chapter 3",
            "customprop1_sub1": "11",
            "customprop1_sub1_deep1": "111",
            "customprop1_sub1_deep2": "112",
            "customprop1_sub2": "12",
            "customprop1_sub2_deep1": "121",
            "customprop1_sub2_deep2": "122",
            "customprop1_sub3": "13",
            "customprop1_sub3_deep1": "131",
            "customprop1_sub3_deep2": "132",
            "customprop2_sub1": "21",
            "customprop2_sub1_deep1": "211",
            "customprop2_sub1_deep2": "212",
            "customprop2_sub2": "22",
            "customprop2_sub2_deep1": "221",
            "customprop2_sub2_deep2": "222",
            "customprop2andmore1": "2a1",
            "customprop2andmore1_sub1": "2a1",
            "customprop2andmore1_sub2": "2a2",
            "customprop2andmore2": "2a2",
            "customprop3": "3",
            "customprop3_sub1": "31",
            "customprop3_sub1_deep1": "311",
            "customprop3_sub1_deep2": "312",
            "customprop3_sub2": "32",
            "customprop3_sub2_deep1": "321",
            "customprop3_sub2_deep2": "322",
            "customprop3andmore1": "3a1",
            "customprop3andmore2": "3a2"
        ]),
        Event("page.display", data: [
            "page": "page name",
            "page_chapter1": "chapter 1",
            "page_chapter2": "chapter 2",
            "page_chapter3": "chapter 3",
            "customprop1_sub1": "11",
            "customprop1_sub1_deep1": "111",
            "customprop1_sub1_deep2": "112",
            "customprop1_sub2": "12",
            "customprop1_sub2_deep1": "121",
            "customprop1_sub2_deep2": "122",
            "customprop1_sub3": "13",
            "customprop1_sub3_deep1": "131",
            "customprop1_sub3_deep2": "132",
            "customprop2_sub1": "21",
            "customprop2_sub1_deep1": "211",
            "customprop2_sub1_deep2": "212",
            "customprop2_sub2": "22",
            "customprop2_sub2_deep1": "221",
            "customprop2_sub2_deep2": "222",
            "customprop2andmore1": "2a1",
            "customprop2andmore1_sub1": "2a1",
            "customprop2andmore1_sub2": "2a2",
            "customprop2andmore2": "2a2",
            "customprop3": "3",
            "customprop3_sub1": "31",
            "customprop3_sub1_deep1": "311",
            "customprop3_sub1_deep2": "312",
            "customprop3_sub2": "32",
            "customprop3_sub2_deep1": "321",
            "customprop3_sub2_deep2": "322",
            "customprop3andmore1": "3a1",
            "customprop3andmore2": "3a2"
        ])
    ]
    var pa = PianoAnalytics.shared

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

    func getModels(modes: [String] = ["optin", "optout", "exempt", "no-consent", "no-storage"]) -> [String: Model] {
        var models: [String: Model] = [:]
        let expectation = self.expectation(description: "Privacy configuration")

        for mode in modes {
            self.pa.privacySetMode(mode)
            self.pa.getModel { m in
                if m.privacyModel?.visitorMode == mode {
                    models[mode] = m
                }
                if mode == modes[modes.count - 1] {
                    expectation.fulfill()
                }
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
        return models
    }

    func getModeUtils(instance: PianoAnalytics?) -> String {
        var mode: String = ""
        let expectation = self.expectation(description: "Privacy mode")
        let tempInstance = instance ?? self.pa

        tempInstance.privacyGetMode { privacyMode in
            mode = privacyMode
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        return mode
    }

    // MARK: - PROPERTIES MANAGEMENT
    // PROPERTIES MANAGEMENT

        // INCLUDE PROPERTIES

    // "Should add a correct list of properties into the whitelist without events/modes"
    func testPrivacyIncludePropertiesWithoutEventsOrModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.OptIn.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"]))
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.OptOut.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.NoConsent.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.NoStorage.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"]))
    }
    // "Should add a correct list of properties into the whitelist with modes but no events"
    func testPrivacyIncludePropertiesWithModesButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["exempt", "optout", "customMode"])

        models = getModels(modes: ["exempt", "optout", "customMode"])

        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"]))
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.OptOut.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"]))
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], nil)
    }
    // "Should add a correct list of properties into the whitelist with one known mode but no events"
    func testPrivacyIncludePropertiesWithOneKnownModeButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["exempt"])

        models = getModels(modes: ["exempt"])

        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"]))
    }
    // "Should add a correct list of properties into the whitelist with one unknown mode but no events"
    func testPrivacyIncludePropertiesWithOneUnknownModeButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["customMode"])

        models = getModels(modes: ["customMode"])

        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], nil)
    }
    // "Should add a correct list of properties into the whitelist with events but no modes"
    func testPrivacyIncludePropertiesWithEventsButWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: nil, eventNames: ["page.display", "custom.event"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
    }
    // "Should add a correct list of properties into the whitelist with one event but no modes"
    func testPrivacyIncludePropertiesWithOneEventButWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: nil, eventNames: ["page.display"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
    }
    // "Should add a correct list of properties into the whitelist with modes and events"
    func testPrivacyIncludePropertiesWithModesAndEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["exempt", "customMode"], eventNames: ["page.display", "custom.event"])

        models = getModels(modes: ["optin", "exempt", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
    }
    // "Should add a correct list of properties into the whitelist with one known mode and one event"
    func testPrivacyIncludePropertiesWithOneKnownModeAndOneEvent() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["exempt"], eventNames: ["page.display"])

        models = getModels(modes: ["optin", "exempt"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard])
    }
    // "Should add a correct list of properties into the whitelist with one unknown mode and one event"
    func testPrivacyIncludePropertiesWithOneUnknownModeAndOneEvent() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["customMode"], eventNames: ["page.display"])

        models = getModels(modes: ["optin", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], nil)
    }

        // INCLUDE PROPERTY

    // "Should add a property into the whitelist without events/modes"
    func testPrivacyIncludePropertyWithoutEventsOrModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperty("prop1_sub1")

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.OptIn.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1"]))
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.OptOut.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1"]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1"]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.NoConsent.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1"]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.NoStorage.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1"]))
    }
    // "Should add a property into the whitelist with modes but no events"
    func testPrivacyIncludePropertyWithModesButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperty("prop1_sub1")

        models = getModels(modes: ["exempt", "optout", "customMode"])

        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1"]))
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.OptOut.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1"]))
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], nil)
    }
    // "Should add a property into the whitelist with one known mode but no events"
    func testPrivacyIncludePropertyWithOneKnownModeButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperty("prop1_sub1", privacyModes: ["exempt"])

        models = getModels(modes: ["exempt"])

        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard]?.union(["prop1_sub1"]))
    }
    // "Should add a property into the whitelist with one unknown mode but no events"
    func testPrivacyIncludePropertyWithOneUnknownModeButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperty("prop1_sub1", privacyModes: ["customMode"])

        models = getModels(modes: ["customMode"])

        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], nil)
    }
    // "Should add a property into the whitelist with events but no modes"
    func testPrivacyIncludePropertyWithEventsButWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperty("prop1_sub1", privacyModes: nil, eventNames: ["page.display", "custom.event"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1"])
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1"])
    }
    // "Should add a property into the whitelist with one event but no modes"
    func testPrivacyIncludePropertyWithOneEventButWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperty("prop1_sub1", privacyModes: nil, eventNames: ["page.display"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
    }
    // "Should add a property into the whitelist with modes and events"
    func testPrivacyIncludePropertyWithModesAndEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperty("prop1_sub1", privacyModes: ["exempt", "customMode"], eventNames: ["page.display", "custom.event"])

        models = getModels(modes: ["optin", "exempt", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], ["prop1_sub1"])
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?["custom.event"], nil)
    }
    // "Should add a property into the whitelist with one known mode and one event"
    func testPrivacyIncludePropertyWithOneKnownModeAndOneEvent() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperty("prop1_sub1", privacyModes: ["exempt"], eventNames: ["page.display"])

        models = getModels(modes: ["optin", "exempt"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard])
    }
    // "Should add a property into the whitelist with one unknown mode and one event"
    func testPrivacyIncludePropertyWithOneUnknownModeAndOneEvent() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeProperty("prop1_sub1", privacyModes: ["customMode"], eventNames: ["page.display"])

        models = getModels(modes: ["optin", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedPropertyKeys?[PA.Privacy.Wildcard], nil)
    }

        // EXCLUDE PROPERTIES

    // "Should add a correct list of properties into the blacklist without events/modes"
    func testPrivacyExcludePropertiesWithoutEventsOrModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
    }
    // "Should add a correct list of properties into the blacklist with modes but no events"
    func testPrivacyExcludePropertiesWithModesButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["exempt", "optout", "customMode"])

        models = getModels(modes: ["exempt", "optout", "customMode"])

        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], nil)
    }
    // "Should add a correct list of properties into the blacklist with one known mode but no events"
    func testPrivacyExcludePropertiesWithOneKnownModeButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["exempt"])

        models = getModels(modes: ["exempt"])

        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
    }
    // "Should add a correct list of properties into the blacklist with one unknown mode but no events"
    func testPrivacyExcludePropertiesWithOneUnknownModeButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["customMode"])

        models = getModels(modes: ["customMode"])

        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], nil)
    }
    // "Should add a correct list of properties into the blacklist with events but no modes"
    func testPrivacyExcludePropertiesWithEventsButWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: nil, eventNames: ["page.display", "custom.event"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
    }
    // "Should add a correct list of properties into the blacklist with one event but no modes"
    func testPrivacyExcludePropertiesWithOneEventButWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: nil, eventNames: ["page.display"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
    }
    // "Should add a correct list of properties into the blacklist with modes and events"
    func testPrivacyExcludePropertiesWithModesAndEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["exempt", "customMode"], eventNames: ["page.display", "custom.event"])

        models = getModels(modes: ["optin", "exempt", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
    }
    // "Should add a correct list of properties into the blacklist with one known mode and one event"
    func testPrivacyExcludePropertiesWithOneKnownModeAndOneEvent() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["exempt"], eventNames: ["page.display"])

        models = getModels(modes: ["optin", "exempt"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.Exempt.ForbiddenProperties[PA.Privacy.Wildcard])
    }
    // "Should add a correct list of properties into the blacklist with one unknown mode and one event"
    func testPrivacyExcludePropertiesWithOneUnknownModeAndOneEvent() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperties(["prop1_sub1", "prop2_sub1", "prop2_sub2", "prop3_*", "prop4_sub1_*", "prop4_sub2"], privacyModes: ["customMode"], eventNames: ["page.display"])

        models = getModels(modes: ["optin", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], nil)
    }

        // EXCLUDE PROPERTY

    // "Should add a property into the blacklist without events/modes"
    func testPrivacyExcludePropertyWithoutEventsOrModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperty("prop1_sub1")

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1"])
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1"])
    }
    // "Should add a property into the blacklist with modes but no events"
    func testPrivacyExcludePropertyWithModesButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperty("prop1_sub1", privacyModes: ["exempt", "optout", "customMode"])

        models = getModels(modes: ["exempt", "optout", "customMode"])

        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1"])
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1"])
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], nil)
    }
    // "Should add a property into the blacklist with one known mode but no events"
    func testPrivacyExcludePropertyWithOneKnownModeButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperty("prop1_sub1", privacyModes: ["exempt"])

        models = getModels(modes: ["exempt"])

        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], ["prop1_sub1"])
    }
    // "Should add a property into the blacklist with one unknown mode but no events"
    func testPrivacyExcludePropertyWithOneUnknownModeButWithoutEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperty("prop1_sub1", privacyModes: ["customMode"])

        models = getModels(modes: ["customMode"])

        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], nil)
    }
    // "Should add a property into the blacklist with events but no modes"
    func testPrivacyExcludePropertyWithEventsButWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperty("prop1_sub1", privacyModes: nil, eventNames: ["page.display", "custom.event"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1"])
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1"])
    }
    // "Should add a property into the blacklist with one event but no modes"
    func testPrivacyExcludePropertyWithOneEventButWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperty("prop1_sub1", privacyModes: nil, eventNames: ["page.display"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
    }
    // "Should add a property into the blacklist with modes and events"
    func testPrivacyExcludePropertyWithModesAndEvents() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperty("prop1_sub1", privacyModes: ["exempt", "customMode"], eventNames: ["page.display", "custom.event"])

        models = getModels(modes: ["optin", "exempt", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], ["prop1_sub1"])
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?["custom.event"], nil)
    }
    // "Should add a property into the blacklist with one known mode and one event"
    func testPrivacyExcludePropertyWithOneKnownModeAndOneEvent() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperty("prop1_sub1", privacyModes: ["exempt"], eventNames: ["page.display"])

        models = getModels(modes: ["optin", "exempt"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], ["prop1_sub1"])
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], PA.Privacy.Mode.Exempt.ForbiddenProperties[PA.Privacy.Wildcard])
    }
    // "Should add a property into the blacklist with one unknown mode and one event"
    func testPrivacyExcludePropertyWithOneUnknownModeAndOneEvent() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeProperty("prop1_sub1", privacyModes: ["customMode"], eventNames: ["page.display"])

        models = getModels(modes: ["optin", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?["page.display"], nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenPropertyKeys?[PA.Privacy.Wildcard], nil)
    }

    // STORAGE KEYS MANAGEMENT

        // INCLUDE STORAGE KEYS

    // "Should add a correct list of keys into the whitelist without modes"
    func testPrivacyIncludeStorageKeysWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeStorageKeys([PA.Privacy.Storage.Crash, PA.Privacy.Storage.User, PA.Privacy.Storage.Lifecycle])

        models = getModels(modes: ["optin", "optout", "exempt", "no-consent", "no-storage"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.storageKeys, PA.Privacy.Mode.OptIn.AllowedStorage.union([PA.Privacy.Storage.Crash, PA.Privacy.Storage.User, PA.Privacy.Storage.Lifecycle]))
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.storageKeys, PA.Privacy.Mode.OptOut.AllowedStorage.union([PA.Privacy.Storage.Crash, PA.Privacy.Storage.User, PA.Privacy.Storage.Lifecycle]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.storageKeys, PA.Privacy.Mode.Exempt.AllowedStorage.union([PA.Privacy.Storage.Crash, PA.Privacy.Storage.User, PA.Privacy.Storage.Lifecycle]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoConsent.AllowedStorage.union([PA.Privacy.Storage.Crash, PA.Privacy.Storage.User, PA.Privacy.Storage.Lifecycle]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoStorage.AllowedStorage.union([PA.Privacy.Storage.Crash, PA.Privacy.Storage.User, PA.Privacy.Storage.Lifecycle]))
    }
    // "Should add a correct list of keys into the whitelist with modes"
    func testPrivacyIncludeStorageKeysWithModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeStorageKeys([PA.Privacy.Storage.Crash, PA.Privacy.Storage.User, PA.Privacy.Storage.Lifecycle], privacyModes: ["optout", "no-consent"])

        models = getModels(modes: ["optout", "no-consent", "no-storage"])

        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.storageKeys, PA.Privacy.Mode.OptOut.AllowedStorage.union([PA.Privacy.Storage.Crash, PA.Privacy.Storage.User, PA.Privacy.Storage.Lifecycle]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoConsent.AllowedStorage.union([PA.Privacy.Storage.Crash, PA.Privacy.Storage.User, PA.Privacy.Storage.Lifecycle]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoStorage.AllowedStorage)
    }
    // "Should add a correct list of keys into the whitelist with one known mode"
    func testPrivacyIncludeStorageKeysWithOneMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeStorageKeys([PA.Privacy.Storage.Crash, PA.Privacy.Storage.User, PA.Privacy.Storage.Lifecycle], privacyModes: ["no-consent"])

        models = getModels(modes: ["optout", "no-consent", "no-storage"])

        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.storageKeys, PA.Privacy.Mode.OptOut.AllowedStorage)
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoConsent.AllowedStorage.union([PA.Privacy.Storage.Crash, PA.Privacy.Storage.User, PA.Privacy.Storage.Lifecycle]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoStorage.AllowedStorage)
    }
    // "Should not add a correct list of keys into the whitelist with one unknown mode"
    func testPrivacyIncludeStorageKeysWithOneUnknownMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeStorageKeys(["crash", "user", "lifecycle"], privacyModes: ["customMode"])

        models = getModels(modes: ["customMode"])

        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.storageKeys, nil)
    }

        // INCLUDE STORAGE KEY

    // "Should add a correct storage key into the whitelist without modes"
    func testPrivacyIncludeStorageKeyWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeStorageKey(PA.Privacy.Storage.User)

        models = getModels(modes: ["optin", "optout", "exempt", "no-consent", "no-storage"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.storageKeys, PA.Privacy.Mode.OptIn.AllowedStorage.union([PA.Privacy.Storage.User]))
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.storageKeys, PA.Privacy.Mode.OptOut.AllowedStorage.union([PA.Privacy.Storage.User]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.storageKeys, PA.Privacy.Mode.Exempt.AllowedStorage.union([PA.Privacy.Storage.User]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoConsent.AllowedStorage.union([PA.Privacy.Storage.User]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoStorage.AllowedStorage.union([PA.Privacy.Storage.User]))
    }
    // "Should add a correct storage key into the whitelist with modes"
    func testPrivacyIncludeStorageKeyWithModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeStorageKey(PA.Privacy.Storage.User, privacyModes: ["optout", "no-consent"])

        models = getModels(modes: ["optout", "no-consent", "no-storage"])

        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.storageKeys, PA.Privacy.Mode.OptOut.AllowedStorage.union([PA.Privacy.Storage.User]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoConsent.AllowedStorage.union([PA.Privacy.Storage.User]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoStorage.AllowedStorage)
    }
    // "Should add a correct storage key into the whitelist with one known mode"
    func testPrivacyIncludeStorageKeyWithOneMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeStorageKey(PA.Privacy.Storage.User, privacyModes: ["no-consent"])

        models = getModels(modes: ["optout", "no-consent", "no-storage"])

        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.storageKeys, PA.Privacy.Mode.OptOut.AllowedStorage)
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoConsent.AllowedStorage.union([PA.Privacy.Storage.User]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.storageKeys, PA.Privacy.Mode.NoStorage.AllowedStorage)
    }
    // "Should not add a correct storage key into the whitelist with one unknown mode"
    func testPrivacyIncludeStorageKeyWithOneUnknownMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeStorageKey(PA.Privacy.Storage.User, privacyModes: ["customMode"])

        models = getModels(modes: ["customMode"])

        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.storageKeys, nil)
    }

    // EVENT MANAGEMENT

        // INCLUDE EVENTS

    // "Should add a correct list of events into the whitelist without modes"
    func testPrivacyIncludeEventsWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeEvents(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptIn.AllowedEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptOut.AllowedEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.Exempt.AllowedEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.NoConsent.AllowedEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.NoStorage.AllowedEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
    }
    // "Should add a correct list of events into the whitelist with modes"
    func testPrivacyIncludeEventsWithModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeEvents(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"], privacyModes: ["optout", "exempt", "no-consent"])

        models = getModels(modes: ["optin", "optout", "exempt", "no-consent"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptIn.AllowedEvents)
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptOut.AllowedEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.Exempt.AllowedEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.NoConsent.AllowedEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
    }
    // "Should add a correct list of events into the whitelist with one known mode"
    func testPrivacyIncludeEventsWithOneMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeEvents(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"], privacyModes: ["exempt"])

        models = getModels(modes: ["optin", "exempt"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptIn.AllowedEvents)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.Exempt.AllowedEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
    }
    // "Should not add a correct list of events into the whitelist with one unknown mode"
    func testPrivacyIncludeEventsWithOneUnknownMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeEvents(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"], privacyModes: ["customMode"])

        models = getModels(modes: ["optin", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptIn.AllowedEvents)
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedEventNames, nil)
    }

        // INCLUDE EVENT

    // "Should add a correct event into the whitelist without modes"
    func testPrivacyIncludeEventWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeEvent("event1.type1")

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptIn.AllowedEvents.union(["event1.type1"]))
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptOut.AllowedEvents.union(["event1.type1"]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.Exempt.AllowedEvents.union(["event1.type1"]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.NoConsent.AllowedEvents.union(["event1.type1"]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.NoStorage.AllowedEvents.union(["event1.type1"]))
    }
    // "Should add a correct event into the whitelist with modes"
    func testPrivacyIncludeEventWithModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeEvent("event1.type1", privacyModes: ["optout", "exempt", "no-consent"])

        models = getModels(modes: ["optin", "optout", "exempt", "no-consent"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptIn.AllowedEvents)
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptOut.AllowedEvents.union(["event1.type1"]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.Exempt.AllowedEvents.union(["event1.type1"]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.NoConsent.AllowedEvents.union(["event1.type1"]))
    }
    // "Should add a correct event into the whitelist with one known mode"
    func testPrivacyIncludeEventWithOneMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeEvent("event1.type1", privacyModes: ["exempt"])

        models = getModels(modes: ["optin", "exempt"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptIn.AllowedEvents)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.Exempt.AllowedEvents.union(["event1.type1"]))
    }
    // "Should not add a correct event into the whitelist with one unknown mode"
    func testPrivacyIncludeEventWithOneUnknownMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyIncludeEvent("event1.type1", privacyModes: ["customMode"])

        models = getModels(modes: ["optin", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptIn.AllowedEvents)
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.authorizedEventNames, nil)
    }

        // EXCLUDE EVENTS

    // "Should add a correct list of events into the blacklist without modes"
    func testPrivacyExcludeEventsWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeEvents(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"])

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptIn.ForbiddenEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptOut.ForbiddenEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.Exempt.ForbiddenEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.NoConsent.ForbiddenEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.NoStorage.ForbiddenEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
    }
    // "Should add a correct list of events into the blacklist with modes"
    func testPrivacyExcludeEventsWithModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeEvents(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"], privacyModes: ["optout", "exempt", "no-consent"])

        models = getModels(modes: ["optin", "optout", "exempt", "no-consent"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptIn.ForbiddenEvents)
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptOut.ForbiddenEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.Exempt.ForbiddenEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.NoConsent.ForbiddenEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
    }
    // "Should add a correct list of events into the blacklist with one known mode"
    func testPrivacyExcludeEventsWithOneMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeEvents(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"], privacyModes: ["exempt"])

        models = getModels(modes: ["optin", "exempt"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptIn.ForbiddenEvents)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.Exempt.ForbiddenEvents.union(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"]))
    }
    // "Should not add a correct list of events into the blacklist with one unknown mode"
    func testPrivacyExcludeEventsWithOneUnknownMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeEvents(["event1.type1", "event1.type2", "event2.type3", "event3.*", "event4.type4.*", "event5*"], privacyModes: ["customMode"])

        models = getModels(modes: ["optin", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptIn.ForbiddenEvents)
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenEventNames, nil)
    }

        // EXCLUDE EVENT

    // "Should add a correct event into the blacklist without modes"
    func testPrivacyExcludeEventWithoutModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeEvent("event1.type1")

        models = getModels()

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptIn.ForbiddenEvents.union(["event1.type1"]))
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptOut.ForbiddenEvents.union(["event1.type1"]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.Exempt.ForbiddenEvents.union(["event1.type1"]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.NoConsent.ForbiddenEvents.union(["event1.type1"]))
        XCTAssertEqual(models["no-storage"]?.privacyModel?.visitorMode, "no-storage")
        XCTAssertEqual(models["no-storage"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.NoStorage.ForbiddenEvents.union(["event1.type1"]))
    }
    // "Should add a correct event into the blacklist with modes"
    func testPrivacyExcludeEventWithModes() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeEvent("event1.type1", privacyModes: ["optout", "exempt", "no-consent"])

        models = getModels(modes: ["optin", "optout", "exempt", "no-consent"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptIn.ForbiddenEvents)
        XCTAssertEqual(models["optout"]?.privacyModel?.visitorMode, "optout")
        XCTAssertEqual(models["optout"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptOut.ForbiddenEvents.union(["event1.type1"]))
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.Exempt.ForbiddenEvents.union(["event1.type1"]))
        XCTAssertEqual(models["no-consent"]?.privacyModel?.visitorMode, "no-consent")
        XCTAssertEqual(models["no-consent"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.NoConsent.ForbiddenEvents.union(["event1.type1"]))
    }
    // "Should add a correct event into the blacklist with one known mode"
    func testPrivacyExcludeEventWithOneMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeEvent("event1.type1", privacyModes: ["exempt"])

        models = getModels(modes: ["optin", "exempt"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptIn.ForbiddenEvents)
        XCTAssertEqual(models["exempt"]?.privacyModel?.visitorMode, "exempt")
        XCTAssertEqual(models["exempt"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.Exempt.ForbiddenEvents.union(["event1.type1"]))
    }
    // "Should not add a correct event into the blacklist with one unknown mode"
    func testPrivacyExcludeEventWithOneUnknownMode() throws {
        var models: [String: Model] = [:]

        self.pa.privacyExcludeEvent("event1.type1", privacyModes: ["customMode"])

        models = getModels(modes: ["optin", "customMode"])

        XCTAssertEqual(models["optin"]?.privacyModel?.visitorMode, "optin")
        XCTAssertEqual(models["optin"]?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptIn.ForbiddenEvents)
        XCTAssertEqual(models["customMode"]?.privacyModel?.visitorMode, nil)
        XCTAssertEqual(models["customMode"]?.privacyModel?.forbiddenEventNames, nil)
    }

    // MODE MANAGEMENT

        // INITIALIZATION

    // "Should be in optin mode by default"
    func testPrivacyInitializationShouldBeOptin() throws {
        let mode = getModeUtils(instance: nil)

        XCTAssertEqual(mode, "optin")
    }
    // "Should initialize with optin mode when present in storage"
    func testPrivacyInitializationShouldBeOptinWhenPresentInStorage() throws {

    }
    // "Should initialize with optout mode when present in storage"
    func testPrivacyInitializationShouldBeOptoutWhenPresentInStorage() throws {
//        self.pa.privacySetMode("optout")
//        
//        let tempPA = PianoAnalytics(configFileLocation: "")
//        tempPA.privacySetMode("no-consent")
//        let mode = getModeUtils(instance: tempPA)
//        XCTAssertEqual(getModeUtils(instance: nil), "optout")
//
//        XCTAssertEqual(mode, "no-consent")
    }
    // "Should initialize with noConsent mode when present in storage"
    // "Should initialize with noStorage mode when present in storage"
    // "Should initialize with exempt mode when present in storage"
    // "Should initialize with custom mode when present in storage and config"
    // "Should not initialize with an unknown mode when present in storage but not in config (fallback optin)"

        // MODE SWITCHING

            // TO OPTIN

    // "optin -> optin"
    func testModeSwitchingOptinToOptin() throws {
        XCTAssertEqual(getModeUtils(instance: self.pa), "optin")

        self.pa.privacySetMode("optout")
        XCTAssertEqual(getModeUtils(instance: self.pa), "optout")
        self.pa.privacySetMode("optin")
        XCTAssertEqual(getModeUtils(instance: self.pa), "optin")
    }
    // "optout -> optin"
    // "noConsent -> optin"
    // "noStorage -> optin"
    // "exempt -> optin"
    // "custom -> optin"

            // TO OPTOUT

    // "optin -> optout"
    // "optout -> optout"
    // "noConsent -> optout"
    // "noStorage -> optout"
    // "exempt -> optout"
    // "custom -> optout"

            // TO NO-CONSENT

    // "optin -> noConsent"
    // "optout -> noConsent"
    // "noConsent -> noConsent"
    // "noStorage -> noConsent"
    // "exempt -> noConsent"
    // "custom -> noConsent"

            // TO NO-STORAGE

    // "optin -> noStorage"
    // "optout -> noStorage"
    // "noConsent -> noStorage"
    // "noStorage -> noStorage"
    // "exempt -> noStorage"
    // "custom -> noStorage"

            // TO EXEMPT

    // "optin -> exempt"
    // "optout -> exempt"
    // "noConsent -> exempt"
    // "noStorage -> exempt"
    // "exempt -> exempt"
    // "custom -> exempt"

            // TO CUSTOM

    // "optin -> custom"
    // "optout -> custom"
    // "noConsent -> custom"
    // "noStorage -> custom"
    // "exempt -> custom"
    // "custom -> custom"

        // CREATE MODE

    // "Should correctly create a new mode using exempt mode as base"

    func testOptInDefaultMode() throws {
        var model: Model?

        self.pa.privacySetMode("optin")
        let expectation = self.expectation(description: "Privacy configuration")
        self.pa.getModel { m in
            model = m
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(model?.privacyModel?.visitorMode, PA.Privacy.Mode.OptIn.Name)
        XCTAssertEqual(model?.privacyModel?.storageKeys, PA.Privacy.Mode.OptIn.AllowedStorage)
        XCTAssertEqual(model?.privacyModel?.authorizedPropertyKeys, PA.Privacy.Mode.OptIn.AllowedProperties)
        XCTAssertEqual(model?.privacyModel?.forbiddenPropertyKeys, PA.Privacy.Mode.OptIn.ForbiddenProperties)
        XCTAssertEqual(model?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptIn.AllowedEvents)
        XCTAssertEqual(model?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptIn.ForbiddenEvents)
    }

    func testOptOutDefaultMode() throws {
        var model: Model?

        self.pa.privacySetMode("optout")
        let expectation = self.expectation(description: "Privacy configuration")
        self.pa.getModel { m in
            model = m
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(model?.privacyModel?.visitorMode, PA.Privacy.Mode.OptOut.Name)
        XCTAssertEqual(model?.privacyModel?.storageKeys, PA.Privacy.Mode.OptOut.AllowedStorage)
        XCTAssertEqual(model?.privacyModel?.authorizedPropertyKeys, PA.Privacy.Mode.OptOut.AllowedProperties)
        XCTAssertEqual(model?.privacyModel?.forbiddenPropertyKeys, PA.Privacy.Mode.OptOut.ForbiddenProperties)
        XCTAssertEqual(model?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.OptOut.AllowedEvents)
        XCTAssertEqual(model?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.OptOut.ForbiddenEvents)
    }

    func testNoConsentDefaultMode() throws {
        var model: Model?

        self.pa.privacySetMode("no-consent")
        let expectation = self.expectation(description: "Privacy configuration")
        self.pa.getModel { m in
            model = m
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(model?.privacyModel?.visitorMode, PA.Privacy.Mode.NoConsent.Name)
        XCTAssertEqual(model?.privacyModel?.storageKeys, PA.Privacy.Mode.NoConsent.AllowedStorage)
        XCTAssertEqual(model?.privacyModel?.authorizedPropertyKeys, PA.Privacy.Mode.NoConsent.AllowedProperties)
        XCTAssertEqual(model?.privacyModel?.forbiddenPropertyKeys, PA.Privacy.Mode.NoConsent.ForbiddenProperties)
        XCTAssertEqual(model?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.NoConsent.AllowedEvents)
        XCTAssertEqual(model?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.NoConsent.ForbiddenEvents)
    }

    func testNoStorageDefaultMode() throws {
        var model: Model?

        self.pa.privacySetMode("no-storage")
        let expectation = self.expectation(description: "Privacy configuration")
        self.pa.getModel { m in
            model = m
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(model?.privacyModel?.visitorMode, PA.Privacy.Mode.NoStorage.Name)
        XCTAssertEqual(model?.privacyModel?.storageKeys, PA.Privacy.Mode.NoStorage.AllowedStorage)
        XCTAssertEqual(model?.privacyModel?.authorizedPropertyKeys, PA.Privacy.Mode.NoStorage.AllowedProperties)
        XCTAssertEqual(model?.privacyModel?.forbiddenPropertyKeys, PA.Privacy.Mode.NoStorage.ForbiddenProperties)
        XCTAssertEqual(model?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.NoStorage.AllowedEvents)
        XCTAssertEqual(model?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.NoStorage.ForbiddenEvents)
    }

    func testExemptDefaultMode() throws {
        var model: Model?

        self.pa.privacySetMode("exempt")
        let expectation = self.expectation(description: "Privacy configuration")
        self.pa.getModel { m in
            model = m
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(model?.privacyModel?.visitorMode, PA.Privacy.Mode.Exempt.Name)
        XCTAssertEqual(model?.privacyModel?.storageKeys, PA.Privacy.Mode.Exempt.AllowedStorage)
        XCTAssertEqual(model?.privacyModel?.authorizedPropertyKeys, PA.Privacy.Mode.Exempt.AllowedProperties)
        XCTAssertEqual(model?.privacyModel?.forbiddenPropertyKeys, PA.Privacy.Mode.Exempt.ForbiddenProperties)
        XCTAssertEqual(model?.privacyModel?.authorizedEventNames, PA.Privacy.Mode.Exempt.AllowedEvents)
        XCTAssertEqual(model?.privacyModel?.forbiddenEventNames, PA.Privacy.Mode.Exempt.ForbiddenEvents)
    }

    // PRIVACY UNIT TEST

    // PRIVACY CONFIGURATION TEST
    func testExemptPrivacyIncludePropertiesWithOneEvent() throws {
        let properties = ["property1", "property3"]
        let privacyModes = ["exempt"]
        let eventNames = ["page.display"]
        var model: Model?

        self.pa.privacySetMode("exempt")
        self.pa.privacyIncludeProperties(properties, privacyModes: privacyModes, eventNames: eventNames)

        let expectation = self.expectation(description: "Privacy configuration")

        self.pa.getModel { m in
            model = m
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        let authorizedProperties = model?.privacyModel?.authorizedPropertyKeys

        XCTAssertEqual(authorizedProperties?["page.display"], ["property1", "property3"])
    }

    func testExemptPrivacyIncludePropertiesWithMultipleEvents() throws {
        let properties = ["property1", "property3"]
        let privacyModes = ["exempt"]
        let eventNames = ["page.display", "click.exit", "click.navigation", "custom.specific.event"]
        var model: Model?

        self.pa.privacySetMode("exempt")
        self.pa.privacyIncludeProperties(properties, privacyModes: privacyModes, eventNames: eventNames)

        let expectation = self.expectation(description: "Privacy configuration")

        self.pa.getModel { m in
            model = m
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        let authorizedProperties = model?.privacyModel?.authorizedPropertyKeys

        XCTAssertEqual(authorizedProperties?["page.display"], ["property1", "property3"])
        XCTAssertEqual(authorizedProperties?["click.exit"], ["property1", "property3"])
        XCTAssertEqual(authorizedProperties?["click.navigation"], ["property1", "property3"])
        XCTAssertEqual(authorizedProperties?["custom.specific.event"], ["property1", "property3"])
    }

    func testExemptPrivacyIncludePropertiesWithMultipleEventsAndEmptyStringEvent() throws {
        let properties = ["property1", "property3"]
        let privacyModes = ["exempt"]
        let eventNames = ["page.display", "click.exit", "click.navigation", "custom.specific.event", ""]
        var model: Model?

        self.pa.privacySetMode("exempt")
        self.pa.privacyIncludeProperties(properties, privacyModes: privacyModes, eventNames: eventNames)

        let expectation = self.expectation(description: "Privacy configuration")

        self.pa.getModel { m in
            model = m
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        let authorizedProperties = model?.privacyModel?.authorizedPropertyKeys

        XCTAssertEqual(authorizedProperties?["page.display"], ["property1", "property3"])
        XCTAssertEqual(authorizedProperties?["click.exit"], ["property1", "property3"])
        XCTAssertEqual(authorizedProperties?["click.navigation"], ["property1", "property3"])
        XCTAssertEqual(authorizedProperties?["custom.specific.event"], ["property1", "property3"])
        XCTAssertEqual(authorizedProperties?[""], ["property1", "property3"])
    }

    func testExemptPrivacyIncludePropertiesDefault() throws {
        // given
        let properties = ["property1", "property3"]
        var model: Model?

        self.pa.privacySetMode("exempt")

        // when
        self.pa.privacyIncludeProperties(properties)

        // then
        let expectation = self.expectation(description: "Privacy configuration")
        self.pa.getModel { m in
            model = m
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        let authorizedProperties = model?.privacyModel?.authorizedPropertyKeys

        XCTAssertEqual(authorizedProperties?["*"], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard]?.union(["property1", "property3"]))
    }

    func testExemptPrivacyIncludePropertiesPrivacyModesNil() throws {
        // given
        let properties = ["property1", "property3"]
        var modeExempt: String?
        var modeOptin: String?
        var modeOptOut: String?
        var exemptAuthorizedProperties: [String: Set<String>]?
        var optinAuthorizedProperties: [String: Set<String>]?
        var optoutAuthorizedProperties: [String: Set<String>]?

        // when
        self.pa.privacyIncludeProperties(properties, privacyModes: nil, eventNames: nil)

        // then
        let expectation = self.expectation(description: "Privacy configuration")
        self.pa.privacySetMode("exempt")
        self.pa.getModel { m in
            modeExempt = m.privacyModel?.visitorMode
            exemptAuthorizedProperties = m.privacyModel?.authorizedPropertyKeys
        }
        self.pa.privacySetMode("optin")
        self.pa.getModel { m in
            modeOptin = m.privacyModel?.visitorMode
            optinAuthorizedProperties = m.privacyModel?.authorizedPropertyKeys
        }
        self.pa.privacySetMode("optout")
        self.pa.getModel { m in
            modeOptOut = m.privacyModel?.visitorMode
            optoutAuthorizedProperties = m.privacyModel?.authorizedPropertyKeys
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(modeExempt, "exempt")
        XCTAssertEqual(exemptAuthorizedProperties?["*"], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard]?.union(["property1", "property3"]))
        XCTAssertEqual(modeOptin, "optin")
        XCTAssertEqual(optinAuthorizedProperties?["*"], PA.Privacy.Mode.OptIn.AllowedProperties[PA.Privacy.Wildcard]?.union(["property1", "property3"]))
        XCTAssertEqual(modeOptOut, "optout")
        XCTAssertEqual(optoutAuthorizedProperties?["*"], PA.Privacy.Mode.OptOut.AllowedProperties[PA.Privacy.Wildcard]?.union(["property1", "property3"]))
    }

    func testExemptPrivacyIncludePropertiesEventNamesNil() throws {
        // given
        let properties = ["property1", "property3"]
        var model: Model?

        self.pa.privacySetMode("exempt")

        // when
        self.pa.privacyIncludeProperties(properties, privacyModes: ["exempt"], eventNames: nil)

        // then
        let expectation = self.expectation(description: "Privacy configuration")
        self.pa.getModel { m in
            model = m
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        let authorizedProperties = model?.privacyModel?.authorizedPropertyKeys

        XCTAssertEqual(authorizedProperties?["*"], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard]?.union(["property1", "property3"]))
    }

    func testExemptPrivacyIncludePropertiesPrivacyModesAndEventNamesNil() throws {
        // given
        let properties = ["property1", "property3"]
        var model: Model?

        self.pa.privacySetMode("exempt")

        // when
        self.pa.privacyIncludeProperties(properties, privacyModes: nil, eventNames: nil)

        // then
        let expectation = self.expectation(description: "Privacy configuration")
        self.pa.getModel { m in
            model = m
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        let authorizedProperties = model?.privacyModel?.authorizedPropertyKeys

        XCTAssertEqual(authorizedProperties?["*"], PA.Privacy.Mode.Exempt.AllowedProperties[PA.Privacy.Wildcard]?.union(["property1", "property3"]))
    }

    func testExemptOptInPrivacyIncludeProperties() throws {
        let properties = ["property1", "property3"]
        let privacyModes = ["exempt", "optin"]
        let eventNames = ["page.display"]
        var modeExempt: String?
        var modeOptIn: String?
        var modeOptOut: String?
        var exemptAuthorizedProperties: [String: Set<String>]?
        var optinAuthorizedProperties: [String: Set<String>]?
        var optoutAuthorizedProperties: [String: Set<String>]?

        self.pa.privacyIncludeProperties(properties, privacyModes: privacyModes, eventNames: eventNames)

        let expectation = self.expectation(description: "Privacy configuration")

        self.pa.privacySetMode("exempt")
        self.pa.getModel { m in
            modeExempt = m.privacyModel?.visitorMode
            exemptAuthorizedProperties = m.privacyModel?.authorizedPropertyKeys
        }
        self.pa.privacySetMode("optin")
        self.pa.getModel { m in
            modeOptIn = m.privacyModel?.visitorMode
            optinAuthorizedProperties = m.privacyModel?.authorizedPropertyKeys
        }
        self.pa.privacySetMode("optout")
        self.pa.getModel { m in
            modeOptOut = m.privacyModel?.visitorMode
            optoutAuthorizedProperties = m.privacyModel?.authorizedPropertyKeys
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(modeExempt, "exempt")
        XCTAssertEqual(exemptAuthorizedProperties?["page.display"], ["property1", "property3"])
        XCTAssertEqual(modeOptIn, "optin")
        XCTAssertEqual(optinAuthorizedProperties?["page.display"], ["property1", "property3"])
        XCTAssertEqual(modeOptOut, "optout")
        XCTAssertEqual(optoutAuthorizedProperties?["page.display"], nil)
    }

    func testIsAuthorizedEvent() throws {
        let configurationStep = ConfigurationStep.shared(nil)
        let privacyStep = PrivacyStep.shared(configurationStep)
        let eventName = "test.event"
        var authorizedEvents: Set<String> = []
        var forbiddenEvents: Set<String> = []

        XCTAssertFalse(privacyStep.isAuthorizedEventName(eventName, authorizedEventNames: authorizedEvents, forbiddenEventNames: forbiddenEvents))

        authorizedEvents = ["test"]
        XCTAssertFalse(privacyStep.isAuthorizedEventName(eventName, authorizedEventNames: authorizedEvents, forbiddenEventNames: forbiddenEvents))

        authorizedEvents = ["*"]
        XCTAssertTrue(privacyStep.isAuthorizedEventName(eventName, authorizedEventNames: authorizedEvents, forbiddenEventNames: forbiddenEvents))

        authorizedEvents = ["test.*"]
        XCTAssertTrue(privacyStep.isAuthorizedEventName(eventName, authorizedEventNames: authorizedEvents, forbiddenEventNames: forbiddenEvents))

        authorizedEvents = ["test.event"]
        XCTAssertTrue(privacyStep.isAuthorizedEventName(eventName, authorizedEventNames: authorizedEvents, forbiddenEventNames: forbiddenEvents))

        forbiddenEvents = ["test"]
        XCTAssertTrue(privacyStep.isAuthorizedEventName(eventName, authorizedEventNames: authorizedEvents, forbiddenEventNames: forbiddenEvents))

        forbiddenEvents = ["*"]
        XCTAssertFalse(privacyStep.isAuthorizedEventName(eventName, authorizedEventNames: authorizedEvents, forbiddenEventNames: forbiddenEvents))

        forbiddenEvents = ["test.*"]
        XCTAssertFalse(privacyStep.isAuthorizedEventName(eventName, authorizedEventNames: authorizedEvents, forbiddenEventNames: forbiddenEvents))

        forbiddenEvents = ["test.event"]
        XCTAssertFalse(privacyStep.isAuthorizedEventName(eventName, authorizedEventNames: authorizedEvents, forbiddenEventNames: forbiddenEvents))
    }

}
