//
//  LifecycleStep.swift
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

final class LifecycleStep: Step {

    // MARK: Constructors

    private static var _instance: LifecycleStep?
    static let shared: (PrivacyStep) -> LifecycleStep = { ps in
        if _instance == nil {
            _instance = LifecycleStep(ps: ps)
        }
        return _instance ?? LifecycleStep(ps: ps)
    }

    private final let daysSinceFirstSession: (UserDefaults, PrivacyStep) -> Void = { (ud, ps) in
        guard let firstSessionDate = ud.object(forKey: LifeCycleKeys.FirstSessionDate.rawValue) as? Date else {
            return
        }
        ps.storeData(PA.Privacy.Storage.Lifecycle, pairs: (LifeCycleKeys.DaysSinceFirstSession.rawValue, PianoAnalyticsUtils.daysBetweenDates(firstSessionDate, toDate: Date())))
    }

    private final let daysSinceLastSession: (UserDefaults, PrivacyStep) -> Void = { (ud, ps) in
        guard let lastSessiondate = ud.object(forKey: LifeCycleKeys.LastSessionDate.rawValue) as? Date else {
            return
        }
        ps.storeData(PA.Privacy.Storage.Lifecycle, pairs: (LifeCycleKeys.DaysSinceLastSession.rawValue, PianoAnalyticsUtils.daysBetweenDates(lastSessiondate, toDate: Date())))
    }

    private final let daysSinceUpdate: (UserDefaults, PrivacyStep) -> Void = { (ud, ps) in
        guard let firstSessionDateAfterUpdate = ud.object(forKey: LifeCycleKeys.FirstSessionDateAfterUpdate.rawValue) as? Date else {
            return
        }
        ps.storeData(PA.Privacy.Storage.Lifecycle, pairs: (LifeCycleKeys.DaysSinceUpdate.rawValue, PianoAnalyticsUtils.daysBetweenDates(firstSessionDateAfterUpdate, toDate: Date())))
    }

    private final let computingMetrics: [(UserDefaults, PrivacyStep) -> Void]

    private final let lifecycleDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    private final let privacyStep: PrivacyStep

    private final var sessionId: String?
    private final var timeBackgroundStarted: Date?
    private final var sessionBackgroundDuration: Int?

