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

import PianoConsents

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
    
    public struct EventName {
        
        public struct Page {
            static let Display = "page.display"
        }
        
        public struct Click {
            static let Action = "click.action"
            static let Navigation = "click.navigation"
            static let Exit = "click.exit"
            static let Download = "click.download"
        }
        
        public struct Publisher {
            static let Impression = "publisher.impression"
            static let Click = "publisher.click"
        }
        
        public struct SelfPromotion {
            static let Impression = "self_promotion.impression"
            static let Click = "self_promotion.click"
        }
        
        public struct InternalSearchResult {
            static let Display = "internal_search_result.display"
            static let Click = "internal_search_result.click"
        }
        
        public struct MvTest {
            static let Display = "mv_test.display"
        }
    }
    
    public enum PropertyType: String {
        case bool = "b"
        case int = "n"
        case float = "f"
        case string = "s"
        case date = "d"
        case intArray = "a:n"
        case floatArray = "a:f"
        case stringArray = "a:s"
    }
    
    public struct PropertyName {
        
        public static let HitTimeUTC = "hit_time_utc"
        public static let PrivacyStatus = "privacy_status"
        
        public struct App {
            public static let Crash = "app_crash"
            public static let CrashClass = "app_crash_class"
            public static let CrashScreen = "app_crash_screen"
            public static let DaysSinceFirstSession = "app_dsfs"
            public static let DaysSinceLastSession = "app_dsls"
            public static let DaysSinceUpdate = "app_dsu"
            public static let Id = "app_id"
            public static let FirstSession = "app_fs"
            public static let FirstSessionAfterUpdate = "app_fsau"
            public static let FirstSessionDate = "app_fsd"
            public static let FirstSessionDateAfterUpdate = "app_fsdau"
            public static let SessionCount = "app_sc"
            public static let SessionCountSinceUpdate = "app_scsu"
            public static let SessionId = "app_sessionid"
            public static let Version = "app_version"
        }
        
        public struct Browser {
            public static let Browser = "browser"
            public static let Language = "browser_language"
            public static let LanguageLocal = "browser_language_local"
            public static let CookieAcceptance = "browser_cookie_acceptance"
            public static let Group = "browser_group"
            public static let Version = "browser_version"
        }
        
        public struct Click {
            public static let Click = "click"
            public static let Chapter1 = "click_chapter1"
            public static let Chapter2 = "click_chapter2"
            public static let Chapter3 = "click_chapter3"
            public static let FullName = "click_full_name"
        }
        
        public struct Connection {
            public static let Monitor = "connection_monitor"
            public static let Organisation = "connection_organisation"
            public static let ConnectionType = "connection_type"
        }
        
        public struct Date {
            public static let Date = "date"
            public static let Day = "date_day"
            public static let DayNumber = "date_daynumber"
            public static let Month = "date_month"
            public static let MonthNumber = "date_monthnumber"
            public static let Week = "date_week"
            public static let Year = "date_year"
            public static let YearOfWeek = "date_yearofweek"
        }
        
        public struct Device {
            public static let Brand = "device_brand"
            public static let Manufacturer = "device_manufacturer"
            public static let Model = "device_model"
            public static let DisplayHeight = "device_display_height"
            public static let DisplayWidth = "device_display_width"
            public static let Name = "device_name"
            public static let NameTech = "device_name_tech"
            public static let ScreenDiagonal = "device_screen_diagonal"
            public static let ScreenHeight = "device_screen_height"
            public static let ScreenWidth = "device_screen_width"
            public static let TimestampUTC = "device_timestamp_utc"
            public static let DeviceType = "device_type"
        }
        
        public struct Event {
            public static let CollectionPlatform = "event_collection_platform"
            public static let CollectionVersion = "event_collection_version"
            public static let Hour = "event_hour"
            public static let Id = "event_id"
            public static let Minute = "event_minute"
            public static let Name = "event_name"
            public static let Position = "event_position"
            public static let Second = "event_second"
            public static let Time = "event_time"
            public static let TimeUTC = "event_time_utc"
            public static let Url = "event_url"
            public static let UrlDomain = "event_url_domain"
            public static let UrlFull = "event_url_full"
        }
        
        public struct Exclusion {
            public static let Cause = "exclusion_cause"
            public static let ExclusionType = "exclusion_type"
        }
        
        public struct Geo {
            public static let City = "geo_city"
            public static let Continent = "geo_continent"
            public static let Country = "geo_country"
            public static let Metro = "geo_metro"
            public static let Region = "geo_region"
        }
        
        public struct OS {
            public static let OS = "os"
            public static let Group = "os_group"
            public static let Version = "os_version"
            public static let VersionName = "os_version_name"
        }
        
        public struct Page {
            public static let Page = "page"
            public static let Chapter1 = "page_chapter1"
            public static let Chapter2 = "page_chapter2"
            public static let Chapter3 = "page_chapter3"
            public static let Duration = "page_duration"
            public static let FullName = "page_full_name"
            public static let Position = "page_position"
        }
        
        public struct Site {
            public static let Site = "site"
            public static let Env = "site_env"
            public static let Id = "site_id"
            public static let Platform = "site_platform"
        }
        
        public struct Src {
            public static let Src = "src"
            public static let Detail = "src_detail"
            public static let DirectAccess = "src_direct_access"
            public static let Organic = "src_organic"
            public static let OrganicDetail = "src_organic_detail"
            public static let PortalDomain = "src_portal_domain"
            public static let PortalSite = "src_portal_site"
            public static let PortalSiteId = "src_portal_site_id"
            public static let PortalUrl = "src_portal_url"
            public static let ReferrerSiteDomain = "src_referrer_site_domain"
            public static let ReferrerSiteUrl = "src_referrer_site_url"
            public static let ReferrerUrl = "src_referrer_url"
            public static let SE = "src_se"
            public static let SECategory = "src_se_category"
            public static let SECountry = "src_se_country"
            public static let SrcType = "src_type"
            public static let Url = "src_url"
            public static let UrlDomain = "src_url_domain"
            public static let Webmail = "src_webmail"
        }
        
        public struct Visit {
            public static let Bounce = "visit_bounce"
            public static let Duration = "visit_duration"
            public static let EntryPage = "visit_entrypage"
            public static let EntryPageChapter1 = "visit_entrypage_chapter1"
            public static let EntryPageChapter2 = "visit_entrypage_chapter2"
            public static let EntryPageChapter3 = "visit_entrypage_chapter3"
            public static let EntryPageFullName = "visit_entrypage_full_name"
            public static let ExitPage = "visit_exitpage"
            public static let ExitPageChapter1 = "visit_exitpage_chapter1"
            public static let ExitPageChapter2 = "visit_exitpage_chapter2"
            public static let ExitPageChapter3 = "visit_exitpage_chapter3"
            public static let ExitPageFullName = "visit_exitpage_full_name"
            public static let Hour = "visit_hour"
            public static let Id = "visit_id"
            public static let Minute = "visit_minute"
            public static let PageViews = "visit_page_views"
            public static let Second = "visit_second"
            public static let Time = "visit_time"
        }
        
        public struct Visitor {
            public static let PrivacyConsent = "visitor_privacy_consent"
            public static let PrivacyMode = "visitor_privacy_mode"
            public static let IdType = "visitor_id_type"
        }
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
                        PropertyName.Visitor.PrivacyConsent,
                        PropertyName.Visitor.PrivacyMode,
                        PropertyName.Connection.ConnectionType,
                        PropertyName.Device.TimestampUTC,
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
                        PropertyName.Visitor.PrivacyConsent,
                        PropertyName.Visitor.PrivacyMode,
                        PropertyName.Connection.ConnectionType,
                        PropertyName.Device.TimestampUTC,
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
                    EventName.Click.Exit,
                    EventName.Click.Navigation,
                    EventName.Click.Download,
                    EventName.Click.Action,
                    EventName.Page.Display
                ]
                static let ForbiddenEvents: Set<String> = []
                static let AllowedProperties: [String: Set<String>] = [PA.Privacy.Wildcard: [
                    PropertyName.App.Crash,
                    PropertyName.App.CrashClass,
                    PropertyName.App.CrashScreen,
                    PropertyName.App.Version,
                    PropertyName.Browser.Browser,
                    PropertyName.Browser.CookieAcceptance,
                    PropertyName.Browser.Group,
                    PropertyName.Browser.Version,
                    PropertyName.Click.Click,
                    PropertyName.Click.Chapter1,
                    PropertyName.Click.Chapter2,
                    PropertyName.Click.Chapter3,
                    PropertyName.Click.FullName,
                    PropertyName.Connection.ConnectionType,
                    PropertyName.Connection.Organisation,
                    PropertyName.Date.Date,
                    PropertyName.Date.Day,
                    PropertyName.Date.DayNumber,
                    PropertyName.Date.Month,
                    PropertyName.Date.MonthNumber,
                    PropertyName.Date.Week,
                    PropertyName.Date.Year,
                    PropertyName.Date.YearOfWeek,
                    PropertyName.Device.Brand,
                    PropertyName.Device.DisplayHeight,
                    PropertyName.Device.DisplayWidth,
                    PropertyName.Device.Manufacturer,
                    PropertyName.Device.Model,
                    PropertyName.Device.Name,
                    PropertyName.Device.NameTech,
                    PropertyName.Device.ScreenDiagonal,
                    PropertyName.Device.ScreenHeight,
                    PropertyName.Device.ScreenWidth,
                    PropertyName.Device.DeviceType,
                    PropertyName.Device.TimestampUTC,
                    PropertyName.Event.CollectionPlatform,
                    PropertyName.Event.CollectionVersion,
                    PropertyName.Event.Hour,
                    PropertyName.Event.Id,
                    PropertyName.Event.Minute,
                    PropertyName.Event.Name,
                    PropertyName.Event.Position,
                    PropertyName.Event.Second,
                    PropertyName.Event.Time,
                    PropertyName.Event.TimeUTC,
                    PropertyName.Event.Url,
                    PropertyName.Event.UrlDomain,
                    PropertyName.Event.UrlFull,
                    PropertyName.Exclusion.Cause,
                    PropertyName.Exclusion.ExclusionType,
                    PropertyName.Geo.City,
                    PropertyName.Geo.Continent,
                    PropertyName.Geo.Country,
                    PropertyName.Geo.Metro,
                    PropertyName.Geo.Region,
                    PropertyName.HitTimeUTC,
                    PropertyName.OS.OS,
                    PropertyName.OS.Group,
                    PropertyName.OS.Version,
                    PropertyName.OS.VersionName,
                    PropertyName.Page.Page,
                    PropertyName.Page.Chapter1,
                    PropertyName.Page.Chapter2,
                    PropertyName.Page.Chapter3,
                    PropertyName.Page.Duration,
                    PropertyName.Page.FullName,
                    PropertyName.Page.Position,
                    PropertyName.PrivacyStatus,
                    PropertyName.Site.Site,
                    PropertyName.Site.Env,
                    PropertyName.Site.Id,
                    PropertyName.Site.Platform,
                    PropertyName.Src.Src,
                    PropertyName.Src.Detail,
                    PropertyName.Src.DirectAccess,
                    PropertyName.Src.Organic,
                    PropertyName.Src.OrganicDetail,
                    PropertyName.Src.PortalDomain,
                    PropertyName.Src.PortalSite,
                    PropertyName.Src.PortalSiteId,
                    PropertyName.Src.PortalUrl,
                    PropertyName.Src.ReferrerSiteDomain,
                    PropertyName.Src.ReferrerSiteUrl,
                    PropertyName.Src.ReferrerUrl,
                    PropertyName.Src.SE,
                    PropertyName.Src.SECategory,
                    PropertyName.Src.SECountry,
                    PropertyName.Src.SrcType,
                    PropertyName.Src.Url,
                    PropertyName.Src.UrlDomain,
                    PropertyName.Src.Webmail,
                    PropertyName.Visit.Bounce,
                    PropertyName.Visit.Duration,
                    PropertyName.Visit.EntryPage,
                    PropertyName.Visit.EntryPageChapter1,
                    PropertyName.Visit.EntryPageChapter2,
                    PropertyName.Visit.EntryPageChapter3,
                    PropertyName.Visit.EntryPageFullName,
                    PropertyName.Visit.ExitPage,
                    PropertyName.Visit.ExitPageChapter1,
                    PropertyName.Visit.ExitPageChapter2,
                    PropertyName.Visit.ExitPageChapter3,
                    PropertyName.Visit.ExitPageFullName,
                    PropertyName.Visit.Hour,
                    PropertyName.Visit.Id,
                    PropertyName.Visit.Minute,
                    PropertyName.Visit.PageViews,
                    PropertyName.Visit.Second,
                    PropertyName.Visit.Time,
                    PropertyName.Visitor.PrivacyConsent,
                    PropertyName.Visitor.PrivacyMode
                ]]
                static let ForbiddenProperties: [String: Set<String>] = [:]
                static let AllowedStorage: Set<String> = [PA.Privacy.Storage.Crash, PA.Privacy.Storage.Privacy, PA.Privacy.Storage.User, PA.Privacy.Storage.VisitorId]
            }
        }

    }
}
