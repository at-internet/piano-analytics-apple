//
//  Model.swift
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

public final class Model {

    // MARK: Constructors

    public internal(set) var configuration: Configuration = Configuration()
    public internal(set) var events: [Event] = [Event]()
    public internal(set) var contextProperties: [String: ContextProperty] = [String: ContextProperty]()
    public internal(set) var storage: [String: BuiltModel] = [String: BuiltModel]()
    public internal(set) var privacyModel: PrivacyModel?
    public internal(set) var builtModel: BuiltModel?
    // TODO android get public set private, vérifier que ça fonctionne
    // TODO idem visitorId
    public final var visitorId: String {
        get {
            return self.configuration.get(ConfigurationKey.VisitorId)
        }
    }
    public final var activeUser: User?
    public final var storedUser: User?

    final var customerContextModel: CustomerContextModel?
    final var user: User?
    final var userModel: UserModel?
    final var storageDaysRemaining: Int?

    init() {

    }

    func addContextProperties(_ properties: [String: ContextProperty]) {
        contextProperties.merge(properties) { (_, new) in new }
    }
}

public final class BuiltModel {

    // MARK: Constructors

    public final let uri: String?
    public final let body: String?
    public final let chunks: [String]?
    final let mustBeSaved: Bool

    init(uri: String?, body: String?, chunks: [String]?, mustBeSaved: Bool) {
        self.uri = uri
        self.body = body
        self.chunks = chunks
        self.mustBeSaved = mustBeSaved
    }
}

public struct PrivacyModel {

    // MARK: Enum

    enum UpdateDataKey {
        case VisitorMode
        case EventNames
        case Properties
        case Storage
        case CreateVisitorMode
    }

    // MARK: Constructors

    public let visitorMode: String
    public let authorizedPropertyKeys: [String: Set<String>]?
    public let forbiddenPropertyKeys: [String: Set<String>]?
    public let authorizedEventNames: Set<String>?
    public let forbiddenEventNames: Set<String>?
    public let storageKeys: Set<String>?
    public let forbiddenStorageKeys: Set<String>?
    public let duration: Int?
    public let visitorConsent: Bool?
    public let customVisitorId: String?
    let updateData: UpdateDataKey?

    init(
        visitorMode: String,
        authorizedPropertyKeys: [String: Set<String>]? = nil,
        forbiddenPropertyKeys: [String: Set<String>]? = nil,
        authorizedEventNames: Set<String>? = nil,
        forbiddenEventNames: Set<String>? = nil,
        storageKeys: Set<String>? = nil,
        forbiddenStorageKeys: Set<String>? = nil,
        duration: Int? = nil,
        visitorConsent: Bool? = nil,
        customVisitorId: String? = nil,
        updateData: UpdateDataKey? = nil
    ) {
        self.visitorMode = visitorMode
        self.authorizedPropertyKeys = authorizedPropertyKeys
        self.forbiddenPropertyKeys = forbiddenPropertyKeys
        self.authorizedEventNames = authorizedEventNames
        self.forbiddenEventNames = forbiddenEventNames
        self.storageKeys = storageKeys
        self.forbiddenStorageKeys = forbiddenStorageKeys
        self.duration = duration
        self.visitorConsent = visitorConsent
        self.customVisitorId = customVisitorId
        self.updateData = updateData
    }
}

final class CustomerContextModel {

    // MARK: Enum

    enum UpdateTypeKey {
        case Add
        case Delete
    }

    // MARK: Constructors

    let updateType: UpdateTypeKey?
    let properties: [String: Any]?
    let options: ContextPropertyOptions?

    init(updateType: UpdateTypeKey?, properties: [String: Any]?, options: ContextPropertyOptions? = nil) {
        self.updateType = updateType
        self.properties = properties
        self.options = options
    }
}

final class UserModel {

    // MARK: Enum

    enum UpdateTypeKey {
        case Set
        case Delete
    }

    // MARK: Constructors

    let updateType: UpdateTypeKey
    let user: User?
    let storageSiteId: Int
    let enableStorage: Bool

    init(updateType: UpdateTypeKey, user: User? = nil, enableStorage: Bool = true, storageSiteId: Int = 0) {
        self.updateType = updateType
        self.user = user
        self.enableStorage = enableStorage
        self.storageSiteId = storageSiteId
    }
}
