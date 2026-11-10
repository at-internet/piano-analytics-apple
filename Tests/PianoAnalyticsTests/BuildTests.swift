//
//  BuildTests.swift
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

class BuildTests: XCTestCase {

    private static let Url = "https://example.com/a/b"

    private func buildChunks(_ options: JSONSerialization.WritingOptions?) -> [String] {
        var m = Model()
        m.events = [Event(PA.EventName.Page.Display, data: ["url": BuildTests.Url])]
        let step = options.map { BuildStep($0) } ?? BuildStep()
        XCTAssertTrue(step.processSendEvents(m: &m, p: nil))
        return m.builtModel?.chunks ?? []
    }

    private func parse(_ chunk: String) throws -> NSDictionary {
        let object = try JSONSerialization.jsonObject(with: Data(chunk.utf8), options: [])
        return try XCTUnwrap(object as? NSDictionary)
    }

    func testExtendedConfigurationDefault() {
        XCTAssertEqual(PA.ExtendedConfiguration().jsonWritingOptions, [])
    }

    func testDefaultOptionsEscapeSlashes() throws {
        let chunks = buildChunks(nil)

        XCTAssertEqual(chunks.count, 1)
        let chunk = try XCTUnwrap(chunks.first)
        XCTAssertTrue(chunk.contains(#"https:\/\/example.com\/a\/b"#), chunk)
    }

    func testWithoutEscapingSlashes() throws {
        let chunks = buildChunks([.withoutEscapingSlashes])

        XCTAssertEqual(chunks.count, 1)
        let chunk = try XCTUnwrap(chunks.first)
        XCTAssertTrue(chunk.contains(BuildTests.Url), chunk)
        XCTAssertFalse(chunk.contains(#"\/"#), chunk)
    }

    func testOutputsAreEquivalentJSON() throws {
        let escaped = try XCTUnwrap(buildChunks(nil).first)
        let unescaped = try XCTUnwrap(buildChunks([.withoutEscapingSlashes]).first)

        XCTAssertNotEqual(escaped, unescaped)
        XCTAssertEqual(try parse(escaped), try parse(unescaped))
    }
}
