//
//  Constants.swift
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

struct PrivacyModeProperties {
    var allowed: [String: Set<String>]
    var forbidden: [String: Set<String>]
}

struct PrivacyModeEvents {
    var allowed: Set<String>
    var forbidden: Set<String>
}

struct PrivacyModeStorage {
    var allowed: Set<String>
    var forbidden: Set<String>
}

struct PrivacyMode {
    var name: String
    var properties: PrivacyModeProperties
    var events: PrivacyModeEvents
    var storage: PrivacyModeStorage
    var visitorConsent: Bool
    var customVisitorId: String?
}

public struct PA {

    public struct Time {
        static let DayInMs = 1000 * 60 * 60 * 24
    }

    public struct Configuration {
        static let Location = "piano-analytics-config"
        static let Default = "default"
        static let Extension = "json"
    }

    public struct Privacy {

        static let Wildcard = "*"
        static let DefaultModes: Set<String> = ["*", "optin", "optout", "exempt", "no-consent", "no-storage"]
        static let DefaultStorageModes = ["pa_vid", "pa_crash", "pa_lifecycle", "pa_privacy", "pa_uid"]

        static let Modes = [
            PA.Privacy.Mode.All.Name: PrivacyMode(
                name: PA.Privacy.Mode.All.Name,
                properties: PrivacyModeProperties(
                    allowed: PA.Privacy.Mode.All.AllowedProperties,
                    forbidden: PA.Privacy.Mode.All.ForbiddenProperties
                ),
                events: PrivacyModeEvents(
                    allowed: PA.Privacy.Mode.All.AllowedEvents,
                    forbidden: PA.Privacy.Mode.All.ForbiddenEvents
                ),
                storage: PrivacyModeStorage(
                    allowed: PA.Privacy.Mode.All.AllowedStorage,
                    forbidden: []
                ),
                visitorConsent: false,
                customVisitorId: nil
            ),
            PA.Privacy.Mode.OptIn.Name: PrivacyMode(
                name: PA.Privacy.Mode.OptIn.Name,
                properties: PrivacyModeProperties(
                    allowed: PA.Privacy.Mode.OptIn.AllowedProperties,
                    forbidden: PA.Privacy.Mode.OptIn.ForbiddenProperties
                ),
                events: PrivacyModeEvents(
                    allowed: PA.Privacy.Mode.OptIn.AllowedEvents,
                    forbidden: PA.Privacy.Mode.OptIn.ForbiddenEvents
                ),
                storage: PrivacyModeStorage(
                    allowed: PA.Privacy.Mode.OptIn.AllowedStorage,
                    forbidden: []
                ),
                visitorConsent: true,
                customVisitorId: nil
            ),
            PA.Privacy.Mode.OptOut.Name: PrivacyMode(
                name: PA.Privacy.Mode.OptOut.Name,
                properties: PrivacyModeProperties(
                    allowed: PA.Privacy.Mode.OptOut.AllowedProperties,
                    forbidden: PA.Privacy.Mode.OptOut.ForbiddenProperties
                ),
                events: PrivacyModeEvents(
                    allowed: PA.Privacy.Mode.OptOut.AllowedEvents,
                    forbidden: PA.Privacy.Mode.OptOut.ForbiddenEvents
                ),
                storage: PrivacyModeStorage(
                    allowed: PA.Privacy.Mode.OptOut.AllowedStorage,
                    forbidden: []
                ),
                visitorConsent: false,
                customVisitorId: "opt-out"
            ),
            PA.Privacy.Mode.Exempt.Name: PrivacyMode(
                name: PA.Privacy.Mode.Exempt.Name,
                properties: PrivacyModeProperties(
                    allowed: PA.Privacy.Mode.Exempt.AllowedProperties,
                    forbidden: PA.Privacy.Mode.Exempt.ForbiddenProperties
                ),
                events: PrivacyModeEvents(
                    allowed: PA.Privacy.Mode.Exempt.AllowedEvents,
                    forbidden: PA.Privacy.Mode.Exempt.ForbiddenEvents
                ),
                storage: PrivacyModeStorage(
                    allowed: PA.Privacy.Mode.Exempt.AllowedStorage,
                    forbidden: []
                ),
                visitorConsent: false,
                customVisitorId: nil
            ),
            PA.Privacy.Mode.NoConsent.Name: PrivacyMode(
                name: PA.Privacy.Mode.NoConsent.Name,
                properties: PrivacyModeProperties(
                    allowed: PA.Privacy.Mode.NoConsent.AllowedProperties,
                    forbidden: PA.Privacy.Mode.NoConsent.ForbiddenProperties
                ),
                events: PrivacyModeEvents(
                    allowed: PA.Privacy.Mode.NoConsent.AllowedEvents,
                    forbidden: PA.Privacy.Mode.NoConsent.ForbiddenEvents
                ),
                storage: PrivacyModeStorage(
                    allowed: PA.Privacy.Mode.NoConsent.AllowedStorage,
                    forbidden: []
                ),
                visitorConsent: false,
                customVisitorId: nil
            ),
            PA.Privacy.Mode.NoStorage.Name: PrivacyMode(
                name: PA.Privacy.Mode.NoStorage.Name,
                properties: PrivacyModeProperties(
                    allowed: PA.Privacy.Mode.NoStorage.AllowedProperties,
                    forbidden: PA.Privacy.Mode.NoStorage.ForbiddenProperties
                ),
                events: PrivacyModeEvents(
                    allowed: PA.Privacy.Mode.NoStorage.AllowedEvents,
                    forbidden: PA.Privacy.Mode.NoStorage.ForbiddenEvents
                ),
                storage: PrivacyModeStorage(
                    allowed: PA.Privacy.Mode.NoStorage.AllowedStorage,
                    forbidden: []
                ),
                visitorConsent: false,
                customVisitorId: nil
            )
        ]

