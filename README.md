<div id="top"></div>

<br />
<div align="center">
    <h1 align="center">Piano Analytics SDK Apple</h1>
</div>

<!-- ABOUT THE PROJECT -->
## About The Project


The Piano Analytics Apple SDK allows you to collect audience measurement data for the [Piano Analytics](https://piano.io/product/analytics/) solution.
It can be used with iOS, watchOS, tvOS and iOS extension applications.

This SDK makes the implementation of Piano Analytics as simple as possible, while keeping all the flexibility of the solution. By using this small library in your applications, and using [dedicated and documented methods](https://developers.atinternet-solutions.com/piano-analytics/), you will be able to send powerful events.

It also includes [Privacy tagging methods](https://developers.atinternet-solutions.com/piano-analytics/data-collection/privacy) that allow you a perfect management of your tagging depending on the regulation you refer to.


<!-- GETTING STARTED -->
## Getting Started

- Install our library on your project (see below), you have a few possibilities :
    - Using NPM
    - Using our CDN (browser only)
  - Cloning the GitHub project to build a file you will host (browser only)
    - You can use this method if you want to configure your library without additional tagging (ex: like having your site and collect domain already configured in the built file). However, we suggest the NPM method if you use Build Tools (webpack etc.) 
- Check the <a href="https://developers.atinternet-solutions.com/piano-analytics/"><strong>documentation</strong></a> for an overview of the functionalities and code examples

## Using Cocoapods

If you are new to Cocoapods, please refer to [CocoaPods documentation](https://guides.cocoapods.org/)

1. Update your Podfile with the according line(s)  
    ```sh
    # iOS Application
    pod "PianoAnalytics/iOS", ">=3.1"
    
    # tvOS Application
    pod "PianoAnalytics/tvOS", ">=3.1"
    
    # watchOS Application
    pod "PianoAnalytics/watchOS", ">=3.1"
    
    # iOS Application
    pod "PianoAnalytics/appExtension", ">=3.1"
    ```
    
    To avoid conflicts caused by [CocoaPods](https://github.com/CocoaPods/CocoaPods/issues/8206), it's possible to use an independent pod:
    ```sh
    target 'MyProject' do
        pod "PianoAnalytics-AppExtension", ">=3.1"
        use_frameworks!
    end
    ```
    
    If you do not have any other pods, your Podfile should look something like:
    ```sh
    target 'MyProject' do
        pod "PianoAnalytics/iOS", ">=3.1"
        use_frameworks!
    end
    ```

2. Save your Podfile
 
3. Run `pod install`

<p align="right">(<a href="#top">back to top</a>)</p>

## Using Swift Package Manager

1. In your application click File > Add Packages...

2. Paste the url of the public repository in the search box on the top right `https://github.com/at-internet/piano-analytics-apple`

3. Select piano-analytics-apple package

4. Click Add Package

<p align="right">(<a href="#top">back to top</a>)</p>

## Using Carthage

1. Update the Cartfile with the following line: 
    ```swift
    github "at-internet/piano-analytics-apple" ~> 3.1
    ```
2. Save your Cartfile

3. Run `carthage update --platform iOS` with the according platform (you may need to use the `--use-xcframeworks` option in case of failure)

4. Add the dependency from Build/PianoAnalytics.xcframework in "Frameworks, Libraries, and Embedded Content"

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- USAGE EXAMPLES -->
## Usage

1. Configure your site and collect domain in your application initialization
    ```swift
    import PianoAnalytics
    
    ...
    
    pa.setConfiguration(ConfigurationBuilder()
        .withCollectDomain("log.xiti.com")
        .withSite(123456789)
        .build()
    )
    ```

2. Send events
    ```swift
    pa.sendEvent(Event("page.display", data: [
        "page": "page name", // Event properties
        "page_chapter1": "chapter 1",
        "page_chapter2": "chapter 2",
        "page_chapter3": "chapter 3"
    ]))
    ```
    or
    ```swift
    pa.sendEvent(Event(PA.EventName.Page.Display, properties: Set([
        try! Property("page", "name"),
        try! Property("enabled", true),
        try! Property("count", "1", forceType: .int)
    ])))
    ```

_For more examples, please refer to the [Documentation](https://developers.atinternet-solutions.com/piano-analytics/)_

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTRIBUTING -->
## Contributing

Please do not hesitate to contribute by using this github project, we will look at any merge request or issue. 
Note that we will always close merge request when accepting (or refusing) it as any modification has to be done from our side exclusively (so we will be the ones to implement your merge request if we consider it useful).
Also, it is possible that issues and requests from GitHub may take longer for us to process as we have dedicated support tools for our customers. So we suggest that you use GitHub tools for technical purposes only :)



<!-- LICENSE -->
## License

Distributed under the MIT License.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

AtInternet a Piano Company - support@atinternet.com

<p align="right">(<a href="#top">back to top</a>)</p>
