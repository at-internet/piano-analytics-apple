//
//  Configuration.swift
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

public enum ConfigurationKey: String {
    case CollectDomain = "collectDomain"
    case CrashDetection = "crashDetection"
    case CustomUserAgent = "customUserAgent"
    case PrivacyDefaultMode = "privacyDefaultMode"
    case IgnoreLimitedAdTracking = "ignoreLimitedAdTracking"
    case OfflineEncryptionMode = "offlineEncryptionMode"
    case OfflineSendInterval = "offlineSendInterval"
    case OfflineStorageMode = "offlineStorageMode"
    case Path = "path"
    case SendEventWhenOptout = "sendEventWhenOptout"
    case SessionBackgroundDuration = "sessionBackgroundDuration"
    case Site = "site"
    case StorageLifetimePrivacy = "storageLifetimePrivacy"
    case StorageLifetimeUser = "storageLifetimeUser"
    case StorageLifetimeVisitor = "storageLifetimeVisitor"
    case VisitorStorageMode = "visitorStorageMode"
    case VisitorIdType = "visitorIdType"
    case VisitorId = "visitorId"
}

public enum VisitorIdType: String {
    case UUID = "uuid"
    case IDFA = "idfa"
    case IDFV = "idfv"
    case Custom = "custom"
}

public enum OfflineStorageMode: String {
    case Always = "always"
    case Required = "required"
    case Never = "never"
}

public enum VisitorStorageMode: String {
    case Fixed = "fixed"
    case Relative = "relative"
}

public enum EncryptionMode: String {
    case None = "none"
    case IfCompatible = "ifCompatible"
    case Force = "force"
}

public final class ConfigurationBuilder {

    // MARK: Constructors

    private final var configuration: [String: String] = [String: String]()

    public init() {

    }
    
    public init(parameters: [String:Any]) {
        for (rawKey, rawValue) in parameters {
            guard let key = ConfigurationKey(rawValue: rawKey) else {
                continue
            }
            switch key {
                case .CollectDomain:
                    let stringValue = rawValue as? String ?? String(describing: rawValue)
                    _ = self.withCollectDomain(stringValue)
                case .CrashDetection:
                    if let boolValue = rawValue as? Bool ?? Bool(String(describing: rawValue)) {
                        _ = self.enableCrashDetection(boolValue)
                    }
                case .CustomUserAgent:
                    let stringValue = rawValue as? String ?? String(describing: rawValue)
                    _ = self.withCustomUserAgent(stringValue)
                case .PrivacyDefaultMode:
                    let stringValue = rawValue as? String ?? String(describing: rawValue)
                    _ = self.withPrivacyDefaultMode(stringValue)
                case .IgnoreLimitedAdTracking:
                    if let boolValue = rawValue as? Bool ?? Bool(String(describing: rawValue)) {
                        _ = self.enableIgnoreLimitedAdTracking(boolValue)
                    }
                case .OfflineEncryptionMode:
                    let stringValue = rawValue as? String ?? String(describing: rawValue)
                    _ = self.withOfflineEncryptionMode(stringValue)
                case .OfflineSendInterval:
                    if let intValue = rawValue as? Int ?? Int(String(describing: rawValue)) {
                        _ = self.withOfflineSendInterval(intValue)
                    }
                case .OfflineStorageMode:
                    let stringValue = rawValue as? String ?? String(describing: rawValue)
                    _ = self.withOfflineStorageMode(stringValue)
                case .Path:
                    let stringValue = rawValue as? String ?? String(describing: rawValue)
                    _ = self.withPath(stringValue)
                case .SendEventWhenOptout:
                    if let boolValue = rawValue as? Bool ?? Bool(String(describing: rawValue)) {
                        _ = self.enableSendEventWhenOptout(boolValue)
                    }
                case .SessionBackgroundDuration:
                    if let intValue = rawValue as? Int ?? Int(String(describing: rawValue)) {
                        _ = self.withSessionBackgroundDuration(intValue)
                    }
                case .Site:
                    if let intValue = rawValue as? Int ?? Int(String(describing: rawValue)) {
                        _ = self.withSite(intValue)
                    }
                case .StorageLifetimePrivacy:
                    if let intValue = rawValue as? Int ?? Int(String(describing: rawValue)) {
                        _ = self.withStorageLifetimePrivacy(intValue)
                    }
                case .StorageLifetimeUser:
                    if let intValue = rawValue as? Int ?? Int(String(describing: rawValue)) {
                        _ = self.withStorageLifetimeUser(intValue)
                    }
                case .StorageLifetimeVisitor:
                    if let intValue = rawValue as? Int ?? Int(String(describing: rawValue)) {
                        _ = self.withStorageLifetimeVisitor(intValue)
                    }
                case .VisitorStorageMode:
                    let stringValue = rawValue as? String ?? String(describing: rawValue)
                    _ = self.withVisitorStorageMode(stringValue)
                case .VisitorIdType:
                    let stringValue = rawValue as? String ?? String(describing: rawValue)
                    _ = self.withVisitorIdType(stringValue)
                case .VisitorId:
                    let stringValue = rawValue as? String ?? String(describing: rawValue)
                    _ = self.withVisitorID(stringValue)
            }
        }
    }