        public struct Storage {
            public static let VisitorId = "pa_vid"
            public static let Crash = "pa_crash"
            public static let Lifecycle = "pa_lifecycle"
            public static let Privacy = "pa_privacy"
            public static let User = "pa_uid"
        }

        struct Mode {
            struct All {
                static let Name = "*"
                static let AllowedEvents: Set<String> = []
                static let ForbiddenEvents: Set<String> = []
                static let AllowedProperties: [String: Set<String>] = [:]
                static let ForbiddenProperties: [String: Set<String>] = [:]
                static let AllowedStorage: Set<String> = []
            }
            struct OptIn {
                static let Name = "optin"
                static let AllowedEvents: Set<String> = [PA.Privacy.Wildcard]
                static let ForbiddenEvents: Set<String> = []
                static let AllowedProperties: [String: Set<String>] = [PA.Privacy.Wildcard: [PA.Privacy.Wildcard]]
                static let ForbiddenProperties: [String: Set<String>] = [:]
                static let AllowedStorage: Set<String> = [PA.Privacy.Storage.VisitorId, PA.Privacy.Storage.Crash, PA.Privacy.Storage.Lifecycle, PA.Privacy.Storage.Privacy, PA.Privacy.Storage.User]
            }
            struct OptOut {
                static let Name = "optout"
                static let AllowedEvents: Set<String> = [PA.Privacy.Wildcard]
                static let ForbiddenEvents: Set<String> = []
                static let AllowedProperties: [String: Set<String>] = [
                    "*": [
                        "visitor_privacy_consent",
                        "visitor_privacy_mode",
                        "connection_type",
                        "device_timestamp_utc",
                    ]
                ]
                static let ForbiddenProperties: [String: Set<String>] = [:]
                static let AllowedStorage: Set<String> = [PA.Privacy.Storage.Privacy]
            }
            struct NoConsent {
                static let Name = "no-consent"
                static let AllowedEvents: Set<String> = [PA.Privacy.Wildcard]
                static let ForbiddenEvents: Set<String> = []
                static let AllowedProperties: [String: Set<String>] = [
                    "*": [
                        "visitor_privacy_consent",
                        "visitor_privacy_mode",
                        "connection_type",
                        "device_timestamp_utc",
                    ]
                ]
                static let ForbiddenProperties: [String: Set<String>] = [:]
                static let AllowedStorage: Set<String> = []
            }
            struct NoStorage {
                static let Name = "no-storage"
                static let AllowedEvents: Set<String> = ["*"]
                static let ForbiddenEvents: Set<String> = []
                static let AllowedProperties: [String: Set<String>] = ["*": ["*"]]
                static let ForbiddenProperties: [String: Set<String>] = [:]
                static let AllowedStorage: Set<String> = []
            }
            struct Exempt {
                static let Name = "exempt"
                static let AllowedEvents: Set<String> = [
                    "click.exit",
                    "click.navigation",
                    "click.download",
                    "click.action",
                    "page.display"
                ]
                static let ForbiddenEvents: Set<String> = []
                static let AllowedProperties: [String: Set<String>] = [PA.Privacy.Wildcard: [
                    "app_crash",
                    "app_crash_class",
                    "app_crash_screen",
                    "app_version",
                    "browser",
                    "browser_cookie_acceptance",
                    "browser_group",
                    "browser_version",
                    "click",
                    "click_chapter1",
                    "click_chapter2",
                    "click_chapter3",
                    "click_full_name",
                    "connection_monitor",
                    "connection_organisation",
                    "date",
                    "date_day",
                    "date_daynumber",
                    "date_month",
                    "date_monthnumber",
                    "date_week",
                    "date_year",
                    "date_yearofweek",
                    "device_brand",
                    "device_display_height",
                    "device_display_width",
                    "device_name",
                    "device_name_tech",
                    "device_screen_diagonal",
                    "device_screen_height",
                    "device_screen_width",
                    "device_type",
                    "event_collection_platform",
                    "event_collection_version",
                    "event_hour",
                    "event_id",
                    "event_minute",
                    "event_name",
                    "event_position",
                    "event_second",
                    "event_time",
                    "event_time_utc",
                    "event_url",
                    "event_url_domain",
                    "event_url_full",
                    "exclusion_cause",
                    "exclusion_type",
                    "geo_city",
                    "geo_continent",
                    "geo_country",
                    "geo_metro",
                    "geo_region",
                    "hit_time_utc",
                    "os",
                    "os_group",
                    "os_version",
                    "os_version_name",
                    "page",
                    "page_chapter1",
                    "page_chapter2",
                    "page_chapter3",
                    "page_duration",
                    "page_full_name",
                    "page_position",
                    "privacy_status",
                    "site",
                    "site_env",
                    "site_id",
                    "site_platform",
                    "src",
                    "src_detail",
                    "src_direct_access",
                    "src_organic",
                    "src_organic_detail",
                    "src_portal_domain",
                    "src_portal_site",
                    "src_portal_site_id",
                    "src_portal_url",
                    "src_referrer_site_domain",
                    "src_referrer_site_url",
                    "src_referrer_url",
                    "src_se",
                    "src_se_category",
                    "src_se_country",
                    "src_type",
                    "src_url",
                    "src_url_domain",
                    "src_webmail",
                    "visit_bounce",
                    "visit_duration",
                    "visit_entrypage",
                    "visit_entrypage_chapter1",
                    "visit_entrypage_chapter2",
                    "visit_entrypage_chapter3",
                    "visit_entrypage_full_name",
                    "visit_exitpage",
                    "visit_exitpage_chapter1",
                    "visit_exitpage_chapter2",
                    "visit_exitpage_chapter3",
                    "visit_exitpage_full_name",
                    "visit_hour",
                    "visit_id",
                    "visit_minute",
                    "visit_page_views",
                    "visit_second",
                    "visit_time",
                    "visitor_privacy_consent",
                    "visitor_privacy_mode",
                    "connection_type",
                    "device_timestamp_utc"
                ]]
                static let ForbiddenProperties: [String: Set<String>] = [:]
                static let AllowedStorage: Set<String> = [PA.Privacy.Storage.Crash, PA.Privacy.Storage.Privacy, PA.Privacy.Storage.User]
            }
        }

    }
}
