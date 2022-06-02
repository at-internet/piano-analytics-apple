//
//  ConfigurationStep.swift
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
#if canImport(WebKit)
import WebKit
#endif

final class ConfigurationStep: Step {

    // MARK: Constants

    private static let UserAgentWebViewProperty = "userAgent"
    private static let UserAgentFormat = "%@ %@/%@"

    // MARK: Constructors

    private static var _instance: ConfigurationStep?
    static let shared: (String?) -> ConfigurationStep = { configFileLocation in
        if _instance == nil {
            _instance = ConfigurationStep(configFileLocation: configFileLocation)
        }
        return _instance ?? ConfigurationStep(configFileLocation: configFileLocation)
    }

    private final let configuration: Configuration

    private init(configFileLocation: String?) {
        self.configuration = Configuration(file: configFileLocation)
    }

    // MARK: Private methods

    private static func getDefaultUserAgent() -> String {
        #if canImport(WebKit)
        if let userAgentProperty = WKWebView().value(forKey: ConfigurationStep.UserAgentWebViewProperty) as? String,
           let appName = PianoAnalyticsUtils.applicationName,
           let appInfo = PianoAnalyticsUtils.applicationInfo {

            return String(format: ConfigurationStep.UserAgentFormat, userAgentProperty, appName, appInfo.1)
        }
        #endif
        return ""
    }

    // MARK: Package methods

    func getConfigurationValue(key: ConfigurationKey) -> String {
        return self.configuration.get(key)
    }

    // MARK: Step Implementation

    func processGetModel(m: inout Model) {
        m.configuration = Configuration(c: self.configuration)
    }

    func processUpdateContext(m: inout Model) {
        m.configuration = Configuration(c: self.configuration)
    }

    func processSetConfig(m: inout Model) {
        /// REQUIREMENTS
        let conf = m.configuration

        let newConfiguration = self.configuration.merge(c: conf)
        m.configuration = Configuration(c: newConfiguration)
    }

    func processSendOfflineData(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        /// REQUIREMENTS
        let customConf = m.configuration

        m.configuration = Configuration(c: self.configuration).merge(c: customConf)
        return true
    }

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        /// REQUIREMENTS
        let customConf = m.configuration

        m.configuration = Configuration(c: self.configuration).merge(c: customConf)
        return true
    }
}
