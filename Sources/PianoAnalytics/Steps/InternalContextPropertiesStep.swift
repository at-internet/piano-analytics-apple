//
//  InternalContextPropertiesStep.swift
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
#if canImport(UIKit)
import UIKit
#elseif canImport(WatchKit)
import WatchKit
#endif

final class InternalContextPropertiesStep: Step {

    // MARK: Constructors

    static let shared: InternalContextPropertiesStep = InternalContextPropertiesStep()

    private final let displayingProperties : () -> [String: Any] = {
        #if !os(watchOS) && canImport(UIKit)
        let screenBounds = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        #else
        let screenBounds = CGRect()
        let screenScale = CGFloat()
        #endif

        return [
            String(format: DeviceScreenPropertiesFormat, "_width"): Int(screenBounds.size.width * screenScale),
            String(format: DeviceScreenPropertiesFormat, "_height"): Int(screenBounds.size.height * screenScale)
        ]
    }

    private final let applicationProperties : () -> [String: Any] = {
        var m = [String: Any]()
        if let appInfo = PianoAnalyticsUtils.applicationInfo {
            m["app_id"] = appInfo.0
            m[AppVersionProperty] = appInfo.1
        }
        return m
    }

    private final let hardwareProperties : () -> [String: Any] = {
        #if !os(watchOS) && canImport(UIKit)
        let osName = UIDevice.current.systemName.removeSpaces().lowercased()
        let osVersion = UIDevice.current.systemVersion
        #else
        let osName = ""
        let osVersion = ""
        #endif

        return [
            ModelProperty: InternalContextPropertiesStep.getModel(),
            ManufacturerProperty: Manufacturer,
            String(format: OsPropertiesFormat, "group"): osName,
            String(format: OsPropertiesFormat, "version"): osVersion,
            String(format: OsPropertiesFormat, "name"): String(format: "%@ %@", osName, osVersion)
        ]
    }

    private final let localeProperties : () -> [String: Any] = {
        let locale = Locale.autoupdatingCurrent.identifier
        let localeArray = InternalContextPropertiesStep.splitLocaleProperties(locale)

        return [
            DeviceTimestampUtcProperty: Date().timeIntervalSince1970,
            String(format: BrowserLanguagePropertiesFormat, ""): String(localeArray[0]),
            String(format: BrowserLanguagePropertiesFormat, "_local"): String(localeArray[1]),
            ConnectionTypeProperty: PianoAnalyticsUtils.connectionType.rawValue
        ]
    }

    private final let tagProperties : () -> [String: Any] = {
        return [
            String(format: EventCollectionPropertiesFormat, "platform"): Platform,
            String(format: EventCollectionPropertiesFormat, "version"): EventCollectionVersion
        ]
    }

    private final let propertiesFunctions : [() -> [String: Any]]

    private init() {
        self.propertiesFunctions = [
            displayingProperties,
            applicationProperties,
            hardwareProperties,
            localeProperties,
            tagProperties
        ]
    }

    // MARK: Constants

    static let DeviceTimestampUtcProperty = "device_timestamp_utc"
    static let ConnectionTypeProperty = "connection_type"
    static let DeviceScreenPropertiesFormat = "device_screen%@"
    static let DeviceScreenDiagonalProperty = String(format: DeviceScreenPropertiesFormat, "_diagonal")
    static let AppVersionProperty = "app_version"
    static let ManufacturerProperty = "manufacturer"
    static let ModelProperty = "model"
    static let OsPropertiesFormat = "os_%@"
    static let EventCollectionPropertiesFormat = "event_collection_%@"
    static let BrowserLanguagePropertiesFormat = "browser_language%@"

    private static let Manufacturer = "Apple"
    private static let EventCollectionVersion = "3.0.2"

    #if os(tvOS)
    private static let Platform = "tvOS"
    #elseif os(watchOS)
    private static let Platform = "watchOS"
    #else
    private static let Platform = "iOS"
    #endif

    // MARK: Private methods

    private static func getModel() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }
        #if os(tvOS)
        if #available(tvOS 14.0, *), ProcessInfo().isiOSAppOnMac {
            return "tvOSAppOnMac"
        }
        #elseif os(watchOS)
        if #available(watchOS 7.0, *), ProcessInfo().isiOSAppOnMac {
            return "watchOSAppOnMac"
        }
        #elseif os(macOS)
        if #available(macOS 11.0, *), ProcessInfo().isiOSAppOnMac {
            return "iOSAppOnMac"
        }
        #else
        if #available(iOS 14.0, *), ProcessInfo().isiOSAppOnMac {
            return "iOSAppOnMac"
        }
        #endif
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?.trimmingCharacters(in: .controlCharacters) ?? ""
    }

    private static func splitLocaleProperties(_ locale: String) -> [Substring] {
        let characterToSplitOn: Character = locale.contains("-") ? "-" : "_"
        let localeArray = locale.split(separator: characterToSplitOn, maxSplits: 1)

        if localeArray.count < 1 {
            return ["", ""]
        }
        return localeArray.count < 2 ? [localeArray[0], localeArray[0]] : localeArray
    }

    private final func getProperties() -> [String: ContextProperty] {
        var properties: [String: ContextProperty] = [:]
        self.propertiesFunctions.forEach { f in
            let dictionary = f()
            for (key, value) in dictionary {
                properties[key] = ContextProperty(value: value)
            }
        }
        return properties
    }

    // MARK: Step Implementation

    func processGetModel(m: inout Model) {
        m.addContextProperties(getProperties())
    }

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        m.addContextProperties(getProperties())
        return true
    }
}