    // MARK: PUBLIC SECTION

    /// Set a new collect endpoint to send your tagging data
    ///
    /// - Parameter collectDomain: fully qualified domain name (FQDN) collect
    /// - Returns: updated Builder instance.
    public final func withCollectDomain(_ collectDomain: String) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.CollectDomain, value: collectDomain)
    }

    /// Set a new site
    ///
    /// - Parameter site: site identifier
    /// - Returns: updated Builder instance.
    public final func withSite(_ site: Int) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.Site, value: site)
    }

    /// Set a new pixel path, to prevent potential tracking blockers by resource
    ///
    /// - Parameter path: a resource name string
    /// - Returns: updated Builder instance.
    public final func withPath(_ path: String) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.Path, value: path)
    }

    /// Set a type of visitorID
    ///
    /// - Parameter visitorIdType: a visitorID type
    /// - Returns: updated Builder instance.
    public final func withVisitorIdType(_ visitorIdType: String) -> ConfigurationBuilder {
        if let type = VisitorIdType.init(rawValue: visitorIdType) {
            return self.set(ConfigurationKey.VisitorIdType, value: type.rawValue)
        }
        return self.set(ConfigurationKey.VisitorIdType, value: VisitorIdType.UUID.rawValue)
    }

    /// Set an offline mode
    ///
    /// - Parameter offlineStorageMode: an offline mode
    /// - Returns: updated Builder instance.
    public final func withOfflineStorageMode(_ offlineStorageMode: String) -> ConfigurationBuilder {
        if let mode = OfflineStorageMode.init(rawValue: offlineStorageMode) {
            return self.set(ConfigurationKey.OfflineStorageMode, value: mode.rawValue)
        }
        return self.set(ConfigurationKey.OfflineStorageMode, value: OfflineStorageMode.Never.rawValue)
    }

    /// Enable/disable ignorance advertising tracking limitation
    ///
    /// - Parameter enabled: enabling ignorance
    /// - Returns: updated Builder instance.
    public final func enableIgnoreLimitedAdTracking(_ enabled: Bool) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.IgnoreLimitedAdTracking, value: enabled)
    }

    /// Enable/disable crash detection
    ///
    /// - Parameter enabled: enabling detection
    /// - Returns: updated Builder instance.
    public final func enableCrashDetection(_ enabled: Bool) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.CrashDetection, value: enabled)
    }

    /// Set a new expiration mode (UUID visitor ID only)
    ///
    /// - Parameter visitorStorageMode: a uuid expiration mode defined in enum
    /// - Returns: updated Builder instance.
    public final func withVisitorStorageMode(_ visitorStorageMode: String) -> ConfigurationBuilder {
        if let mode = VisitorStorageMode.init(rawValue: visitorStorageMode) {
            return self.set(ConfigurationKey.VisitorStorageMode, value: mode.rawValue)
        }
        return self.set(ConfigurationKey.VisitorStorageMode, value: VisitorStorageMode.Fixed.rawValue)
    }

    /// Set a new duration before user info expires
    ///
    /// - Parameter storageLifetimeUser: storage duration in days
    /// - Returns: updated Builder instance.
    public final func withStorageLifetimeUser(_ storageLifetimeUser: Int) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.StorageLifetimeUser, value: storageLifetimeUser)
    }

    /// Set a new duration before UUID expires (UUID visitor ID only)
    ///
    /// - Parameter storageLifetimeVisitor: a uuid expiration duration (in days)
    /// - Returns: updated Builder instance.
    public final func withStorageLifetimeVisitor(_ storageLifetimeVisitor: Int) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.StorageLifetimeVisitor, value: storageLifetimeVisitor)
    }

    /// Set a new duration before privacy related configurations expire
    ///
    /// - Parameter storageLifetimePrivacy: an expiration duration (in days) for privacy related configurations
    /// - Returns: updated Builder instance.
    public final func withStorageLifetimePrivacy(_ storageLifetimePrivacy: Int) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.StorageLifetimePrivacy, value: storageLifetimePrivacy)
    }

    /// Set a new encryption mode
    ///
    /// - Parameter offlineEncryptionMode: an encryption mode for at-rest data
    /// - Returns: updated Builder instance.
    public final func withOfflineEncryptionMode(_ offlineEncryptionMode: String) -> ConfigurationBuilder {
        if let mode = VisitorStorageMode.init(rawValue: offlineEncryptionMode) {
            return self.set(ConfigurationKey.OfflineEncryptionMode, value: mode.rawValue)
        }
        return self.set(ConfigurationKey.OfflineEncryptionMode, value: EncryptionMode.IfCompatible.rawValue)
    }

    /// Set a new session background duration before a new session will be created
    ///
    /// - Parameter sessionBackgroundDuration: a session background duration (in seconds)
    /// - Returns: updated Builder instance.
    public final func withSessionBackgroundDuration(_ sessionBackgroundDuration: Int) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.SessionBackgroundDuration, value: sessionBackgroundDuration)
    }

    /// Allow hit sending when user is opt-out
    ///
    /// - Parameter sendEventWhenOptout: allow hit sending
    /// - Returns: updated Builder instance.
    public final func enableSendEventWhenOptout(_ sendEventWhenOptout: Bool) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.SendEventWhenOptout, value: sendEventWhenOptout)
    }

    /// Set a new custom visitor ID
    ///
    /// - Parameter visitorID: custom visitor ID
    /// - Returns: updated Builder instance.
    public final func withVisitorID(_ visitorID: String) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.VisitorId, value: visitorID)
            .withVisitorIdType(VisitorIdType.Custom.rawValue)
    }

    /// Set a new custom user agent
    ///
    /// - Parameter userAgent: custom user agent
    /// - Returns: updated Builder instance.
    public final func withCustomUserAgent(_ userAgent: String) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.CustomUserAgent, value: userAgent)
    }
    
    /// Set a new privacy default mode
    ///
    /// - Parameter privacyDefaultMode: name of the privacy mode to set by default
    /// - Returns: updated Builder instance.
    public final func withPrivacyDefaultMode(_ privacyDefaultMode: String) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.PrivacyDefaultMode, value: privacyDefaultMode)
    }
    
    /// Set a new offline send interval
    ///
    /// - Parameter offlineSendInterval: minimum interval to wait for when sending offline events, in milliseconds
    /// - Returns: updated Builder instance.
    public final func withOfflineSendInterval(_ offlineSendInterval: Int) -> ConfigurationBuilder {
        return self.set(ConfigurationKey.OfflineSendInterval, value: offlineSendInterval)
    }

    /// Get a new Configuration instance from Builder data set
    ///
    /// - Returns: a Configuration instance
    public final func build() -> Configuration {
        let c = Configuration()
        c.parameters = self.configuration
        return c
    }

    // MARK: Private methods

    private final func set(_ key: ConfigurationKey, value: Any) -> ConfigurationBuilder {
        self.configuration[key.rawValue] = String(describing: value)
        return self
    }

}

