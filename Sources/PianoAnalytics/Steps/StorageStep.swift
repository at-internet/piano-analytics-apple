//
//  StorageStep.swift
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

final class StorageStep: Step {

    // MARK: Constructors

    static let shared: StorageStep = StorageStep()

    private final let storageDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    private init() {
    }

    // MARK: Constants

    private static let OfflineDataFilenamePrefix = "PianoAnalytics-Offline-File_"
    private static let UriField = "uri"
    private static let BodyField = "body"

    // MARK: Private methods

    private final func getDocumentsDirectory() -> URL? {
        #if os(tvOS)
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last else {
            return nil
        }
        #else
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            return nil
        }
        #endif
        return url
    }

    private final func storeData(_ builtDataJSONStr: String, encryptionMode: EncryptionMode) {

        guard let documentsDirectory = self.getDocumentsDirectory(),
              let encryptedData = Crypt.encrypt(data: builtDataJSONStr, encryptionMode: encryptionMode) else {
            return
        }

        do {
            try encryptedData.write(to: documentsDirectory.appendingPathComponent(String(format: "%@%@", StorageStep.OfflineDataFilenamePrefix, self.storageDateFormatter.string(from: Date()))), atomically: true, encoding: .utf8)
        } catch {
            print("PianoAnalytics: error on StorageStep.storeData: \(error)")
        }
    }

    private final func readData() -> [String: BuiltModel] {
        let fileManager = FileManager.default
        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var storedData = [String: BuiltModel]()

        do {
            let files = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
                .filter {
                    $0.lastPathComponent.starts(with: StorageStep.OfflineDataFilenamePrefix)
                }
                .sorted(by: {
                    $0.lastPathComponent < $1.lastPathComponent
                }
            )
            for f in files {
                let content = try String(contentsOf: f)
                if let data = Crypt.decrypt(data: content) {
                    if let map = PianoAnalyticsUtils.fromJSONData(Data(data.utf8)) {
                        storedData[f.absoluteString] = BuiltModel(
                            uri: map[StorageStep.UriField],
                            body: map[StorageStep.BodyField],
                            chunks: nil,
                            mustBeSaved: false
                        )
                    }
                }
            }
        } catch {
            print("PianoAnalytics: error on StorageStep.readData: \(error)")
        }

        return storedData
    }

    // MARK: Step Implementation

    func processDeleteOfflineData(m: inout Model) {
        var storageRemainingDate: Date
        if let storageDaysRemaining = m.storageDaysRemaining {
            var dc = DateComponents()
            dc.day = -storageDaysRemaining
            storageRemainingDate = Calendar.current.date(byAdding: dc, to: Date()) ?? Date()
        } else {
            storageRemainingDate = Date()
        }

        let stored = readData()
        for key in stored.keys {
            do {
                if let url = URL(string: key) {
                    if let endIndex = url.absoluteString.endIndex(of: StorageStep.OfflineDataFilenamePrefix) {
                        if let fileDate = storageDateFormatter.date(from: String(url.absoluteString[endIndex...])) {
                            if fileDate < storageRemainingDate {
                                try FileManager.default.removeItem(at: url)
                            }
                        } else {
                            try FileManager.default.removeItem(at: url)
                        }
                    }
                }
            } catch {
                print("PianoAnalytics: error on SendStep.processDeleteOfflineData: \(error)")
            }
        }
    }

    func processSendOfflineData(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        /// Retrieve stored data
        m.storage = self.readData()
        return true
    }

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        /// REQUIREMENTS
        let conf = m.configuration
        let encryptionMode = EncryptionMode.init(rawValue: conf.get(ConfigurationKey.OfflineEncryptionMode)) ?? EncryptionMode.IfCompatible

        if let builtModel = m.builtModel {
            if let chunks = builtModel.chunks {
                chunks.forEach { chunk in
                    guard let jsonData = PianoAnalyticsUtils.toJSONData([
                        StorageStep.UriField: builtModel.uri,
                        StorageStep.BodyField: chunk
                    ]) else {
                        return
                    }
                    self.storeData(String(decoding: jsonData, as: UTF8.self), encryptionMode: encryptionMode)
                }
            }
            
            if builtModel.mustBeSaved {
                return false
            }
        }

        /// Retrieve stored data
        m.storage = self.readData()
        return true
    }
}
