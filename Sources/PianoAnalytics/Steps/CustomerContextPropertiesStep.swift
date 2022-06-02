//
//  CustomerContextPropertiesStep.swift
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

public struct ContextPropertyOptions {
    var persistent: Bool = false
    var events: [String]?
}

public struct ContextProperty {
    let value: Any
    var options: ContextPropertyOptions?
}

final class CustomerContextPropertiesStep: Step {

    // MARK: Constructors

    private var properties: [String: ContextProperty] = [:]

    internal init() {
    }
    
    // MARK: Step Implementation

    func processGetModel(m: inout Model) {
        m.addContextProperties(self.properties)
    }

    func processUpdateContext(m: inout Model) {
        guard let customerContextModel = m.customerContextModel else {
            return
        }

        switch customerContextModel.updateType {
        case .Add:
            for (key, value) in customerContextModel.properties ?? [:] {
                properties[key] = ContextProperty(value: value, options: customerContextModel.options)
            }
        case .Delete:
            if let propertiesToDelete = customerContextModel.properties {
                propertiesToDelete.keys.forEach { key in
                    properties.removeValue(forKey: key)
                }
            } else {
                properties.removeAll()
            }
        default:
            break
        }
    }

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {

        m.addContextProperties(self.properties)
        // clean context properties
        for (key, value) in self.properties {

            // if persistent we keep the property
            if value.options?.persistent == true {
                continue
            }

            var hasAuthorizedEvent: Bool?
            if value.options?.events?.count ?? 0 > 0 {
                hasAuthorizedEvent = false
                for event in m.events {
                    hasAuthorizedEvent = PianoAnalyticsUtils.isEventAuthorized(eventName: event.name, authorizedEvents: value.options?.events ?? [])
                    if hasAuthorizedEvent == true {
                        break
                    }
                }
            }
            // if an array of authorized events is given and the property is not used we keep it
            if hasAuthorizedEvent == false {
                continue
            }

            self.properties.removeValue(forKey: key)
        }
        return true
    }
}
