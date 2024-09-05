//
//  Property.swift
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

public final class Property {
    
    private static let nameExpression = try! NSRegularExpression(pattern: "^[a-z]\\w*$")
    
    private static func check(name: String) -> Bool {
        Property.nameExpression.matches(in: name, range: NSRange(name.startIndex..., in: name)).count > 0
    }
    
    fileprivate let name: String
    fileprivate let lowerCasedName: String
    
    internal let value: Any
    
    private init(name: String, value: Any, forceType: PA.PropertyType? = nil) throws {
        self.lowerCasedName = name.lowercased()
        guard name.count <= 40
                && !lowerCasedName.hasPrefix("m_")
                && !lowerCasedName.hasPrefix("visit_")
                && (name == "*" || Property.check(name: lowerCasedName)) else {
            throw PA.Err(
                message:
                    "Property name can contain only `a-z`, `0-9`, `_`, " +
                    "must begin with `a-z`, " +
                    "must not begin with m_ or visit_. " +
                    "Max allowed length: 40"
            )
        }
        self.name = forceType?.rawValue.appending(":\(name)") ?? name
        self.value = value
    }
    
    public convenience init(_ name: String, _ value: Bool, forceType: PA.PropertyType? = nil) throws {
        try self.init(name: name, value: value, forceType: forceType)
    }
    
    convenience init(_ name: String, _ value: Int, forceType: PA.PropertyType? = nil) throws {
        try self.init(name: name, value: value, forceType: forceType)
    }
    
    convenience init(_ name: String, _ value: Int64, forceType: PA.PropertyType? = nil) throws {
        try self.init(name: name, value: value, forceType: forceType)
    }
    
    convenience init(_ name: String, _ value: Double, forceType: PA.PropertyType? = nil) throws {
        try self.init(name: name, value: value, forceType: forceType)
    }
    
    convenience init(_ name: String, _ value: String, forceType: PA.PropertyType? = nil) throws {
        try self.init(name: name, value: value, forceType: forceType)
    }
    
    convenience init(_ name: String, _ value: Date) throws {
        try self.init(name: name, value: Int64(value.timeIntervalSince1970), forceType: .date)
    }
    
    convenience init(_ name: String, _ value: [Int], forceType: PA.PropertyType? = nil) throws {
        try self.init(name: name, value: value, forceType: forceType)
    }
    
    convenience init(_ name: String, _ value: [Double], forceType: PA.PropertyType? = nil) throws {
        try self.init(name: name, value: value, forceType: forceType)
    }
    
    convenience init(_ name: String, _ value: [String], forceType: PA.PropertyType? = nil) throws {
        try self.init(name: name, value: value, forceType: forceType)
    }
}

extension Property: Hashable {
    
    public static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.lowerCasedName == rhs.lowerCasedName
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(lowerCasedName)
    }
}

internal extension Set where Element == Property {
    
    func toMap() -> [String:Any] {
        Dictionary(
            uniqueKeysWithValues: self.map { ($0.name, $0.value) }
        )
    }
}
