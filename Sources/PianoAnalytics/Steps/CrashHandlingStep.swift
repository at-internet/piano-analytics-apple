//
//  CrashHandlingStep.swift
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

final class CrashHandlingStep: Step {

    // MARK: Constructors

    private static var _instance: CrashHandlingStep?
    static let shared: (PrivacyStep) -> CrashHandlingStep = { ps in
        if _instance == nil {
            _instance = CrashHandlingStep(ps: ps)
        }
        return _instance ?? CrashHandlingStep(ps: ps)
    }

    private static let defaultHandler : (@convention(c) (NSException) -> Swift.Void)? = NSGetUncaughtExceptionHandler()
    private final let exceptionHandler : (@convention(c) (NSException) -> Swift.Void)?
    private final let signalHandler : (@convention(c) (Int32) -> Swift.Void)
    private final let privacyStep: PrivacyStep

    private final let signals: [Int32] = [SIGABRT, SIGILL, SIGSEGV, SIGFPE, SIGBUS, SIGPIPE]

    private final var isCrashHandlingRegistered: Bool = false

    private init(ps: PrivacyStep) {
        let oldStorageKeyWithNew: [ATCrashKeys: CrashKeys] = [
            ATCrashKeys.Crashed: CrashKeys.Crashed,
            ATCrashKeys.CrashInfo: CrashKeys.CrashInfo
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
        self.exceptionHandler = { exception in
            let userDefaults = UserDefaults.standard
            userDefaults.setValue([
                String(format: CrashHandlingStep.AppCrashPropertiesFormat, ""): exception.name.rawValue
            ], forKey: CrashKeys.CrashInfo.rawValue)
            userDefaults.set(true, forKey: CrashKeys.Crashed.rawValue)
            userDefaults.synchronize()
            if let h = CrashHandlingStep.defaultHandler {
                h(exception)
            }
        }
        self.signalHandler = { sig in
            let userDefaults = UserDefaults.standard
            userDefaults.setValue([
                String(format: CrashHandlingStep.AppCrashPropertiesFormat, ""): CrashHandlingStep.nameOf(sig)
            ], forKey: CrashKeys.CrashInfo.rawValue)
            userDefaults.set(true, forKey: CrashKeys.Crashed.rawValue)
            userDefaults.synchronize()
            exit(sig)
        }
    }

    // MARK: Constants

    private static let AppCrashPropertiesFormat = "app_crash%@"

    // MARK: Private methods

    private final func setupHandling(custom: Bool) {
        NSSetUncaughtExceptionHandler(custom ? self.exceptionHandler : CrashHandlingStep.defaultHandler)
        let sigHandler = custom ? self.signalHandler : SIG_DFL
        for s in self.signals {
            signal(s, sigHandler)
        }
    }

    private final func getProperties() -> [String: ContextProperty] {

        guard self.privacyStep.canGetStoredData(PA.Privacy.Storage.Crash) else {
            return [String: ContextProperty]()
        }

        let userDefaults = UserDefaults.standard
        let crashed = userDefaults.bool(forKey: CrashKeys.Crashed.rawValue)
        userDefaults.removeObject(forKey: CrashKeys.Crashed.rawValue)

        guard crashed else {
            return [String: ContextProperty]()
        }

        var properties: [String: ContextProperty] = [:]
        for (key, value) in userDefaults.dictionary(forKey: CrashKeys.CrashInfo.rawValue) ?? [:] {
            properties[key] = ContextProperty(value: value)
        }
        return properties
    }

    private static func nameOf(_ signal: Int32) -> String {
        switch signal {
        case SIGABRT:
            return "SIGABRT"
        case SIGILL:
            return "SIGILL"
        case SIGSEGV:
            return "SIGSEGV"
        case SIGFPE:
            return "SIGFPE"
        case SIGBUS:
            return "SIGBUS"
        case SIGPIPE:
            return "SIGPIPE"
        default:
            return "OTHER"
        }
    }

    // MARK: Step Implementation

    func processSetConfig(m: inout Model) {
        /// REQUIREMENTS
        let conf = m.configuration

        let crashDetectionEnabled = conf.get(ConfigurationKey.CrashDetection).toBool()
        let shouldBeRegistered = crashDetectionEnabled && !self.isCrashHandlingRegistered
        let shouldNotBeRegistered = !crashDetectionEnabled && self.isCrashHandlingRegistered

        if shouldBeRegistered {
            self.isCrashHandlingRegistered = true
            setupHandling(custom: true)
        } else if shouldNotBeRegistered {
            self.isCrashHandlingRegistered = false
            setupHandling(custom: false)
        }
    }

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        m.addContextProperties(getProperties())
        return true
    }
}
