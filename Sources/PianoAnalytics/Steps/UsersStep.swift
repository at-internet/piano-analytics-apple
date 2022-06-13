//
//  UsersStep.swift
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

import Foundation

final class UsersStep: Step {

    // MARK: Constructors

    private static var _instance: UsersStep?
    static let shared: (PrivacyStep) -> UsersStep = { ps in
        if _instance == nil {
            _instance = UsersStep(ps)
        }
        return _instance ?? UsersStep(ps)
    }

    private let privacyStep: PrivacyStep
    private var user: User?
    private var userRecognition: Bool = false

    init(_ ps: PrivacyStep) {
        if (UserDefaults.standard.value(forKey: UserKeys.Users.rawValue) == nil) {
            if let oldValue = UserDefaults.standard.value(forKey: ATUserKeys.Users.rawValue) {
                UserDefaults.standard.set(oldValue, forKey: UserKeys.Users.rawValue)
                UserDefaults.standard.set(Int64(Date().timeIntervalSince1970) * 1000, forKey: UserKeys.UserGenerationTimestamp.rawValue)
                UserDefaults.standard.removeObject(forKey: ATUserKeys.Users.rawValue)
            }
        }

        self.privacyStep = ps
    }

    // MARK: Constants

    static let Active = "active"
    static let Stored = "stored"

    // MARK: Private methods

    private final func getUser(config: Configuration) -> User? {
        if let user = user {
            userRecognition = false
            return user
        }

        userRecognition = true
        return getStoredUser(config: config) ?? nil
    }

    private final func getStoredUser(config: Configuration) -> User? {

        let now = Int64(Date().timeIntervalSince1970) * 1000
        let userDuration = config.get(ConfigurationKey.StorageLifetimeUser).toInt()

        /// get user generation timestamp
        guard let userGenerationTimestamp = UserDefaults.standard.object(forKey: UserKeys.UserGenerationTimestamp.rawValue) as? Int64 else {
            return nil
        }

        /// remove user from storage if expired
        let daysSinceGeneration = (now - userGenerationTimestamp) / Int64(PA.Time.DayInMs)
        if daysSinceGeneration >= userDuration {
            privacyStep.storeData(PA.Privacy.Storage.User, pairs:
                (UserKeys.Users.rawValue, nil),
                (UserKeys.UserGenerationTimestamp.rawValue, nil)
            )
            return nil
        }

        guard let storedValue = UserDefaults.standard.dictionary(forKey: UserKeys.Users.rawValue) as? [String: String] else {
            return nil
        }

        return User(PianoAnalyticsUtils.fromJSONData(Data((storedValue["user"] ?? "").utf8)))
    }

    private final func getProperties(_ storageSiteId: String, user: User?) -> [String: ContextProperty] {
        var properties: [String: ContextProperty] = [:]
        guard let user = user else {
            return properties
        }

        if let id = user.id {
            properties["user_id"] = ContextProperty(value: id)
            properties["user_recognition"] = ContextProperty(value: userRecognition)
        }

        if let category = user.category {
            properties["user_category"] = ContextProperty(value: category)
        }

        return properties
    }

    // MARK: Step Implementation

    func processUpdateContext(m: inout Model) {
        guard let userModel = m.userModel else {
            return
        }

        /// REQUIREMENTS
        let conf = m.configuration
        let now = Int64(Date().timeIntervalSince1970) * 1000

        switch userModel.updateType {
        case UserModel.UpdateTypeKey.Set:
            user = userModel.user

            if conf.get(ConfigurationKey.StorageLifetimeUser).toInt() > 0 && userModel.enableStorage {
                privacyStep.storeData(PA.Privacy.Storage.User, pairs:
                    (UserKeys.Users.rawValue, ["user": user?.toString()]),
                    (UserKeys.UserGenerationTimestamp.rawValue, now)
                )
            }
        case UserModel.UpdateTypeKey.Delete:
            user = nil
            userRecognition = false

            if conf.get(ConfigurationKey.StorageLifetimeUser).toInt() > 0 {
                privacyStep.storeData(PA.Privacy.Storage.User, pairs:
                    (UserKeys.Users.rawValue, nil),
                    (UserKeys.UserGenerationTimestamp.rawValue, nil)
                )
            }
        }
    }

    func processGetModel(m: inout Model) {
        m.user = getUser(config: m.configuration)
        m.activeUser = user
        m.storedUser = getStoredUser(config: m.configuration)
    }

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        /// REQUIREMENTS
        let conf = m.configuration

        m.user = getUser(config: conf)
        m.addContextProperties(getProperties(conf.get(ConfigurationKey.Site), user: m.user))

        return true
    }
}
