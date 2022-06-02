//
//  PrivacyStep.swift
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

final class PrivacyStep: Step {

    // MARK: Constructors

    static let shared: (ConfigurationStep) -> PrivacyStep = { configurationStep in
        return PrivacyStep(configurationStep)
    }

    static let storageKeysByFeature: [String: Set<String>] = [
        PA.Privacy.Storage.VisitorId: Set(VisitorIdKeys.allCases.map { $0.rawValue }),
        PA.Privacy.Storage.Privacy: Set(PrivacyKeys.allCases.map { $0.rawValue }),
        PA.Privacy.Storage.Crash: Set(CrashKeys.allCases.map { $0.rawValue }),
        PA.Privacy.Storage.Lifecycle: Set(LifeCycleKeys.allCases.map { $0.rawValue }),
        PA.Privacy.Storage.User: Set(UserKeys.allCases.map { $0.rawValue })
    ]

    private final var modes: [String: PrivacyMode] = PA.Privacy.Modes
    private final var existingPrivacyModes: Set<String> = PA.Privacy.DefaultModes
    private final var inNoConsentMode: Bool = false
    private final var inNoStorageMode: Bool = false
    private final let configurationStep: ConfigurationStep

    init(_ cs: ConfigurationStep) {
        self.configurationStep = cs
    }

    // MARK: Constants

    private static let VisitorPrivacyConsentProperty = "visitor_privacy_consent"
    private static let VisitorPrivacyModeProperty = "visitor_privacy_mode"
    private static let PagePropertiesFormat = "page_%@"

    // MARK: Package methods

    final func storeData(_ storageKey: String, pairs: (String, Any?)...) {
        let visitorMode = getVisitorMode()
        if getVisitorModeAuthorizedStorageKey(visitorMode).contains(storageKey) {
            let userDefaults = UserDefaults.standard

            pairs.forEach { (p) in
                if let o = p.1 {
                    userDefaults.set(o, forKey: p.0)
                } else {
                    userDefaults.removeObject(forKey: p.0)
                }
            }
            userDefaults.synchronize()
        }
    }
    
    final func forcedStoreData(pairs: (String, Any?)...) {
        let userDefaults = UserDefaults.standard
        
        pairs.forEach { (p) in
            if let o = p.1 {
                userDefaults.set(o, forKey: p.0)
            } else {
                userDefaults.removeObject(forKey: p.0)
            }
        }
        userDefaults.synchronize()
    }

    final func canGetStoredData(_ storageKey: String) -> Bool {
        let visitorMode = getVisitorMode()
        return getVisitorModeAuthorizedStorageKey(visitorMode).contains(storageKey)
    }

    // MARK: Private methods

    private final func getVisitorModeAuthorizedStorageKey(_ visitorMode: String) -> Set<String> {
        if modes[visitorMode]?.storage.allowed == nil {
            let localVariable = modes
            modes[visitorMode]?.storage.allowed = localVariable[PA.Privacy.Mode.Exempt.Name]?.storage.allowed ?? Set<String>()
        }

        let authorizedStorageSpecificMode = modes[visitorMode]?.storage.allowed ?? []
        let authorizedStorageAllModes = modes[PA.Privacy.Mode.All.Name]?.storage.allowed ?? []

        return authorizedStorageSpecificMode.union(authorizedStorageAllModes)
    }

    private final func getVisitorModeAuthorizedEventNames(_ visitorMode: String) -> Set<String> {
        if modes[visitorMode]?.events.allowed == nil {
            modes[visitorMode]?.events.allowed = [PA.Privacy.Wildcard]
        }

        let authorizedEventsSpecificMode = modes[visitorMode]?.events.allowed ?? [PA.Privacy.Wildcard]
        let authorizedEventsAllModes = modes[PA.Privacy.Mode.All.Name]?.events.allowed ?? []

        return authorizedEventsSpecificMode.union(authorizedEventsAllModes)
    }

    private final func getVisitorModeForbiddenEventNames(_ visitorMode: String) -> Set<String> {
        if modes[visitorMode]?.events.forbidden == nil {
            modes[visitorMode]?.events.forbidden = []
        }

        let forbiddenEventsSpecificMode = modes[visitorMode]?.events.forbidden ?? [PA.Privacy.Wildcard]
        let forbiddenEventsAllModes = modes[PA.Privacy.Mode.All.Name]?.events.forbidden ?? []

        return forbiddenEventsSpecificMode.union(forbiddenEventsAllModes)
    }

