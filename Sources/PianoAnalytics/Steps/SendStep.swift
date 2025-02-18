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
    
    private lazy var sendStepWorkingQueue: DispatchQueue = {
        DispatchQueue(label: "PianoSendStepWorkingQueue")
    }()

    // MARK: Constructors
    
    private static var _instance: SendStep?
    static let shared: (PA.ExtendedConfiguration) -> SendStep = { ec in
        if _instance == nil {
            _instance = SendStep(ec: ec)
        }
        return _instance ?? SendStep(ec: ec)
    }
    
    private final let extendedConfiguration: PA.ExtendedConfiguration

    private init(ec: PA.ExtendedConfiguration) {
        extendedConfiguration = ec
    }

    // MARK: Constants

    private static let TimeoutMs = 10_000.0
    private static let MaxRetry = 3
    private static let SleepTime = UInt32(0.4)

    // MARK: Private methods

    private final func sendStoredData(_ stored: [String: BuiltModel], userAgent: String, intervalInMs: Double) {
        for (index, data) in stored.enumerated() {
            let delay = Double(index) * (intervalInMs / 1000)
            self.sendStoredChunk(data: data.value, userAgent: userAgent, key: data.key, delay: delay)
        }
    }

    private final func sendStoredChunk(data: BuiltModel, userAgent: String, key: String, delay: Double) {
        sendStepWorkingQueue.asyncAfter(deadline: .now() + delay) {
            self.send(data, userAgent: userAgent)
        }
        do {
            if let url = URL(string: key), FileManager.default.fileExists(atPath: key.replacingOccurrences(of: "file://", with: "")) {
                try FileManager.default.removeItem(at: url)
            }
        } catch {
            print("PianoAnalytics: error on SendStep.sendStoredData: \(error)")
        }
    }

    private final func send(_ builtModel: BuiltModel, userAgent: String) {
        guard let uri = builtModel.uri,
              let body = builtModel.body,
              var urlComponents = URLComponents(string: uri) else {
            return
        }
        
        if let query = extendedConfiguration.httpProvider?.query {
            urlComponents.queryItems = (urlComponents.queryItems ?? []) + query.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = urlComponents.url else {
            return
        }

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForResource = SendStep.TimeoutMs
        
        extendedConfiguration.configureURLSession?(sessionConfig)

        var request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: SendStep.TimeoutMs)
        if userAgent != "" {
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        request.httpMethod = "POST"
        request.httpBody = Data(body.utf8)
        
        extendedConfiguration.httpProvider?.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }

        var success = false
        var count = 0

        repeat {
            count += 1
            let session = extendedConfiguration.urlSession?() ?? URLSession(configuration: sessionConfig)
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
        return processSendOfflineData(m: &m, p: p)
    }
}
