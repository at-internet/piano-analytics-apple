//
//  PianoAnalytics.swift
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

public let pa = PianoAnalytics.shared

public protocol PianoAnalyticsWorkProtocol {
    /// Called when raw data is available and customer want to override it before building
    ///
    /// - Parameter model: all computed data
    /// - Returns: boolean indicates if process have to continue
    func onBeforeBuild(model: inout Model) -> Bool

    /// Called when raw data is available and customer want to override it before building
    ///
    /// - Parameter built: built data
    /// - Parameter stored: stored data
    /// - Returns: boolean indicates if process have to continue
    func onBeforeSend(built: BuiltModel?, stored: [String: BuiltModel]?) -> Bool
}

public final class PianoAnalytics {

    // MARK: PUBLIC SECTION
    
    /// SDK version
    public static let sdkVersion = "3.1.8"

    /// Send event
    ///
    /// - Parameter event: a custom event
    /// - Parameter config: custom config used only for this action
    /// - Parameter p: protocol to leave customer handling
    public final func sendEvent(_ event: Event, config: Configuration? = nil, p: PianoAnalyticsWorkProtocol? = nil) {
        sendEvents([event], config: config, p: p)
    }

    /// Send events
    ///
    /// - Parameter events: a custom event list
    /// - Parameter config: custom config used only for this action
    /// - Parameter p: protocol to leave customer handling
    public final func sendEvents(_ events: [Event], config: Configuration? = nil, p: PianoAnalyticsWorkProtocol? = nil) {
        let m = Model()
        m.events = events

        if let conf = config {
            if conf.containsKey(ConfigurationKey.VisitorId) {
                conf.set(ConfigurationKey.VisitorIdType, value: VisitorIdType.Custom.rawValue)
            }
            m.configuration = conf.getRootConfiguration()
        }

        queue.push(ProcessingType.SendEvents, m: m, p: p)
    }
    
    /// Get configuration
    ///
    /// - Parameter key: configuration key to get
    public final func getConfiguration(_ key: ConfigurationKey, completionHandler: ((_ configuration: String) -> Void)?) {
        guard let completionHandler = completionHandler else {
            return
        }
        getModel { model in
            completionHandler(model.configuration.get(key))
        }
    }

    /// Set configuration
    ///
    /// ```
    /// pa.setConfiguration(ConfigurationBuilder()
    ///     .withSiteID(123456)
    ///     .withCollectDomain("logx.xiti.com")
    ///     .build()
    /// )
    /// ```
    ///
    /// - Parameter config: configuration object
    public final func setConfiguration(_ config: Configuration) {
        let m = Model()
        m.configuration = config
        queue.push(ProcessingType.SetConfig, m: m, p: nil)
    }

    /// Set property
    ///
    /// - Parameter key: property key
    /// - Parameter value: property value
    /// - Parameter persistent: whether the property will be persistent or not
    /// - Parameter events: will send the property only those specific events
    public final func setProperty(key: String, value: Any, persistent: Bool = false, events: [String]? = nil) {
        setProperties([key: value], persistent: persistent, events: events)
    }

    /// Set properties
    ///
    /// - Parameter data: dictionary of properties to set
    /// - Parameter persistent: whether the properties will be persistent or not
    /// - Parameter events: will send the properties only those specific events
    public final func setProperties(_ data: [String: Any], persistent: Bool = false, events: [String]? = nil) {
        let model = Model()
        model.customerContextModel = CustomerContextModel(updateType: .Add, properties: PianoAnalyticsUtils.toFlatten(src: data), options: ContextPropertyOptions(persistent: persistent, events: events))
        queue.push(ProcessingType.UpdateContext, m: model, p: nil)
    }

    /// Delete property
    ///
    /// - Parameter key: property key
    public final func deleteProperty(key: String) {
        let model = Model()
        model.customerContextModel = CustomerContextModel(updateType: .Delete, properties: [key: true])
        queue.push(ProcessingType.UpdateContext, m: model, p: nil)
    }

    /// Get user
    public final func getUser(completionHandler: ((_ user: User?) -> Void)?) {
        guard let completionHandler = completionHandler else {
            return
        }
        getModel { model in
            completionHandler(model.user)
        }
    }

    /// Set user
    ///
    /// - Parameter id: new user id
    /// - Parameter category: new user category
    /// - Parameter enableStorage: to store user in user defaults
    public final func setUser(_ id: String, category: String? = nil, enableStorage: Bool = true) {
        let user = User(id, category: category)

        let model = Model()
        model.userModel = UserModel(updateType: UserModel.UpdateTypeKey.Set, user: user, enableStorage: enableStorage)
        queue.push(ProcessingType.UpdateContext, m: model, p: nil)
    }