    private final func getVisitorModeAuthorizedProperties(_ visitorMode: String) -> [String: Set<String>] {

        var authorizedPropertiesSpecificMode = modes[visitorMode]?.properties.allowed ?? [PA.Privacy.Wildcard: Set<String>()]
        let authorizedPropertiesAllModes = modes[PA.Privacy.Mode.All.Name]?.properties.allowed ?? [PA.Privacy.Wildcard: Set<String>()]
        authorizedPropertiesSpecificMode.merge(authorizedPropertiesAllModes, uniquingKeysWith: { current, new in
            current.union(new)
        })

        return authorizedPropertiesSpecificMode
    }

    private final func getVisitorModeForbiddenProperties(_ visitorMode: String) -> [String: Set<String>] {
        var forbiddenPropertiesSpecificMode = modes[visitorMode]?.properties.forbidden ?? [PA.Privacy.Wildcard: Set<String>()]
        let forbiddenPropertiesAllModes = modes[PA.Privacy.Mode.All.Name]?.properties.forbidden ?? [PA.Privacy.Wildcard: Set<String>()]
        forbiddenPropertiesSpecificMode.merge(forbiddenPropertiesAllModes, uniquingKeysWith: { current, new in
            current.union(new)
        })

        return forbiddenPropertiesSpecificMode
    }

    private final func getPrivacyVisitorConsent() -> Bool {
        return UserDefaults.standard.bool(forKey: PrivacyKeys.PrivacyVisitorConsent.rawValue)
    }

    private final func getPrivacyVisitorModeRemainingDuration() -> Int {
        let expiration = Int64(UserDefaults.standard.integer(forKey: PrivacyKeys.PrivacyModeExpirationTimestamp.rawValue))
        guard expiration > 0 else {
            return 0
        }
        let timeRemaining = expiration - Int64(Date().timeIntervalSince1970 * 1000)
        return Int(timeRemaining / Int64(PA.Time.DayInMs))
    }

    private final func getPrivacyVisitorId() -> String? {
        return UserDefaults.standard.string(forKey: PrivacyKeys.PrivacyVisitorId.rawValue)
    }

    private final func getVisitorMode() -> String {
        if inNoConsentMode {
            return PA.Privacy.Mode.NoConsent.Name
        }
        if inNoStorageMode {
            return PA.Privacy.Mode.NoStorage.Name
        }

        let userDefaults = UserDefaults.standard
        let storageLifetimePrivacy = configurationStep.getConfigurationValue(key: ConfigurationKey.StorageLifetimePrivacy).toInt()
        let defaultMode = configurationStep.getConfigurationValue(key: ConfigurationKey.PrivacyDefaultMode)

        if let privacyModeExpirationTs = userDefaults.object(forKey: PrivacyKeys.PrivacyModeExpirationTimestamp.rawValue) as? Int64 {
            if Int64(Date().timeIntervalSince1970 * 1000) >= privacyModeExpirationTs {
                userDefaults.set(PA.Privacy.Mode.OptIn.Name, forKey: PrivacyKeys.PrivacyMode.rawValue)
                userDefaults.set(Int64(Date().timeIntervalSince1970 * 1000) + (Int64(storageLifetimePrivacy) * Int64(PA.Time.DayInMs)), forKey: PrivacyKeys.PrivacyModeExpirationTimestamp.rawValue)
                userDefaults.set(true, forKey: PrivacyKeys.PrivacyVisitorConsent.rawValue)
                userDefaults.removeObject(forKey: PrivacyKeys.PrivacyVisitorId.rawValue)
                userDefaults.synchronize()
            }
        }
        return userDefaults.string(forKey: PrivacyKeys.PrivacyMode.rawValue) ?? defaultMode
    }

