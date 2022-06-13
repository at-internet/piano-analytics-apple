Pod::Spec.new do |s|
    s.name = 'PianoAnalytics-AppExtension'
    s.version = '3.0.1'
    s.summary = 'Piano Analytics solution for extension Apple devices'
    s.homepage = 'https://github.com/at-internet/piano-analytics-apple'
    s.documentation_url = 'https://developers.atinternet-solutions.com/piano-analytics'
    s.license = 'MIT'
    s.author = 'Piano Analytics'
    s.requires_arc = true
    s.source = { :git => 'https://github.com/at-internet/piano-analytics-apple.git', :tag => s.version}
    s.module_name = 'PianoAnalyticsAppExtension'
    s.ios.deployment_target = '10.0'
    s.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DAT_EXTENSION' }
    s.source_files = 'Sources/**/*.swift'
    s.resource = 'Sources/PianoAnalytics/default.json'
    s.platform = :ios, '10.0'
    s.swift_versions = '5'
end
