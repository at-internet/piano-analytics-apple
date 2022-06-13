//
//  VisitorIDStep.swift
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

#if canImport(WatchKit)
import WatchKit
#elseif canImport(UIKit)
import UIKit
#endif

final class VisitorIDStep: Step {

    // MARK: Constructors

    private static var _instance: VisitorIDStep?
    static let shared: (PrivacyStep) -> VisitorIDStep = { ps in
        if _instance == nil {
            _instance = VisitorIDStep(ps: ps)
        }
        return _instance ?? VisitorIDStep(ps: ps)
    }

    private typealias visitorIDClosure = (Configuration, PrivacyStep) -> (Bool, String)
    private final let IDFA: visitorIDClosure = { (_: Configuration, _: PrivacyStep) -> (Bool, String) in
        let idfaInfo = getIDFA()
        var isAdTrackingAllowed: Bool

        #if os(tvOS)
        if #available(tvOS 14, *) {
            isAdTrackingAllowed = isTrackingAuthorizationStatusAuthorized()
        } else {
            isAdTrackingAllowed = idfaInfo.0
        }
        #else
        if #available(iOS 14, *) {
            isAdTrackingAllowed = isTrackingAuthorizationStatusAuthorized()
        } else {
            isAdTrackingAllowed = idfaInfo.0
        }
        #endif

        return (isAdTrackingAllowed, idfaInfo.1)
    }
    private final let IDFV: visitorIDClosure = { (_: Configuration, _: PrivacyStep) -> (Bool, String) in
        #if !os(watchOS) && canImport(UIKit)
        return (true, UIDevice.current.identifierForVendor?.uuidString ?? "")
        #else
        return (true, "")
        #endif

    }
    private final let UUID: visitorIDClosure = { (c: Configuration, ps: PrivacyStep) -> (Bool, String) in
        let userDefaults = UserDefaults.standard
        let now = Int64(Date().timeIntervalSince1970) * 1000
        let uuidDuration = c.get(ConfigurationKey.StorageLifetimeVisitor).toInt()
        let uuidExpirationMode = VisitorStorageMode.init(rawValue: c.get(ConfigurationKey.VisitorStorageMode)) ?? VisitorStorageMode.Fixed

        /// get uuid generation timestamp
        var uuidGenerationTimestamp: Int64
        if let optUUIDGenerationTimestamp = userDefaults.object(forKey: VisitorIdKeys.VisitorUUIDGenerationTimestamp.rawValue) as? Int64 {
            uuidGenerationTimestamp = optUUIDGenerationTimestamp
        } else {
            ps.storeData(PA.Privacy.Storage.VisitorId, pairs: (VisitorIdKeys.VisitorUUIDGenerationTimestamp.rawValue, now))
            uuidGenerationTimestamp = now
        }

        /// uuid expired ?
        let daysSinceGeneration = (now - uuidGenerationTimestamp) / Int64(PA.Time.DayInMs)
        if daysSinceGeneration >= uuidDuration {
            userDefaults.removeObject(forKey: VisitorIdKeys.VisitorUUID.rawValue)
            userDefaults.synchronize()
        }

        /// No or expired id
        if userDefaults.object(forKey: VisitorIdKeys.VisitorUUID.rawValue) == nil {
            let UUID = Foundation.UUID().uuidString
            ps.storeData(PA.Privacy.Storage.VisitorId, pairs: (VisitorIdKeys.VisitorUUID.rawValue, UUID), (VisitorIdKeys.VisitorUUIDGenerationTimestamp.rawValue, now))

            return (true, UUID)
        }

        /// expiration relative
        if uuidExpirationMode == VisitorStorageMode.Relative {
            ps.storeData(PA.Privacy.Storage.VisitorId, pairs: (VisitorIdKeys.VisitorUUIDGenerationTimestamp.rawValue, now))
        }

        guard let UUID = userDefaults.object(forKey: VisitorIdKeys.VisitorUUID.rawValue) as? String else {
            return (true, "")
        }

        return (true, UUID)
    }
    private final let Custom: visitorIDClosure = { (c: Configuration, _: PrivacyStep) -> (Bool, String) in
        return (true, c.get(ConfigurationKey.VisitorId))
    }

    private final let privacyStep: PrivacyStep

    private init(ps: PrivacyStep) {
        let oldStorageKeyWithNew: [ATVisitorIdKeys: VisitorIdKeys] = [
            ATVisitorIdKeys.VisitorUUID: VisitorIdKeys.VisitorUUID,
            ATVisitorIdKeys.VisitorUUIDGenerationTimestamp: VisitorIdKeys.VisitorUUIDGenerationTimestamp
        ]
        for (oldStorageKey, newStorageKey) in oldStorageKeyWithNew {
            if (UserDefaults.standard.value(forKey: newStorageKey.rawValue) == nil) {
                if let oldValue = UserDefaults.standard.value(forKey: oldStorageKey.rawValue) {
                    UserDefaults.standard.set(oldValue, forKey: newStorageKey.rawValue)
                    UserDefaults.standard.removeObject(forKey: oldStorageKey.rawValue)
                }
            }
        }

        
        self.privacyStep = ps
    }

    // MARK: Constants

    private static let OptOut: String = "opt-out"
    private static let VisitorIdTypeProperty: String = "visitor_id_type"

    // MARK: Private methods

    private static func getIDFA() -> (Bool, String) {
        guard let ASIdentifierManagerClass = NSClassFromString("ASIdentifierManager") else {
            return (false, "")
        }

        let sharedManagerSelector = NSSelectorFromString("sharedManager")

        guard let sharedManagerIMP = ASIdentifierManagerClass.method(for: sharedManagerSelector) else {
            return (false, "")
        }

        typealias sharedManagerCType = @convention(c) (AnyObject, Selector) -> AnyObject?
        let getSharedManager = unsafeBitCast(sharedManagerIMP, to: sharedManagerCType.self)

        guard let sharedManager = getSharedManager(ASIdentifierManagerClass.self, sharedManagerSelector) else {
            return (false, "")
        }

        let advertisingTrackingEnabledSelector = NSSelectorFromString("isAdvertisingTrackingEnabled")
        guard let isTrackingEnabledIMP = sharedManager.method(for: advertisingTrackingEnabledSelector) else {
            return (false, "")
        }

        typealias isTrackingEnabledCType = @convention(c) (AnyObject, Selector) -> Bool
        let getIsTrackingEnabled = unsafeBitCast(isTrackingEnabledIMP, to: isTrackingEnabledCType.self)
        let isTrackingEnabled = getIsTrackingEnabled(self, advertisingTrackingEnabledSelector)

        guard isTrackingEnabled else {
            return (false, "")
        }

        let advertisingIdentifierSelector = NSSelectorFromString("advertisingIdentifier")

        guard let advertisingIdentifierIMP = sharedManager.method(for: advertisingIdentifierSelector) else {
            return (false, "")
        }

        typealias adIdentifierCType = @convention(c) (AnyObject, Selector) -> NSUUID
        let getIdfa = unsafeBitCast(advertisingIdentifierIMP, to: adIdentifierCType.self)
        return (true, getIdfa(self, advertisingIdentifierSelector).uuidString)
    }

    private static func isTrackingAuthorizationStatusAuthorized() -> Bool {
        guard let ATTrackingManagerClass = NSClassFromString("ATTrackingManager") else {
            return false
        }

        let trackingAuthorizationStatusSelector = NSSelectorFromString("trackingAuthorizationStatus")
        guard let trackingAuthorizationStatusSelectorIMP = ATTrackingManagerClass.method(for: trackingAuthorizationStatusSelector) else {
            return false
        }

        typealias trackingAuthorizationStatusCType = @convention(c) (AnyObject, Selector) -> UInt
        let getTrackingAuthorizationStatus = unsafeBitCast(trackingAuthorizationStatusSelectorIMP, to: trackingAuthorizationStatusCType.self)
        let trackingAuthorizationStatus = getTrackingAuthorizationStatus(ATTrackingManagerClass.self, trackingAuthorizationStatusSelector)

        return trackingAuthorizationStatus == 3 /// authorized
    }

    private final func getVisitorID(c: Configuration, visitorIdType: VisitorIdType) -> String {
        var cl: visitorIDClosure

        switch visitorIdType {
        case .IDFA:
            cl = self.IDFA
        case .IDFV:
            cl = self.IDFV
        case .Custom:
            cl = self.Custom
        default:
            cl = self.UUID
        }

        let ignoreLimitedAdvertisingTracking = c.get(ConfigurationKey.IgnoreLimitedAdTracking).toBool()

        let result = cl(c, self.privacyStep)
        let trackingEnabledByUser = result.0
        if !trackingEnabledByUser {
            if ignoreLimitedAdvertisingTracking {
                return self.UUID(c, self.privacyStep).1
            }
            return VisitorIDStep.OptOut
        }
        return result.1
    }

    // MARK: Step Implementation

    func processGetModel(m: inout Model) {
        /// REQUIREMENTS
        let conf = m.configuration

        let visitorIdType = VisitorIdType.init(rawValue: conf.get(ConfigurationKey.VisitorIdType)) ?? VisitorIdType.UUID
        conf.set(ConfigurationKey.VisitorId, value: getVisitorID(c: conf, visitorIdType: visitorIdType))
    }

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        /// REQUIREMENTS
        let conf = m.configuration

        let visitorIdType = VisitorIdType.init(rawValue: conf.get(ConfigurationKey.VisitorIdType)) ?? VisitorIdType.UUID
        conf.set(ConfigurationKey.VisitorId, value: getVisitorID(c: conf, visitorIdType: visitorIdType))

        m.contextProperties[VisitorIDStep.VisitorIdTypeProperty] = ContextProperty(value: visitorIdType.rawValue)
        return true
    }
}
