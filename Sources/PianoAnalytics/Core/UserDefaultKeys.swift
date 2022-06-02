//
//  UserDefaultKeys.swift
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

enum PrivacyKeys: String, CaseIterable {
    case PrivacyMode = "ATPrivacyMode"
    case PrivacyModeExpirationTimestamp = "ATPrivacyModeExpirationTimestamp"
    case PrivacyVisitorConsent = "ATPrivacyVisitorConsent"
    case PrivacyVisitorId = "ATPrivacyUserId"
}

enum VisitorIdKeys: String, CaseIterable {
    case VisitorUUID = "ATApplicationUniqueIdentifier"
    case VisitorUUIDGenerationTimestamp = "ATUserIdGenerationTimestamp"
}

enum LifeCycleKeys: String, CaseIterable {
    case FirstInitLifecycleDone = "ATFirstInitLifecycleDone"
    case InitLifecycleDone = "ATInitLifecycleDone"
    case FirstSession = "ATFirstLaunch"
    case FirstSessionAfterUpdate = "ATFirstLaunchAfterUpdate"
    case LastSessionDate = "ATLastUse"
    case FirstSessionDate = "ATFirstLaunchDate"
    case SessionCount = "ATLaunchCount"
    case LastApplicationVersion = "ATLastApplicationVersion"
    case FirstSessionDateAfterUpdate = "ATApplicationUpdate"
    case SessionCountSinceUpdate = "ATLaunchCountSinceUpdate"
    case DaysSinceFirstSession = "ATDaysSinceFirstSession"
    case DaysSinceUpdate = "ATDaysSinceUpdate"
    case DaysSinceLastSession = "ATDaysSinceLastSession"
}

enum CrashKeys: String, CaseIterable {
    case Crashed = "ATCrashed"
    case CrashInfo = "ATCrashInfo"
}

enum UserKeys: String, CaseIterable {
    case Users = "ATUsers"
    case UserGenerationTimestamp = "PAUserGenerationTimestamp"
}