    final func isAuthorizedEventName(_ eventName: String, authorizedEventNames: Set<String>, forbiddenEventNames: Set<String>) -> Bool {
        guard !authorizedEventNames.isEmpty else {
            return false
        }

        var isAuthorized = false
        for name in authorizedEventNames {
            if let wildcardIndex = name.firstIndex(of: Character(PA.Privacy.Wildcard)) {
                let d = name.distance(from: name.startIndex, to: wildcardIndex)
                if d == 0 ||
                    (d != -1 && eventName.hasPrefix(name[..<wildcardIndex])) {
                    isAuthorized = true
                    break
                }
            } else if eventName == name {
                isAuthorized = true
                break
            }
        }

        guard isAuthorized else {
            return false
        }

        for name in forbiddenEventNames {
            if let wildcardIndex = name.firstIndex(of: Character(PA.Privacy.Wildcard)) {
                let d = name.distance(from: name.startIndex, to: wildcardIndex)
                if d == 0 ||
                    (d != -1 && eventName.hasPrefix(name[..<wildcardIndex])) {
                    return false
                }
            } else if eventName == name {
                return false
            }
        }

        return true
    }

    private final func getPropertiesByEvent(eventName: String, propertiesKeysByEvent: [String: Set<String>]) -> Set<String> {
        var propertiesForEvent: Set<String> = []

        for (eventKey, properties) in propertiesKeysByEvent {
            if eventKey == eventName || eventKey == PA.Privacy.Wildcard {
                propertiesForEvent.formUnion(properties)
            } else if let wildcardIndex = eventKey.firstIndex(of: Character(PA.Privacy.Wildcard)) {
                let prefix = eventKey[..<wildcardIndex]
                if eventName.hasPrefix(prefix) {
                    propertiesForEvent.formUnion(properties)
                }
            }
        }
        return propertiesForEvent
    }

    private final func applyAuthorizedPropertiesPrivacyRules(_ flattenData: [String: Any], authorizedPropertiesKeys: Set<String>) -> [String: Any] {
        var result = [String: Any]()

        for property in authorizedPropertiesKeys {
            if let wildcardIndex = property.firstIndex(of: Character(PA.Privacy.Wildcard)) {
                if property.distance(from: property.startIndex, to: wildcardIndex) == 0 {
                    /// WILDCARD ONLY
                    return flattenData
                } else {
                    let prefix = property[..<wildcardIndex]
                    flattenData.forEach { (k, v) in
                        guard k.hasPrefix(prefix) else {
                            return
                        }
                        result[k] = v
                    }
                }
            } else if let value = flattenData[property] {
                result[property] = value
            }
        }

        return result
    }

    private final func applyForbiddenPropertiesPrivacyRules(_ flattenData: [String: Any], forbiddenPropertiesKeys: Set<String>) -> [String: Any] {
        var result = flattenData

        for property in forbiddenPropertiesKeys {
            if let wildcardIndex = property.firstIndex(of: Character(PA.Privacy.Wildcard)) {
                if property.distance(from: property.startIndex, to: wildcardIndex) == 0 {
                    /// WILDCARD ONLY
                    return [String: Any]()
                } else {
                    let prefix = property[..<wildcardIndex]
                    result.keys.filter { $0.hasPrefix(prefix) }.forEach { result.removeValue(forKey: $0)}
                }
            } else {
                result.removeValue(forKey: property)
            }
        }

        return result
    }

    private final func clearStorageFromVisitorMode(_ visitorMode: String) {
        let userDefaults = UserDefaults.standard
        PrivacyStep.storageKeysByFeature.forEach { (entry) in
            let includeStorage = getVisitorModeAuthorizedStorageKey(visitorMode)
            if includeStorage.contains(entry.key) {
                return
            }
            entry.value.forEach { (key) in
                userDefaults.removeObject(forKey: key)
            }
        }
        userDefaults.synchronize()
    }

    private final func createCustomMode(_ customMode: String, visitorConsent: Bool) {
        if PA.Privacy.DefaultModes.contains(customMode) {
            return
        }

        modes[customMode] = PrivacyMode(
            name: customMode,
            properties: PrivacyModeProperties(
                allowed: PA.Privacy.Mode.Exempt.AllowedProperties,
                forbidden: PA.Privacy.Mode.Exempt.ForbiddenProperties
            ),
            events: PrivacyModeEvents(
                allowed: PA.Privacy.Mode.Exempt.AllowedEvents,
                forbidden: PA.Privacy.Mode.Exempt.ForbiddenEvents
            ),
            storage: PrivacyModeStorage(
                allowed: PA.Privacy.Mode.Exempt.AllowedStorage,
                forbidden: []
            ),
            visitorConsent: visitorConsent,
            customVisitorId: nil
        )
    }