public final class Configuration {

    // MARK: PUBLIC SECTION

    public final func get(_ key: ConfigurationKey) -> String {
        return self.parameters[key.rawValue] ?? ""
    }

    // MARK: Constructors

    private final let rootProperties: Set<String> = [
        ConfigurationKey.CollectDomain.rawValue,
        ConfigurationKey.Path.rawValue,
        ConfigurationKey.Site.rawValue,
        ConfigurationKey.VisitorId.rawValue,
        ConfigurationKey.VisitorIdType.rawValue,
        ConfigurationKey.CustomUserAgent.rawValue
    ]
    final var parameters: [String: String] = [String: String]()

    init() {}

    init(file: String?) {
        self.loadDefaultConfiguration()

        if let loc = file, !loc.isEmpty() {
            self.loadConfigurationFromFile(configFileLocation: loc)
        }
    }

    init(c: Configuration) {
        _ = self.merge(c: c)
    }

    // MARK: Package methods

    final func getRootConfiguration() -> Configuration {
        let c = Configuration()
        c.parameters = self.parameters.filter { self.rootProperties.contains($0.key) }
        return c
    }

    final func containsKey(_ key: ConfigurationKey) -> Bool {
        return self.parameters[key.rawValue] != nil
    }

    final func set(_ key: ConfigurationKey, value: String) {
        self.parameters[key.rawValue] = value
    }

    final func merge(c: Configuration) -> Configuration {
        self.parameters.merge(c.parameters) { (_, new) in String(describing: new) }
        return self
    }

    // MARK: Private methods

    private final func loadDefaultConfiguration() {
        var path = Bundle(for: type(of: self)).path(forResource: PA.Configuration.Default, ofType: PA.Configuration.Extension)
        if path == nil {
            // used to access the default.json file with SPM
            #if SPM
            path = Bundle.module.path(forResource: PA.Configuration.Default, ofType: PA.Configuration.Extension)
            #endif
        }
        guard let path = path,
              let result = PianoAnalyticsUtils.JSONFileToMap(path: path) else {
            fatalError("PianoAnalytics: a default config should be provided inside the framework")
        }

        for (key, value) in result {
            if let k = ConfigurationKey.init(rawValue: key) {
                self.set(k, value: value)
            }
        }
    }

    private final func loadConfigurationFromFile(configFileLocation: String) {
        guard let optPath = Bundle.main.path(forResource: configFileLocation, ofType: PA.Configuration.Extension),
              let result = PianoAnalyticsUtils.JSONFileToMap(path: optPath) else {
            return
        }

        for (key, value) in result {
            if let k = ConfigurationKey.init(rawValue: key) {
                self.set(k, value: value)
            }
        }
    }

}
