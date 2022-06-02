//
//  WorkListenerCallSteps.swift
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

final class OnBeforeBuildCallStep: Step {

    // MARK: Constructors

    static let shared: OnBeforeBuildCallStep = OnBeforeBuildCallStep()

    private init() {
    }

    // MARK: Constants

    private static let CallbackUsedProperty = "_callback_used"

    // MARK: Step Implementation

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        guard let workProtocol = p else {
            return true
        }

        /// REQUIREMENTS
        let conf = Configuration(c: m.configuration)
        m.configuration.parameters.removeAll()

        if workProtocol.onBeforeBuild(model: &m) {
            m.configuration = conf
            m.contextProperties[OnBeforeBuildCallStep.CallbackUsedProperty] = ContextProperty(value: true)
            return true
        }
        return false
    }
}

final class OnBeforeSendCallStep: Step {

    // MARK: Constructors

    static let shared: OnBeforeSendCallStep = OnBeforeSendCallStep()

    private init() {
    }

    // MARK: Step Implementation

    func processSendOfflineData(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        guard let workProtocol = p else {
            return true
        }

        return workProtocol.onBeforeSend(built: nil, stored: m.storage)
    }

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        guard let workProtocol = p else {
            return true
        }

        return workProtocol.onBeforeSend(built: m.builtModel, stored: m.storage)
    }
}