    private final func privacyModeExists(_ visitorMode: String) -> Bool {
        return modes[visitorMode] != nil
    }

    // MARK: Step Implementation

    func processGetMode() -> String {
        return getVisitorMode()
    }

    func processUpdatePrivacyContext(m: inout Model) {
        guard let privacyModel = m.privacyModel else {
            return
        }

        let visitorMode = privacyModel.visitorMode
        guard privacyModeExists(visitorMode) else {
            if privacyModel.updateData == .CreateVisitorMode {
                createCustomMode(visitorMode, visitorConsent: privacyModel.visitorConsent ?? false)
            }
            return
        }
        let storageLifetimePrivacy = configurationStep.getConfigurationValue(key: ConfigurationKey.StorageLifetimePrivacy).toInt()

        switch privacyModel.updateData {
        case .VisitorMode:
            inNoConsentMode = visitorMode.lowercased() == PA.Privacy.Mode.NoConsent.Name
            inNoStorageMode = visitorMode.lowercased() == PA.Privacy.Mode.NoStorage.Name

            clearStorageFromVisitorMode(visitorMode)
            forcedStoreData(pairs:
                                (PrivacyKeys.PrivacyMode.rawValue, visitorMode),
                      (PrivacyKeys.PrivacyModeExpirationTimestamp.rawValue, Int64(Date().timeIntervalSince1970 * 1000) + Int64( storageLifetimePrivacy) * Int64(PA.Time.DayInMs)),
                      (PrivacyKeys.PrivacyVisitorConsent.rawValue, modes[visitorMode]?.visitorConsent ?? false),
                                (PrivacyKeys.PrivacyVisitorId.rawValue, privacyModel.customVisitorId))
        case .EventNames:
            if let authorizedEventNames = privacyModel.authorizedEventNames {
                if modes[visitorMode]?.events.allowed == nil {
                    modes[visitorMode]?.events.allowed = Set<String>()
                }
                authorizedEventNames.forEach { k in
                    modes[visitorMode]?.events.allowed.update(with: k)
                }
            }
            if let forbiddenEventNames = privacyModel.forbiddenEventNames {
                if modes[visitorMode]?.events.forbidden == nil {
                    modes[visitorMode]?.events.forbidden = Set<String>()
                }
                forbiddenEventNames.forEach { k in
                    modes[visitorMode]?.events.forbidden.update(with: k)
                }
            }
        case .Properties:
            if let authorizedPropertyKeys = privacyModel.authorizedPropertyKeys {
                for (eventName, properties) in authorizedPropertyKeys {
                    if modes[visitorMode]?.properties.allowed == nil {
                        modes[visitorMode]?.properties.allowed = [eventName: Set<String>()]
                    } else if modes[visitorMode]?.properties.allowed[eventName] == nil {
                        modes[visitorMode]?.properties.allowed[eventName] = Set<String>()
                    }
                    properties.forEach { property in
                        modes[visitorMode]?.properties.allowed[eventName]?.update(with: property)
                    }
                }
            }
            if let forbiddenPropertyKeys = privacyModel.forbiddenPropertyKeys {
                for (eventName, properties) in forbiddenPropertyKeys {
                    if modes[visitorMode]?.properties.forbidden == nil {
                        modes[visitorMode]?.properties.forbidden = [eventName: Set<String>()]
                    } else if modes[visitorMode]?.properties.forbidden[eventName] == nil {
                        modes[visitorMode]?.properties.forbidden[eventName] = Set<String>()
                    }
                    properties.forEach { property in
                        modes[visitorMode]?.properties.forbidden[eventName]?.update(with: property)
                    }
                }
            }
        case .Storage:
            if modes[visitorMode]?.storage.allowed == nil {
                let localVariable = modes
                modes[visitorMode]?.storage.allowed = localVariable[PA.Privacy.Mode.Exempt.Name]?.storage.allowed ?? Set<String>()
            }
            privacyModel.storageKeys?.forEach { authorizedStorageKey in
                modes[visitorMode]?.storage.allowed.insert(authorizedStorageKey)
            }
            privacyModel.forbiddenStorageKeys?.forEach { forbiddenStorageKey in
                modes[visitorMode]?.storage.allowed.remove(forbiddenStorageKey)
            }
        default:
            break
        }
    }

