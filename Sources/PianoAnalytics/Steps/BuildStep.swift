//
//  BuildStep.swift
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

final class BuildStep: Step {

    // MARK: Constructors

    static let shared: BuildStep = BuildStep()

    private init() {
    }

    // MARK: Constants

    private static let RequestUriFormat = "https://%@%@?s=%@&idclient=%@"
    private static let EventsField = "events"

    // MARK: Step Implementation

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        /// REQUIREMENTS
        let conf = m.configuration
        var contextProperties = m.contextProperties
        let events = m.events

        let offlineStorageMode = OfflineStorageMode.init(rawValue: conf.get(ConfigurationKey.OfflineStorageMode)) ?? OfflineStorageMode.Never
        var mustBeSaved = false
        if offlineStorageMode == OfflineStorageMode.Always ||
            (offlineStorageMode == OfflineStorageMode.Required && PianoAnalyticsUtils.connectionType == ConnectionType.Offline) {

            contextProperties[InternalContextPropertiesStep.ConnectionTypeProperty] = ContextProperty(value: ConnectionType.Offline.rawValue)
            mustBeSaved = true
        }

        /// BODY
        let body = PianoAnalyticsUtils.toJSONData([
            // TODO
            BuildStep.EventsField: events.map {$0.toMap(context: [:])}
        ]) ?? Data()

        /// URI
        let visitorId = conf.get(ConfigurationKey.VisitorId)
        let uri = String(format: BuildStep.RequestUriFormat,
                         conf.get(ConfigurationKey.CollectDomain) + "/",
                         conf.get(ConfigurationKey.Path),
                         conf.get(ConfigurationKey.Site),
                         visitorId)

        m.builtModel = BuiltModel(uri: uri, body: String(decoding: body, as: UTF8.self), mustBeSaved: mustBeSaved)
        return true

    }
}
