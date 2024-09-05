//
//  PropertyTests.swift
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

class PropertyTests: XCTestCase {
    
    func testName() throws {
        XCTAssertNoThrow(try Property("valid_name", true))
        XCTAssertNoThrow(try Property("Valid_Name", true))
        XCTAssertNoThrow(try Property("ValidName", true))
        XCTAssertThrowsError(try Property("invalid-name", true))
    }
    
    func testValues() throws {
        let now = Date()
        
        let properties = Set([
            try Property("bool", true),
            try Property("bool_force", "true", forceType: .bool),
            try Property("int", 1),
            try Property("int_force", "1", forceType: .int),
            try Property("int64", Int64.max),
            try Property("int64_force", "\(Int64.max)", forceType: .int),
            try Property("double", 1.1),
            try Property("double_force", "1.1", forceType: .float),
            try Property("string", "value"),
            try Property("string_force", 1, forceType: .string),
            try Property("date", now),
            try Property("int_array", [1]),
            try Property("int_array_force", "1", forceType: .intArray),
            try Property("double_array", [1.1]),
            try Property("double_array_force", "1", forceType: .floatArray),
            try Property("string_array", ["value"]),
            try Property("string_array_force", 1, forceType: .stringArray),
        ]).toMap()
        
        XCTAssertEqual(properties["bool"] as? Bool, true)
        XCTAssertEqual(properties["b:bool_force"] as? String, "true")
        XCTAssertEqual(properties["int"] as? Int, 1)
        XCTAssertEqual(properties["n:int_force"] as? String, "1")
        XCTAssertEqual(properties["int64"] as? Int64, Int64.max)
        XCTAssertEqual(properties["n:int64_force"] as? String, "\(Int64.max)")
        XCTAssertEqual(properties["double"] as? Double, 1.1)
        XCTAssertEqual(properties["f:double_force"] as? String, "1.1")
        XCTAssertEqual(properties["string"] as? String, "value")
        XCTAssertEqual(properties["s:string_force"] as? Int, 1)
        XCTAssertEqual(properties["d:date"] as? Int64, Int64(now.timeIntervalSince1970))
        XCTAssertEqual(properties["int_array"] as? [Int], [1])
        XCTAssertEqual(properties["a:n:int_array_force"] as? String, "1")
        XCTAssertEqual(properties["double_array"] as? [Double], [1.1])
        XCTAssertEqual(properties["a:f:double_array_force"] as? String, "1")
        XCTAssertEqual(properties["string_array"] as? [String], ["value"])
        XCTAssertEqual(properties["a:s:string_array_force"] as? Int, 1)
    }
    
    func testDuplicate() throws {
        var set = Set([
            try Property("value", 1),
            try Property("value", 2)
        ])
        
        set.insert(try Property("value", 3))
        
        XCTAssertEqual(set.count, 1)
        XCTAssertEqual(set.first?.value as? Int, 1)
    }
}

func nnn() {
    
pa.sendEvent(
    Event(PA.EventName.Page.Display, properties: Set([
        try! Property("page", "name"),
        try! Property("enabled", true),
        try! Property("count", "1", forceType: .int)
    ]))
)
}
