//
//  Utils.swift
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
#if os(iOS) && canImport(CoreTelephony)
import CoreTelephony
#endif

enum ConnectionType: String {
    case Offline = "OFFLINE"
    case GPRS = "GPRS"
    case EDGE = "EDGE"
    case TwoG = "2G"
    case ThreeG = "3G"
    case ThreeGPlus = "3G+"
    case FourG = "4G"
    case FiveG = "5G"
    case Wifi = "WIFI"
    case Unknown = "UNKNOWN"
}

final class PianoAnalyticsUtils {

    // MARK: Constructors

    private init() {

    }

    // MARK: Constants

    private static let FlatSeparator = "_"

    // MARK: Hardware properties

    static var applicationName: String? {
        let info = Bundle.main.infoDictionary ?? Bundle.main.localizedInfoDictionary ?? [String: Any]()

        if let name = info[String(kCFBundleNameKey)] as? String {
            if !name.isEmpty {
                return name
            }
        }

        return PianoAnalyticsUtils.applicationInfo?.0
    }

    static var applicationInfo: (String, String)? {
        get {
            if let info = Bundle.main.infoDictionary,
               let identifier = info["CFBundleIdentifier"] as? String,
               let version = info["CFBundleShortVersionString"] as? String {

                return (identifier, version)
            }

            return nil
        }
    }

    #if os(iOS) && canImport(CoreTelephony)
    private static let telephonyNetworkInfoInfo = CTTelephonyNetworkInfo()
    #endif

    #if os(watchOS)
    static var connectionType: ConnectionType = ConnectionType.Unknown
    #else
    static var connectionType: ConnectionType {
        get {
            let reachability = PianoAnalytics.Reachability.reachabilityForInternetConnection()

            if let optReachability = reachability {
                if optReachability.currentReachabilityStatus == PianoAnalytics.Reachability.NetworkStatus.reachableViaWiFi {
                    return ConnectionType.Wifi
                } else if optReachability.currentReachabilityStatus == PianoAnalytics.Reachability.NetworkStatus.notReachable {
                    return ConnectionType.Offline
                } else {
                    #if os(iOS) && canImport(CoreTelephony)
                    var radioType : String? = nil
                    if #available(iOS 12, *) {
                        radioType = telephonyNetworkInfoInfo.serviceCurrentRadioAccessTechnology?.values.first
                    } else {
                        radioType = telephonyNetworkInfoInfo.currentRadioAccessTechnology
                    }

                    if let rt = radioType {
                        if #available(iOS 14.1, *) {
                            // These radio types are not available in iOS 14.0 and 14.0.1 (causes crashes) although it seems like they are
                            #if swift(>=5.3)
                            if rt == CTRadioAccessTechnologyNRNSA || rt == CTRadioAccessTechnologyNR {
                                return ConnectionType.FiveG
                            }
                            #endif
                        }
                        switch rt {
                        case CTRadioAccessTechnologyGPRS:
                            return ConnectionType.GPRS
                        case CTRadioAccessTechnologyEdge:
                            return ConnectionType.EDGE
                        case CTRadioAccessTechnologyCDMA1x:
                            return ConnectionType.TwoG
                        case CTRadioAccessTechnologyWCDMA,
                             CTRadioAccessTechnologyCDMAEVDORev0,
                             CTRadioAccessTechnologyCDMAEVDORevA,
                             CTRadioAccessTechnologyCDMAEVDORevB:
                            return ConnectionType.ThreeG
                        case CTRadioAccessTechnologyeHRPD,
                             CTRadioAccessTechnologyHSDPA,
                             CTRadioAccessTechnologyHSUPA:
                            return ConnectionType.ThreeGPlus
                        case CTRadioAccessTechnologyLTE:
                            return ConnectionType.FourG
                        case "CTRadioAccessTechnologyNRNSA",
                             "CTRadioAccessTechnologyNR":
                            return ConnectionType.FiveG
                        default:
                            return ConnectionType.Unknown
                        }
                    } else {
                        return ConnectionType.Unknown
                    }
                    #else
                        return ConnectionType.Unknown
                    #endif
                }
            } else {
                return ConnectionType.Unknown
            }
        }
    }
    #endif

    // MARK: Time methods

    static func secondsBetweenDates(_ fromDate: Date, toDate: Date) -> Int {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return calendar.dateComponents([.second], from: fromDate, to: toDate).second ?? 0
    }

    static func daysBetweenDates(_ fromDate: Date, toDate: Date) -> Int {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        return calendar.dateComponents([.day], from: fromDate, to: toDate).day ?? 0
    }

    // MARK: Data formatting methods

    static func JSONFileToMap(path: String) -> [String: String]? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            return jsonResult as? [String: String]
        } catch {
            return nil
        }
    }

    // MARK: Parsing methods

    static func toJSONData(_ o: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: o, options: [])
        } catch {
           return nil
        }
    }

    static func fromJSONData(_ d: Data) -> [String: String]? {
        do {
            return try JSONSerialization.jsonObject(with: d, options: []) as? [String: String]
        } catch {
           return nil
        }
    }

    static func toFlatten(src: [String: Any]) -> [String: Any] {
        var dst = [String: Any]()
        doFlatten(src: src, prefix: "", dst: &dst)
        return dst
    }

    private static func doFlatten(src: [String: Any], prefix: String, dst: inout [String: Any]) {
        for (k, v) in src {
            let key = prefix == "" ? k : prefix + FlatSeparator + k
            if v is [String: Any] {
                doFlatten(src: v as! [String: Any], prefix: key, dst: &dst)
            } else {
                let parts = key.components(separatedBy: FlatSeparator)
                var s = ""

                for (i, part) in parts.enumerated() {
                    if i > 0 {
                        s.append(FlatSeparator)
                    }
                    s.append(part.lowercased())
                }

                dst[s] = v
            }
        }
    }

    private static func containsKeyPrefix(keys: Dictionary<String, Any>.Keys, prefix: String) -> Bool {
        for (_, key) in keys.enumerated() {
            if key.hasPrefix(prefix) {
                return true
            }
        }
        return false
    }
    
    internal static func isEventAuthorized(eventName: String, authorizedEvents: [String]) -> Bool {
        for authorizedEvent in authorizedEvents {
            if let wildcardIndex = authorizedEvent.firstIndex(of: Character(PA.Privacy.Wildcard)) {
                if eventName.hasPrefix(authorizedEvent[..<wildcardIndex]) {
                    return true
                }
            } else if authorizedEvent == eventName {
                return true
            }
        }
        return false
    }
}