    /// Delete current user
    public final func deleteUser() {
        let model = Model()
        model.userModel = UserModel(updateType: UserModel.UpdateTypeKey.Delete)
        queue.push(ProcessingType.UpdateContext, m: model, p: nil)
    }

    // MARK: Privacy

    /// Update privacy mode
    ///
    /// - Parameter mode: a privacy visitor mode
    public final func privacySetMode(_ mode: String) {
        let privacyModel = PrivacyModel(
            visitorMode: mode,
            visitorConsent: PA.Privacy.Modes[mode]?.visitorConsent,
            customVisitorId: PA.Privacy.Modes[mode]?.customVisitorId,
            updateData: PrivacyModel.UpdateDataKey.VisitorMode)
        let model = Model()
        model.privacyModel = privacyModel
        self.queue.push(ProcessingType.UpdatePrivacyContext, m: model, p: nil)
    }

    /// Get current privacy mode
    public final func privacyGetMode(completionHandler: ((_ privacyMode: String) -> Void)?) {
        guard let completionHandler = completionHandler else {
            return
        }
        getModel { model in
            let privacyMode = model.privacyModel?.visitorMode ?? ""
            completionHandler(privacyMode)
        }
    }
    
    /// Create custom privacy mode
    ///
    /// - Parameter mode: name of the custom privacy visitor mode
    /// - Parameter visitorConsent: value of the visitor privacy consent property
    public final func privacyCreateMode(_ mode: String, visitorConsent: Bool) {
        let privacyModel = PrivacyModel(
            visitorMode: mode,
            visitorConsent: visitorConsent,
            updateData: PrivacyModel.UpdateDataKey.CreateVisitorMode)
        let model = Model()
        model.privacyModel = privacyModel
        self.queue.push(ProcessingType.UpdatePrivacyContext, m: model, p: nil)
    }

    /// Add privacy visitor mode authorized event name
    ///
    /// - Parameter eventName: string of an event name appended with what is currently set
    /// - Parameter privacyModes: a set of privacy visitor modes or by default applies to all modes
    public final func privacyIncludeEvent(_ eventName: String, privacyModes: [String] = ["*"]) {
        privacyIncludeEvents([eventName], privacyModes: privacyModes)
    }

    /// Add privacy visitor mode authorized event names
    ///
    /// - Parameter eventNames: string set of event names appended with what is currently set
    /// - Parameter privacyModes: a set of privacy visitor modes or by default applies to all modes
    public final func privacyIncludeEvents(_ eventNames: [String], privacyModes: [String] = ["*"]) {
        for privacyMode in privacyModes {
            let privacyModel = PrivacyModel(visitorMode: privacyMode, authorizedEventNames: Set(eventNames), updateData: PrivacyModel.UpdateDataKey.EventNames)

            let m = Model()
            m.privacyModel = privacyModel
            queue.push(ProcessingType.UpdatePrivacyContext, m: m, p: nil)
        }
    }

    /// Add privacy visitor mode forbidden event name
    ///
    /// - Parameter eventName: string of an event name appended with what is currently set
    /// - Parameter privacyModes: a set of privacy visitor modes
    public final func privacyExcludeEvent(_ eventName: String, privacyModes: [String] = ["*"]) {
        privacyExcludeEvents([eventName], privacyModes: privacyModes)
    }

    /// Add privacy visitor mode forbidden event names
    ///
    /// - Parameter eventNames: string set of event names appended with what is currently set
    /// - Parameter privacyModes: a set of privacy visitor modes
    public final func privacyExcludeEvents(_ eventNames: [String], privacyModes: [String] = ["*"]) {
        for privacyMode in privacyModes {
            let privacyModel = PrivacyModel(visitorMode: privacyMode, forbiddenEventNames: Set(eventNames), updateData: PrivacyModel.UpdateDataKey.EventNames)

            let m = Model()
            m.privacyModel = privacyModel
            queue.push(ProcessingType.UpdatePrivacyContext, m: m, p: nil)
        }
    }

    /// Add privacy visitor mode authorized property for specific events
    ///
    /// - Parameter property: string property appended with what is currently set
    /// - Parameter privacyModes: array of privacy modes on which we will authorize the property, by default we authorize the property for all the privacy modes
    /// - Parameter eventNames: array of event names on which we will authorize the property, by default we authorize the property on all the events
    public final func privacyIncludeProperty(_ property: String, privacyModes: [String]? = ["*"], eventNames: [String]? = ["*"]) {
        privacyIncludeProperties([property], privacyModes: privacyModes, eventNames: eventNames)
    }

