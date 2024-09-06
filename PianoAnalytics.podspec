Pod::Spec.new do |s|
    s.name = 'PianoAnalytics'
    s.version = '3.1.6'
    s.summary = 'Piano Analytics library for Apple devices'
    s.homepage = 'https://github.com/at-internet/piano-analytics-apple'
    s.documentation_url = 'https://developers.atinternet-solutions.com/piano-analytics'
    s.license = 'MIT'
    s.author = 'Piano Analytics'
    s.requires_arc = true
    s.source = { :git => 'https://github.com/at-internet/piano-analytics-apple.git', :tag => s.version}
    s.dependency 'PianoConsents', ">= 1.0"
    s.module_name = 'PianoAnalytics'
    s.ios.deployment_target = '10.0'
    s.tvos.deployment_target = '10.0'
    s.watchos.deployment_target = '3.0'
    s.swift_versions = '5'

    s.subspec 'iOS' do |d|
        d.source_files = 'Sources/**/*.swift'
        d.platform = :ios
        d.resource_bundle = {
            "PianoAnalytics_iOS" => ["Sources/PianoAnalytics/Resources/*.xcprivacy"]
        }
        d.resource = 'Sources/PianoAnalytics/Resources/*.json'
    end

    s.subspec 'appExtension' do |appExt|
        appExt.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DAT_EXTENSION' }
        appExt.source_files = 'Sources/**/*.swift'
        appExt.platform = :ios
        appExt.resource_bundle = {
            "PianoAnalytics_appExtension" => ["Sources/PianoAnalytics/Resources/*.xcprivacy"]
        }
        appExt.resource = 'Sources/PianoAnalytics/Resources/*.json'
    end

    s.subspec 'watchOS' do |wos|
        wos.source_files = 'Sources/**/*.swift'
        wos.platform = :watchos
        wos.resource_bundle = {
            "PianoAnalytics_watchOS" => ["Sources/PianoAnalytics/Resources/*.xcprivacy"]
        }
        wos.resource = 'Sources/PianoAnalytics/Resources/*.json'
    end

    s.subspec 'tvOS' do |tvos|
        tvos.source_files = 'Sources/**/*.swift'
        tvos.platform = :tvos
        tvos.resource_bundle = {
            "PianoAnalytics_tvOS" => ["Sources/PianoAnalytics/Resources/*.xcprivacy"]
        }
        tvos.resource = 'Sources/PianoAnalytics/Resources/*.json'
    end
end
