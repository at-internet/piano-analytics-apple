//
//  WorkingQueue.swift
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

enum ProcessingType {
    case SendEvents, SetConfig, UpdateContext, UpdatePrivacyContext, SendOfflineData, DeleteOfflineData
}

final class WorkingQueue {

    private final let operationQueue: OperationQueue = {
        let _queue = OperationQueue()
        _queue.name = "PianoAnalyticsQueue"
        _queue.maxConcurrentOperationCount = 1
        return _queue
    }()

    private final let steps: [Step]
    private final let processingMap: [ProcessingType: ([Step], inout Model, PianoAnalyticsWorkProtocol?) -> Void] = [
        ProcessingType.SetConfig: { (steps: [Step], m: inout Model, _: PianoAnalyticsWorkProtocol?) in
            for s in steps {
                s.processSetConfig(m: &m)
            }
        },
        ProcessingType.SendEvents: { (steps: [Step], m: inout Model, p: PianoAnalyticsWorkProtocol?) in
            for s in steps {
                guard s.processSendEvents(m: &m, p: p) else {
                    return
                }
            }
        },
        ProcessingType.UpdateContext: { (steps: [Step], m: inout Model, _: PianoAnalyticsWorkProtocol?) in
            for s in steps {
                s.processUpdateContext(m: &m)
            }
        },
        ProcessingType.UpdatePrivacyContext: { (steps: [Step], m: inout Model, _: PianoAnalyticsWorkProtocol?) in
            for s in steps {
                s.processUpdatePrivacyContext(m: &m)
            }
        },
        ProcessingType.SendOfflineData: { (steps: [Step], m: inout Model, p: PianoAnalyticsWorkProtocol?) in
            for s in steps {
                guard s.processSendOfflineData(m: &m, p: p) else {
                    return
                }
            }
        },
        ProcessingType.DeleteOfflineData: { (steps: [Step], m: inout Model, _: PianoAnalyticsWorkProtocol?) in
            for s in steps {
                s.processDeleteOfflineData(m: &m)
            }
        }
    ]

    init(_ configFileLocation: String) {
        let cs = ConfigurationStep.shared(configFileLocation)
        let ps = PrivacyStep(cs)
        self.steps = [
            cs,
            VisitorIDStep.shared(ps),
            CrashHandlingStep.shared(ps),
            CustomerContextPropertiesStep(),
            LifecycleStep.shared(ps),
            InternalContextPropertiesStep.shared,
            UsersStep(ps),
            OnBeforeBuildCallStep.shared,
            ps,
            BuildStep.shared,
            StorageStep.shared,
            OnBeforeSendCallStep.shared,
            SendStep.shared
        ]
    }

    final func getModelAsync(_ completionHandler: ((_ m: Model) -> Void)?) {
        operationQueue.addOperation {
            var m = Model()
            self.steps.forEach { s in
                s.processGetModel(m: &m)
            }
            completionHandler?(m)
        }
    }

    final func push(_ pt: ProcessingType, m: Model, p: PianoAnalyticsWorkProtocol?) {
        operationQueue.addOperation {
            if let processing = self.processingMap[pt] {
                var model = m
                processing(self.steps, &model, p)
            }
        }
    }
}
