//
//  UsersTests.swift
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

class UsersTests: XCTestCase {

    var pa = PianoAnalytics.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        clearStorage()
        self.pa = PianoAnalytics(configFileLocation: "default-test.json")
        pa.deleteOfflineData()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        pa.deleteOfflineData()
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

    // MARK: - SET USER
    //    "Should add a user using setUser"
    func testSetUserShouldAddUser() throws {
        let expectation = self.expectation(description: "Stored users")
        var model: Model = Model()
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setUser("123", category: "456789")

        self.pa.getModel { m in
            model = m
        }
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
        XCTAssertEqual(events1.first?.data["user_id"] as? String, "123")
        XCTAssertEqual(events1.first?.data["user_category"] as? String, "456789")
        XCTAssertEqual(events1.first?.data["user_recognition"] as? Bool, false)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["user_id"] as? String, "123")
        XCTAssertEqual(events2.first?.data["user_category"] as? String, "456789")
        XCTAssertEqual(events2.first?.data["user_recognition"] as? Bool, false)
        XCTAssertEqual(model.user?.id, "123")
        XCTAssertEqual(model.user?.category, "456789")
        XCTAssertEqual(model.activeUser?.id, "123")
        XCTAssertEqual(model.activeUser?.category, "456789")
        XCTAssertEqual(model.storedUser?.id, "123")
        XCTAssertEqual(model.storedUser?.category, "456789")
    }

    //    "Should add a user using setUser without storing it"
    func testSetUserShouldAddUserWithoutStoringIt() throws {
        let expectation = self.expectation(description: "Stored users")
        var model: Model = Model()
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setUser("123", category: "456789", enableStorage: false)

        self.pa.getModel { m in
            model = m
        }
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
        XCTAssertEqual(events1.first?.data["user_id"] as? String, "123")
        XCTAssertEqual(events1.first?.data["user_category"] as? String, "456789")
        XCTAssertEqual(events1.first?.data["user_recognition"] as? Bool, false)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["user_id"] as? String, "123")
        XCTAssertEqual(events2.first?.data["user_category"] as? String, "456789")
        XCTAssertEqual(events2.first?.data["user_recognition"] as? Bool, false)
        XCTAssertEqual(model.user?.id, "123")
        XCTAssertEqual(model.user?.category, "456789")
        XCTAssertEqual(model.activeUser?.id, "123")
        XCTAssertEqual(model.activeUser?.category, "456789")
        XCTAssertEqual(model.storedUser?.id, nil)
        XCTAssertEqual(model.storedUser?.category, nil)
    }
    //    "Should add a user from stored user data"
    func testShouldAddUserFromStoredUserData() throws {
        let expectation = self.expectation(description: "Stored users")
        var model: Model = Model()
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        UserDefaults.standard.set(["user": "{\"id\":\"123\",\"category\":\"456789\"}"], forKey: UserKeys.Users.rawValue)
        UserDefaults.standard.set(Int64(Date().timeIntervalSince1970) * 1000, forKey: UserKeys.UserGenerationTimestamp.rawValue)

        self.pa.getModel { m in
            model = m
        }
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
        XCTAssertEqual(events1.first?.data["user_id"] as? String, "123")
        XCTAssertEqual(events1.first?.data["user_category"] as? String, "456789")
        XCTAssertEqual(events1.first?.data["user_recognition"] as? Bool, true)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["user_id"] as? String, "123")
        XCTAssertEqual(events2.first?.data["user_category"] as? String, "456789")
        XCTAssertEqual(events2.first?.data["user_recognition"] as? Bool, true)
        XCTAssertEqual(model.user?.id, "123")
        XCTAssertEqual(model.user?.category, "456789")
        XCTAssertEqual(model.activeUser?.id, nil)
        XCTAssertEqual(model.activeUser?.category, nil)
        XCTAssertEqual(model.storedUser?.id, "123")
        XCTAssertEqual(model.storedUser?.category, "456789")
    }

    // MARK: - GET USER
    //    "Should retrieve user properties set if no stored data using getUser"
    func testGetUserShouldRetrieveSetUserWithoutStorage() throws {
        let expectation = self.expectation(description: "Stored users")
        var model: Model = Model()
        var localUser: User?
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setUser("123", category: "456789", enableStorage: false)

        self.pa.getModel { m in
            model = m
        }
        self.pa.getUser(completionHandler: { user in
            localUser = user
        })
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
        XCTAssertEqual(events1.first?.data["user_id"] as? String, "123")
        XCTAssertEqual(events1.first?.data["user_category"] as? String, "456789")
        XCTAssertEqual(events1.first?.data["user_recognition"] as? Bool, false)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["user_id"] as? String, "123")
        XCTAssertEqual(events2.first?.data["user_category"] as? String, "456789")
        XCTAssertEqual(events2.first?.data["user_recognition"] as? Bool, false)
        XCTAssertEqual(localUser?.id, "123")
        XCTAssertEqual(localUser?.category, "456789")
        XCTAssertEqual(model.activeUser?.id, "123")
        XCTAssertEqual(model.activeUser?.category, "456789")
        XCTAssertEqual(model.storedUser?.id, nil)
        XCTAssertEqual(model.storedUser?.category, nil)
    }

    // MARK: - DELETE USER
    //    "Should delete user data using deleteUser"
    func testDeleteUserShouldDeleteActiveAndStoredUser() throws {
        let expectation = self.expectation(description: "Stored users")
        var model: Model = Model()
        var localUser: User?
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setUser("123", category: "456789")
        self.pa.deleteUser()

        self.pa.getModel { m in
            model = m
        }
        self.pa.getUser(completionHandler: { user in
            localUser = user
        })
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
        XCTAssertEqual(events1.first?.data["user_id"] as? String, nil)
        XCTAssertEqual(events1.first?.data["user_category"] as? String, nil)
        XCTAssertEqual(events1.first?.data["user_recognition"] as? Bool, nil)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["user_id"] as? String, nil)
        XCTAssertEqual(events2.first?.data["user_category"] as? String, nil)
        XCTAssertEqual(events2.first?.data["user_recognition"] as? Bool, nil)
        XCTAssertEqual(localUser?.id, nil)
        XCTAssertEqual(localUser?.category, nil)
        XCTAssertEqual(model.activeUser?.id, nil)
        XCTAssertEqual(model.activeUser?.category, nil)
        XCTAssertEqual(model.storedUser?.id, nil)
        XCTAssertEqual(model.storedUser?.category, nil)
    }

    //    "Should delete user data using deleteUser"
    func testDeleteUserShouldDeleteUserAndAllowNewSetUser() throws {
        let expectation = self.expectation(description: "Stored users")
        var model: Model = Model()
        var localUser: User?
        var localBuilt1: BuiltModel?
        var localBuilt2: BuiltModel?

        self.pa.setUser("123", category: "456789")
        self.pa.deleteUser()

        self.pa.getModel { m in
            model = m
        }
        self.pa.getUser(completionHandler: { user in
            localUser = user
        })
        self.pa.sendEvent(Event("toto", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt1 = built
        })

        self.pa.setUser("myId", category: "myCategory")
        self.pa.sendEvent(Event("tata", data: [:]), config: nil, p: TestProtocol { built, _ in
            localBuilt2 = built
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5, handler: nil)
        let events1 = parseEvents(localBuilt1?.body ?? "")
        let events2 = parseEvents(localBuilt2?.body ?? "")
        XCTAssertEqual(events1.first?.name, "toto")
        XCTAssertEqual(events1.first?.data["user_id"] as? String, nil)
        XCTAssertEqual(events1.first?.data["user_category"] as? String, nil)
        XCTAssertEqual(events1.first?.data["user_recognition"] as? Bool, nil)
        XCTAssertEqual(localUser?.id, nil)
        XCTAssertEqual(localUser?.category, nil)
        XCTAssertEqual(model.activeUser?.id, nil)
        XCTAssertEqual(model.activeUser?.category, nil)
        XCTAssertEqual(model.storedUser?.id, nil)
        XCTAssertEqual(model.storedUser?.category, nil)
        XCTAssertEqual(events2.first?.name, "tata")
        XCTAssertEqual(events2.first?.data["user_id"] as? String, "myId")
        XCTAssertEqual(events2.first?.data["user_category"] as? String, "myCategory")
        XCTAssertEqual(events2.first?.data["user_recognition"] as? Bool, false)
    }

}