    /// Add privacy visitor mode authorized properties for specific events
    ///
    /// - Parameter properties: string set of properties appended with what is currently set
    /// - Parameter privacyModes: array of privacy modes on which we will authorize the properties, by default we authorize the properties for all the privacy modes
    /// - Parameter eventNames: array of event names on which we will authorize the properties, by default we authorize the properties on all the events
    public final func privacyIncludeProperties(_ properties: [String], privacyModes: [String]? = ["*"], eventNames: [String]? = ["*"]) {
        for privacyMode in privacyModes ?? ["*"] {
            var propertiesByEvents: [String: Set<String>] = [:]
            for eventName in eventNames ?? ["*"] {
                propertiesByEvents[eventName] = Set(properties)
            }
            let privacyModel = PrivacyModel(visitorMode: privacyMode, authorizedPropertyKeys: propertiesByEvents, updateData: PrivacyModel.UpdateDataKey.Properties)

            let m = Model()
            m.privacyModel = privacyModel
            queue.push(ProcessingType.UpdatePrivacyContext, m: m, p: nil)
        }
    }

    /// Add privacy visitor mode forbidden property for specific events
    ///
    /// - Parameter property: string property appended with what is currently set
    /// - Parameter privacyModes: array of privacy modes on which we will forbid the property, by default we forbid the property for all the privacy modes
    /// - Parameter eventNames: array of event names on which we will forbid the property, by default we forbid the property on all the events
    public final func privacyExcludeProperty(_ property: String, privacyModes: [String]? = ["*"], eventNames: [String]? = ["*"]) {
        privacyExcludeProperties([property], privacyModes: privacyModes, eventNames: eventNames)
    }

    /// Add privacy visitor mode forbidden properties for specific events
    ///
    /// - Parameter properties: string set of properties appended with what is currently set
    /// - Parameter privacyModes: array of privacy modes on which we will forbid the properties, by default we forbid the properties for all the privacy modes
    /// - Parameter eventNames: array of event names on which we will forbid the properties, by default we forbid the properties on all the events
    public final func privacyExcludeProperties(_ properties: [String], privacyModes: [String]? = ["*"], eventNames: [String]? = ["*"]) {
        for privacyMode in privacyModes ?? ["*"] {
            var propertiesByEvents: [String: Set<String>] = [:]
            for eventName in eventNames ?? ["*"] {
                propertiesByEvents[eventName] = Set(properties)
            }
            let privacyModel = PrivacyModel(visitorMode: privacyMode, forbiddenPropertyKeys: propertiesByEvents, updateData: PrivacyModel.UpdateDataKey.Properties)

            let m = Model()
            m.privacyModel = privacyModel
            queue.push(ProcessingType.UpdatePrivacyContext, m: m, p: nil)
        }
    }

    /// Add privacy visitor mode storage key
    ///
    /// - Parameter storageKey: string of authorized key to store data into device
    /// - Parameter privacyModes: an array of privacy visitor modes on which to include this key
    public final func privacyIncludeStorageKey(_ storageKey: String, privacyModes: [String]? = ["*"]) {
        privacyIncludeStorageKeys([storageKey], privacyModes: privacyModes)
    }

    /// Add privacy visitor mode storage keys
    ///
    /// - Parameter storageKeys: string set of authorized keys to store data into device
    /// - Parameter privacyModes: an array of privacy visitor modes on which to include these keys
    public final func privacyIncludeStorageKeys(_ storageKeys: [String], privacyModes: [String]? = ["*"]) {
        for privacyMode in privacyModes ?? ["*"] {
            var tempStorageKeys = Set<String>()
            storageKeys.forEach { storageKey in
                if PA.Privacy.DefaultStorageModes.contains(storageKey) {
                    tempStorageKeys.insert(storageKey)
                }
            }
            let privacyModel = PrivacyModel(visitorMode: privacyMode, storageKeys: tempStorageKeys, updateData: PrivacyModel.UpdateDataKey.Storage)

            let m = Model()
            m.privacyModel = privacyModel
            queue.push(ProcessingType.UpdatePrivacyContext, m: m, p: nil)
        }
    }
    