    func processGetModel(m: inout Model) {
        let vm = getVisitorMode()
        let pm = PrivacyModel(
            visitorMode: vm,
            authorizedPropertyKeys: getVisitorModeAuthorizedProperties(vm),
            forbiddenPropertyKeys: getVisitorModeForbiddenProperties(vm),
            authorizedEventNames: getVisitorModeAuthorizedEventNames(vm),
            forbiddenEventNames: getVisitorModeForbiddenEventNames(vm),
            storageKeys: getVisitorModeAuthorizedStorageKey(vm),
            duration: getPrivacyVisitorModeRemainingDuration(),
            visitorConsent: getPrivacyVisitorConsent(),
            customVisitorId: getPrivacyVisitorId()
        )

        m.privacyModel = pm
    }

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        /// REQUIREMENTS
        let conf = m.configuration
        var contextProperties = m.contextProperties
        let privacyVisitorMode = getVisitorMode()
        
        /// CONTEXT PROPERTIES
        contextProperties[PrivacyStep.VisitorPrivacyModeProperty] = ContextProperty(value: privacyVisitorMode)

        switch privacyVisitorMode {
        case PA.Privacy.Mode.OptIn.Name:
            contextProperties[PrivacyStep.VisitorPrivacyConsentProperty] = ContextProperty(value: true)
        case PA.Privacy.Mode.OptOut.Name:
            contextProperties[PrivacyStep.VisitorPrivacyConsentProperty] = ContextProperty(value: false)
            conf.set(ConfigurationKey.VisitorId, value: "opt-out")
        case PA.Privacy.Mode.NoConsent.Name:
            contextProperties[PrivacyStep.VisitorPrivacyConsentProperty] = ContextProperty(value: false)
            conf.set(ConfigurationKey.VisitorId, value: "Consent-NO")
        case PA.Privacy.Mode.NoStorage.Name:
            contextProperties[PrivacyStep.VisitorPrivacyConsentProperty] = ContextProperty(value: false)
            conf.set(ConfigurationKey.VisitorId, value: "no-storage")
        case PA.Privacy.Mode.Exempt.Name:
            contextProperties[PrivacyStep.VisitorPrivacyConsentProperty] = ContextProperty(value: false)
        default:
            /// CUSTOM
            contextProperties[PrivacyStep.VisitorPrivacyConsentProperty] = ContextProperty(value: getPrivacyVisitorConsent())
            if let optVisitorId = getPrivacyVisitorId(), optVisitorId.isEmpty {
                conf.set(ConfigurationKey.VisitorId, value: optVisitorId)
            }
        }
        
        let events = m.events.map {$0.toEventMap(context: contextProperties)}

        if privacyVisitorMode == PA.Privacy.Mode.OptOut.Name && !conf.get(ConfigurationKey.SendEventWhenOptout).toBool() {
            return false
        }

        let authorizedEventNames = getVisitorModeAuthorizedEventNames(privacyVisitorMode)
        let forbiddenEventNames = getVisitorModeForbiddenEventNames(privacyVisitorMode)

        let authorizedPropertiesKeys = getVisitorModeAuthorizedProperties(privacyVisitorMode)
        let forbiddenPropertiesKeys = getVisitorModeForbiddenProperties(privacyVisitorMode)

        /// EVENTS
        var resultEvents = [Event]()
        for event in events {
            if isAuthorizedEventName(event.name, authorizedEventNames: authorizedEventNames, forbiddenEventNames: forbiddenEventNames) {
                var data = event.data

                let authorizedPropertiesForEvent = getPropertiesByEvent(eventName: event.name, propertiesKeysByEvent: authorizedPropertiesKeys)
                let forbiddenPropertiesForEvent = getPropertiesByEvent(eventName: event.name, propertiesKeysByEvent: forbiddenPropertiesKeys)

                data = applyAuthorizedPropertiesPrivacyRules(data, authorizedPropertiesKeys: authorizedPropertiesForEvent)
                data = applyForbiddenPropertiesPrivacyRules(data, forbiddenPropertiesKeys: forbiddenPropertiesForEvent)

                resultEvents.append(Event(event.name, data: data))
            }
        }

        guard !resultEvents.isEmpty else {
            return false
        }


        m.contextProperties = contextProperties
        m.events = resultEvents
        return true
    }
}
