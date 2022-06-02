//
//  Crypt.swift
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
#if canImport(CryptoKit)
import CryptoKit
#endif

final class Crypt {

    // MARK: Constructors

    private init() {

    }

    // MARK: Constants

    private static let ACCOUNT = "pa.encryption.key"

    // MARK: Package methods

    static func encrypt(data: String, encryptionMode: EncryptionMode) -> String? {
        if encryptionMode == EncryptionMode.None {
            return data
        }

        #if canImport(CryptoKit)
        #if os(iOS)
        if #available(iOS 13.0, *) {
            return encryption(data: data)
        }
        #elseif os(watchOS)
        if #available(watchOS 6.0, *) {
            return encryption(data: data)
        }
        #elseif os(tvOS)
        if #available(tvOS 13.0, *) {
            return encryption(data: data)
        }
        #endif
        #endif

        /// if force, we don't use original data
        return encryptionMode == EncryptionMode.IfCompatible ? data : nil
    }

    static func decrypt(data: String) -> String? {
        #if canImport(CryptoKit)
        #if os(iOS)
        if #available(iOS 13.0, *) {
            return decryption(data: data)
        }
        #elseif os(watchOS)
        if #available(watchOS 6.0, *) {
            return decryption(data: data)
        }
        #elseif os(tvOS)
        if #available(tvOS 13.0, *) {
            return decryption(data: data)
        }
        #endif
        #endif

        return data
    }

    // MARK: Private methods

    #if canImport(CryptoKit)
    @available(iOS 13.0, *)
    @available(tvOS 13.0, *)
    @available(watchOS 6, *)
    @available(macOS 10.15, *)
    private static func encryption(data: String) -> String? {

        guard let key = getKey() else { return nil }

        guard let sealData = try? AES.GCM.seal(data.data(using: .utf8)!, using: key).combined else { return nil }

        return sealData.base64EncodedString()
    }
    #endif

    #if canImport(CryptoKit)
    @available(iOS 13.0, *)
    @available(tvOS 13.0, *)
    @available(watchOS 6, *)
    @available(macOS 10.15, *)
    private static func decryption(data: String) -> String? {

        guard let decoded = Data(base64Encoded: data) else { return data }

        do {
            guard let sealedBoxRestored = try? AES.GCM.SealedBox(combined: decoded) else { return data }

            guard let key = getKey() else { return data }

            return try String(data: AES.GCM.open(sealedBoxRestored, using: key), encoding: .utf8)
        } catch { return data }
    }
    #endif

    #if canImport(CryptoKit)
    @available(iOS 13.0, *)
    @available(tvOS 13.0, *)
    @available(watchOS 6, *)
    @available(macOS 10.15, *)
    private static func getKey() -> SymmetricKey? {

        var query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: Crypt.ACCOUNT,
                     kSecUseDataProtectionKeychain: true,
                     kSecReturnData: true] as [String: Any]

        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess {
            if let optData = item as? Data {
                return SymmetricKey(data: optData)
            }
            return nil
        }

        let key = SymmetricKey(size: .bits256)
        query = [kSecClass: kSecClassGenericPassword,
                 kSecAttrAccount: Crypt.ACCOUNT,
                     kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
                     kSecUseDataProtectionKeychain: true,
                     kSecValueData: key.rawRepresentation] as [String: Any]

        _ = SecItemAdd(query as CFDictionary, nil)
        return key
    }
    #endif
}

#if canImport(CryptoKit)
@available(iOS 13.0, *)
@available(tvOS 13.0, *)
@available(watchOS 6, *)
@available(macOS 10.15, *)
extension SymmetricKey {

    public var description: String {
        return self.rawRepresentation.withUnsafeBytes { bytes in
            return "Key representation contains \(bytes.count) bytes."
        }
    }

    var rawRepresentation: Data {
        return self.withUnsafeBytes { bytes in
            let cfdata = CFDataCreateWithBytesNoCopy(nil, bytes.baseAddress?.assumingMemoryBound(to: UInt8.self), bytes.count, kCFAllocatorNull)
            return ((cfdata as NSData?) as Data?) ?? Data()
        }
    }
}
#endif

#if canImport(CryptoKit)
@available(iOS 13.0, *)
@available(tvOS 13.0, *)
@available(watchOS 6, *)
@available(macOS 10.15, *)
private struct SymmetricKeyStore {

    /// Stores a CryptoKit key in the keychain as a generic password.
    func storeKey(_ key: SymmetricKey, account: String) -> SymmetricKey? {

        // Treat the key data as a generic password.
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: account,
                     kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock,
                     kSecUseDataProtectionKeychain: true,
                     kSecValueData: key.rawRepresentation] as [String: Any]

        // Add the key data.
        _ = SecItemAdd(query as CFDictionary, nil)
        return readKey(account: account)
    }

    /// Reads a CryptoKit key from the keychain as a generic password.
    func readKey(account: String) -> SymmetricKey? {

        // Seek a generic password with the given account.
        let query = [kSecClass: kSecClassGenericPassword,
                     kSecAttrAccount: account,
                     kSecUseDataProtectionKeychain: true,
                     kSecReturnData: true] as [String: Any]

        // Find and cast the result as data.
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess {
            if let optData = item as? Data {
                return SymmetricKey(data: optData)
            }
        }

        return nil
    }
}
#endif