    /// Remove privacy visitor mode storage key
    ///
    /// - Parameter storageKey: string of forbidden key to store data into device
    /// - Parameter privacyModes: an array of privacy visitor modes on which to exclude this key
    public final func privacyExcludeStorageKey(_ storageKey: String, privacyModes: [String]? = ["*"]) {
        privacyExcludeStorageKeys([storageKey], privacyModes: privacyModes)
    }

    /// Remove privacy visitor mode storage keys
    ///
    /// - Parameter storageKeys: string set of forbidden keys to store data into device
    /// - Parameter privacyModes: an array of privacy visitor modes on which to exclude these keys
    public final func privacyExcludeStorageKeys(_ storageKeys: [String], privacyModes: [String]? = ["*"]) {
        for privacyMode in privacyModes ?? ["*"] {
            var tempStorageKeys = Set<String>()
            storageKeys.forEach { storageKey in
                if PA.Privacy.DefaultStorageModes.contains(storageKey) {
                    tempStorageKeys.insert(storageKey)
                }
            }
            let privacyModel = PrivacyModel(visitorMode: privacyMode, storageKeys: tempStorageKeys, updateData: PrivacyModel.UpdateDataKey.Storage)

            let m = Model()
            m.privacyModel = privacyModel
            queue.push(ProcessingType.UpdatePrivacyContext, m: m, p: nil)
        }
    }


    /// Send offline data stored on device
    ///
    /// - Parameter config: custom config used only for this action
    /// - Parameter p: protocol to leave customer handling
    public final func sendOfflineData(config: Configuration? = nil, p: PianoAnalyticsWorkProtocol? = nil) {
        let m = Model()
        if let conf = config {
            if conf.containsKey(ConfigurationKey.VisitorId) {
                conf.set(ConfigurationKey.VisitorIdType, value: VisitorIdType.Custom.rawValue)
            }
            m.configuration = conf.getRootConfiguration()
        }

        queue.push(ProcessingType.SendOfflineData, m: m, p: p)
    }

    /// Delete offline data stored on device and keep only remaining days
    ///
    /// - Parameter remaining: age of data which have to be kept (in days)
    public final func deleteOfflineData(remaining: Int? = nil) {
        let m = Model()
        m.storageDaysRemaining = remaining
        queue.push(ProcessingType.DeleteOfflineData, m: m, p: nil)
    }

    /// Get current visitor id
    public final func getVisitorId(completionHandler: ((_ visitorId: String) -> Void)?) {
        guard let ch = completionHandler else {
            return
        }
        getModel { model in
            ch(model.visitorId)
        }
    }

    /// Set current visitor id
    ///
    /// - Parameter visitorId: custom visitor id to force in upcoming events
    public final func setVisitorId(_ visitorId: String) {
        setConfiguration(ConfigurationBuilder()
            .withVisitorIdType(VisitorIdType.Custom.rawValue)
            .withVisitorID(visitorId)
            .build())
    }

    /// Get all data in the model
    public final func getModel(completionHandler: ((_ model: Model) -> Void)?) {
        guard let ch = completionHandler else {
            return
        }
        queue.getModelAsync(ch)
    }

    // MARK: Constants

    private static let ConfigFile = PA.Configuration.Location

    // MARK: Constructors

    private static var _instance: PianoAnalytics?

    /// Simple default init
    public static let shared: PianoAnalytics = sharedWithConfigurationFilePath(ConfigFile)

    /// Specific init with custom location configuration file
    ///
    /// - Parameter configFileLocation: file path from resources folder
    public static let sharedWithConfigurationFilePath: (String) -> PianoAnalytics = { configFileLocation in
        if _instance == nil {
            _instance = PianoAnalytics(configFileLocation: configFileLocation)
        }
        return _instance ?? PianoAnalytics(configFileLocation: configFileLocation)
    }
    
    // Specific init with extended configuration
    ///
    /// - Parameter configFileLocation: file path from resources folder
    public static let sharedWithExtendedConfiguration: (PA.ExtendedConfiguration) -> PianoAnalytics = { extendedConfiguration in
        if _instance == nil {
            _instance = PianoAnalytics(extendedConfiguration: extendedConfiguration)
        }
        return _instance ?? PianoAnalytics(extendedConfiguration: extendedConfiguration)
    }
    
    internal final let queue: WorkingQueue

    init(configFileLocation: String) {
        let extendedConfiguration = PA.ExtendedConfiguration(configFileLocation)
        self.queue = WorkingQueue(extendedConfiguration)
    }
    
    init(extendedConfiguration: PA.ExtendedConfiguration) {
        self.queue = WorkingQueue(extendedConfiguration)
    }
}
