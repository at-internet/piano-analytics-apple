//
//  SendTests.swift
//  PianoAnalyticsTests
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

import XCTest
@testable import PianoAnalytics

class PianoAnalyticsCallbacks: PianoAnalyticsWorkProtocol {

    var builtModel: BuiltModel?
    var completionHandler: ((_: BuiltModel?, _: [String: BuiltModel]?) -> Void)

    init(_ completionHandler: @escaping (_: BuiltModel?, _: [String: BuiltModel]?) -> Void) {
        self.completionHandler = completionHandler
    }

    func onBeforeBuild(model: inout Model) -> Bool {
        return true
    }

    func onBeforeSend(built: BuiltModel?, stored: [String: BuiltModel]?) -> Bool {
        builtModel = built
        self.completionHandler(built, stored)
        return true
    }
}

class SendTests: XCTestCase {

    var pa = PianoAnalytics()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        pa = PianoAnalytics(configFileLocation: "default-test.json")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let expectation = self.expectation(description: "Model")
        var model: Model = Model()

        self.pa.setConfiguration(ConfigurationBuilder()
            .withSite(123456789)
            .withCollectDomain("log.xiti.com")
            .build()
        )
        self.pa.getModel { m in
            model = m
        }
        self.pa.sendEvent(Event("page.display"), config: nil, p: PianoAnalyticsCallbacks { _, _ in
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)

    }

}