    private init(ps: PrivacyStep) {
        let oldStorageKeyWithNew: [ATLifeCycleKeys: LifeCycleKeys] = [
            ATLifeCycleKeys.FirstInitLifecycleDone: LifeCycleKeys.FirstInitLifecycleDone,
            ATLifeCycleKeys.InitLifecycleDone: LifeCycleKeys.InitLifecycleDone,
            ATLifeCycleKeys.FirstSession: LifeCycleKeys.FirstSession,
            ATLifeCycleKeys.FirstSessionAfterUpdate: LifeCycleKeys.FirstSessionAfterUpdate,
            ATLifeCycleKeys.LastSessionDate: LifeCycleKeys.LastSessionDate,
            ATLifeCycleKeys.FirstSessionDate: LifeCycleKeys.FirstSessionDate,
            ATLifeCycleKeys.SessionCount: LifeCycleKeys.SessionCount,
            ATLifeCycleKeys.LastApplicationVersion: LifeCycleKeys.LastApplicationVersion,
            ATLifeCycleKeys.FirstSessionDateAfterUpdate: LifeCycleKeys.FirstSessionDateAfterUpdate,
            ATLifeCycleKeys.SessionCountSinceUpdate: LifeCycleKeys.SessionCountSinceUpdate,
            ATLifeCycleKeys.DaysSinceFirstSession: LifeCycleKeys.DaysSinceFirstSession,
            ATLifeCycleKeys.DaysSinceUpdate: LifeCycleKeys.DaysSinceUpdate,
            ATLifeCycleKeys.DaysSinceLastSession: LifeCycleKeys.DaysSinceLastSession
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
        self.computingMetrics = [daysSinceFirstSession, daysSinceLastSession, daysSinceUpdate]
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.applicationDidEnterBackground), name: NSNotification.Name(rawValue: "UIApplicationDidEnterBackgroundNotification"), object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.applicationActive), name: NSNotification.Name(rawValue: "UIApplicationDidBecomeActiveNotification"), object: nil)

        let ud = UserDefaults.standard
        ud.removeObject(forKey: LifeCycleKeys.InitLifecycleDone.rawValue)
        ud.synchronize()

    }

    // MARK: Constants

    // MARK: Private methods

    private final func `init`() {
        let ud = UserDefaults.standard
        if !ud.bool(forKey: LifeCycleKeys.FirstSession.rawValue) && ud.bool(forKey: LifeCycleKeys.FirstInitLifecycleDone.rawValue) {
            self.newSessionInit()
        } else {
            self.firstSessionInit()
            self.privacyStep.storeData(PA.Privacy.Storage.Lifecycle, pairs: (LifeCycleKeys.FirstInitLifecycleDone.rawValue, true))
        }
        self.privacyStep.storeData(PA.Privacy.Storage.Lifecycle, pairs: (LifeCycleKeys.InitLifecycleDone.rawValue, true))
    }

    private final func firstSessionInit() {
        let now = Date()
        self.sessionId = UUID().uuidString
        self.privacyStep.storeData(PA.Privacy.Storage.Lifecycle, pairs:
                                        (LifeCycleKeys.FirstSession.rawValue, true),
                                        (LifeCycleKeys.FirstSessionDateAfterUpdate.rawValue, false),
                                        (LifeCycleKeys.SessionCount.rawValue, 1),
                                        (LifeCycleKeys.SessionCountSinceUpdate.rawValue, 1),
                                        (LifeCycleKeys.DaysSinceFirstSession.rawValue, 0),
                                        (LifeCycleKeys.DaysSinceLastSession.rawValue, 0),
                                        (LifeCycleKeys.FirstSessionDate.rawValue, now),
                                        (LifeCycleKeys.LastApplicationVersion.rawValue, PianoAnalyticsUtils.applicationInfo?.1))
    }

    private final func newSessionInit() {
        let ud = UserDefaults.standard
        self.computingMetrics.forEach { f in
            f(ud, self.privacyStep)
        }

        let now = Date()
        
        if ud.object(forKey: LifeCycleKeys.FirstSessionDate.rawValue) as? Date == nil {
            self.privacyStep.storeData(PA.Privacy.Storage.Lifecycle, pairs:
                                        (LifeCycleKeys.FirstSessionDate.rawValue, ud.object(forKey: LifeCycleKeys.FirstSessionDate.rawValue) as? Date ?? now))
        }
        
        self.privacyStep.storeData(PA.Privacy.Storage.Lifecycle, pairs:
                                        (LifeCycleKeys.FirstSession.rawValue, false),
                                        (LifeCycleKeys.FirstSessionAfterUpdate.rawValue, false),
                                        (LifeCycleKeys.LastSessionDate.rawValue, now),
                                        (LifeCycleKeys.SessionCount.rawValue, ud.integer(forKey: LifeCycleKeys.SessionCount.rawValue) + 1),
                                        (LifeCycleKeys.SessionCountSinceUpdate.rawValue, ud.integer(forKey: LifeCycleKeys.SessionCountSinceUpdate.rawValue) + 1))

        if let currentAppVersion = PianoAnalyticsUtils.applicationInfo?.1,
           currentAppVersion != ud.string(forKey: LifeCycleKeys.LastApplicationVersion.rawValue) {
            self.privacyStep.storeData(PA.Privacy.Storage.Lifecycle, pairs:
                                        (LifeCycleKeys.FirstSessionDateAfterUpdate.rawValue, now),
                                        (LifeCycleKeys.LastApplicationVersion.rawValue, currentAppVersion),
                                        (LifeCycleKeys.SessionCountSinceUpdate.rawValue, 1),
                                        (LifeCycleKeys.DaysSinceUpdate.rawValue, 0),
                                        (LifeCycleKeys.FirstSessionAfterUpdate.rawValue, true))
        }

        self.sessionId = UUID().uuidString
    }

    @objc private final func applicationDidEnterBackground() {
        self.timeBackgroundStarted = Date()
    }

    @objc private final func applicationActive() {
        guard let date = self.timeBackgroundStarted else {
            return
        }

        if let sbd = self.sessionBackgroundDuration, PianoAnalyticsUtils.secondsBetweenDates(date, toDate: Date()) > sbd {
            self.newSessionInit()
        }

        self.timeBackgroundStarted = nil
    }

    private final func getProperties() -> [String: ContextProperty] {
        let ud = UserDefaults.standard

        if !ud.bool(forKey: LifeCycleKeys.InitLifecycleDone.rawValue) {
            self.`init`()
        }

        var m = [
            PA.PropertyName.App.FirstSession: ContextProperty(value: ud.bool(forKey: LifeCycleKeys.FirstSession.rawValue)),
            PA.PropertyName.App.FirstSessionAfterUpdate: ContextProperty(value: ud.bool(forKey: LifeCycleKeys.FirstSessionAfterUpdate.rawValue)),
            PA.PropertyName.App.SessionCount: ContextProperty(value: ud.integer(forKey: LifeCycleKeys.SessionCount.rawValue)),
            PA.PropertyName.App.DaysSinceLastSession: ContextProperty(value: ud.integer(forKey: LifeCycleKeys.DaysSinceLastSession.rawValue)),
            PA.PropertyName.App.DaysSinceFirstSession: ContextProperty(value: ud.integer(forKey: LifeCycleKeys.DaysSinceFirstSession.rawValue)),
            PA.PropertyName.App.SessionId: ContextProperty(value: self.sessionId ?? "")
        ] as [String: ContextProperty]

        if let fsd = ud.object(forKey: LifeCycleKeys.FirstSessionDate.rawValue) as? Date {
            m[PA.PropertyName.App.FirstSessionDate] = ContextProperty(value: self.lifecycleDateFormatter.string(from: fsd))
        }

        if let fsdau = ud.object(forKey: LifeCycleKeys.FirstSessionDateAfterUpdate.rawValue) as? Date {
            m[PA.PropertyName.App.FirstSessionDateAfterUpdate] = ContextProperty(value: self.lifecycleDateFormatter.string(from: fsdau))
            m[PA.PropertyName.App.SessionCountSinceUpdate] = ContextProperty(value: ud.integer(forKey: LifeCycleKeys.SessionCountSinceUpdate.rawValue))
            m[PA.PropertyName.App.DaysSinceUpdate] = ContextProperty(value: ud.integer(forKey: LifeCycleKeys.DaysSinceUpdate.rawValue))
        }

        return m
    }

    // MARK: Step Implementation

    func processSetConfig(m: inout Model) {
        /// REQUIREMENTS
        let conf = m.configuration

        self.sessionBackgroundDuration = conf.get(ConfigurationKey.SessionBackgroundDuration).toInt()
    }

    func processGetModel(m: inout Model) {
        m.addContextProperties(getProperties())
    }

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        m.addContextProperties(getProperties())
        return true
    }
}
