//
//  SendStep.swift
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

final class SendStep: Step {

    // MARK: Constructors

    static let shared: SendStep = SendStep()

    private init() {
    }

    // MARK: Constants

    private static let TimeoutMs = 10_000.0
    private static let MaxRetry = 3
    private static let SleepTime = UInt32(0.4)

    // MARK: Private methods

    private final func sendStoredData(_ stored: [String: BuiltModel], userAgent: String, intervalInMs: Double) {
        for (index, data) in stored.enumerated() {
            let delay = Double(index) * (intervalInMs / 1000)
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.sendStoredChunk(data: data.value, userAgent: userAgent, key: data.key)
            }
        }
    }

    private final func sendStoredChunk(data: BuiltModel, userAgent: String, key: String) {
        self.send(data, userAgent: userAgent)
        do {
            if let url = URL(string: key) {
                try FileManager.default.removeItem(at: url)
            }
        } catch {
            print("PianoAnalytics: error on SendStep.sendStoredData: \(error)")
        }
    }

    private final func send(_ builtModel: BuiltModel, userAgent: String) {
        guard let uri = builtModel.uri,
              let body = builtModel.body,
              let url = URL(string: uri) else {
            return
        }

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForResource = SendStep.TimeoutMs

        var request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: SendStep.TimeoutMs)
        if userAgent != "" {
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        request.httpMethod = "POST"
        request.httpBody = Data(body.utf8)

        var success = false
        var count = 0

        repeat {
            count += 1
            let session = URLSession(configuration: sessionConfig)
            let semaphore = DispatchSemaphore(value: 0)

            session.dataTask(with: request) {_, response, _ in
                if let res = response as? HTTPURLResponse {
                    success = res.statusCode >= 200 && res.statusCode <= 399
                }
                session.finishTasksAndInvalidate()
                semaphore.signal()
            }.resume()

            _ = semaphore.wait(timeout: DispatchTime.distantFuture)

            if !success {
                sleep(SendStep.SleepTime)
            }
        } while !success && count < SendStep.MaxRetry
    }

    // MARK: Step Implementation

    func processSendOfflineData(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        /// REQUIREMENTS
        let conf = m.configuration
        let stored = m.storage

        let userAgent = conf.get(ConfigurationKey.CustomUserAgent)
        let offlineSendInterval = Double(conf.get(ConfigurationKey.OfflineSendInterval).toInt())
        self.sendStoredData(stored, userAgent: userAgent, intervalInMs: offlineSendInterval)

        return true
    }

    func processSendEvents(m: inout Model, p: PianoAnalyticsWorkProtocol?) -> Bool {
        /// REQUIREMENTS
        let conf = m.configuration
        let stored = m.storage

        guard let buildModel = m.builtModel else {
            return false
        }

        let userAgent = conf.get(ConfigurationKey.CustomUserAgent)
        let offlineSendInterval = Double(conf.get(ConfigurationKey.OfflineSendInterval).toInt())
        self.sendStoredData(stored, userAgent: userAgent, intervalInMs: offlineSendInterval)
        self.send(buildModel, userAgent: userAgent)

        return true
    }
}
