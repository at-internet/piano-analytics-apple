//
//  AVMedia.swift
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

public final class AVMedia {

    fileprivate let MinHeartbeatDuration: Int = 5
    fileprivate let MinBufferHeartbeatDuration: Int = 1

    fileprivate let avSynchronizer = DispatchQueue(label: "AVSynchronizer")

    fileprivate var heartbeatTimer: Timer?

    fileprivate var _sessionId: String = ""
    @objc public var sessionId: String {
        get {
            self.avSynchronizer.sync {
                return _sessionId
            }
        }
    }
    fileprivate var previousEvent: String = ""
    fileprivate var previousCursorPositionMillis: Int = 0
    fileprivate var currentCursorPositionMillis: Int = 0
    fileprivate var eventDurationMillis: Int = 0
    fileprivate var sessionDurationMillis: Int = 0
    fileprivate var startSessionTimeMillis: Int64 = 0
    fileprivate var bufferTimeMillis: Int64 = 0
    fileprivate var heartbeatDurations: [Int: Int] = [Int: Int]()
    fileprivate var bufferHeartbeatDurations: [Int: Int] = [Int: Int]()
    fileprivate var previousHeartbeatDelay: Int = 0
    fileprivate var previousBufferHeartbeatDelay: Int = 0

    fileprivate var isPlaying: Bool = false
    fileprivate var isPlaybackStartAlreadyCalled: Bool = false
    fileprivate var autoHeartbeat: Bool = false
    fileprivate var autoBufferHeartbeat: Bool = false
    fileprivate var pa: PianoAnalytics

    fileprivate var _playbackSpeed = 1.0
    @objc public var playbackSpeed: Double {
        get {
             return _playbackSpeed
        }
        set {
            guard newValue > 0 && newValue != _playbackSpeed else { return }

            stopHeartbeatTimer()

            if !isPlaying {
                _playbackSpeed = newValue
                return
            }

            heartbeat(cursorPosition: -1, extraProps: nil)

            if self.autoHeartbeat {
                self.previousHeartbeatDelay = updateHeartbeat(
                    previousDelay: self.previousHeartbeatDelay,
                    startTimerMillis: startSessionTimeMillis,
                    minHearbeatDuration: MinHeartbeatDuration,
                    heartbeatDurations: heartbeatDurations,
                    selector: #selector(self.processAutoHeartbeat)
                )
            }
            _playbackSpeed = newValue
        }
    }
    
    private var extraProperties: [String: Any]?

    public init(pa: PianoAnalytics, sessionId: String? = nil) {
        self.pa = pa
        if let optSessionId = sessionId, optSessionId != "" {
            self._sessionId = optSessionId
        } else {
            self._sessionId = Foundation.UUID().uuidString
        }
    }

    public func setHeartbeat(heartbeat: [Int: Int]?) -> AVMedia {
        guard heartbeat != nil && heartbeat!.count > 0 else { return self }
        self.avSynchronizer.sync {
            self.autoHeartbeat = true
            self.heartbeatDurations.removeAll()
            for (k, v) in heartbeat! {
                self.heartbeatDurations[k] =  max(v, MinHeartbeatDuration)
            }
            if !self.heartbeatDurations.keys.contains(0) {
               self.heartbeatDurations[0] = MinHeartbeatDuration
            }
        }
        return self
    }

    public func setBufferHeartbeat(bufferHeartbeat: [Int: Int]?) -> AVMedia {
        guard bufferHeartbeat != nil && bufferHeartbeat!.count > 0 else { return self }
        self.avSynchronizer.sync {
            self.autoBufferHeartbeat = true
            self.bufferHeartbeatDurations.removeAll()
            for (k, v) in bufferHeartbeat! {
                self.bufferHeartbeatDurations[k] = max(v, MinBufferHeartbeatDuration)
            }
            if !self.bufferHeartbeatDurations.keys.contains(0) {
               self.bufferHeartbeatDurations[0] = MinBufferHeartbeatDuration
            }
        }
        return self
    }
    
    public func setExtraProperties(_ props: [String: Any]?) {
        avSynchronizer.sync {
            self.extraProperties = props
        }
    }

    @objc public func track(event: String, options: [String: Any]?, extraProps: [String: Any]?) {
        switch event {
        case "av.heartbeat":
            var avPosition = -1
            if let optAvPosition = options?["av_position"] as? Int {
                avPosition = optAvPosition
            }
            heartbeat(cursorPosition: avPosition, extraProps: extraProps)
        case "av.buffer.heartbeat":
            bufferHeartbeat(extraProps: extraProps)
        case "av.rebuffer.heartbeat":
            rebufferHeartbeat(extraProps: extraProps)
        case "av.play":
            var avPosition = 0
            if let optAvPosition = options?["av_position"] as? Int {
                avPosition = optAvPosition
            }
            play(cursorPosition: avPosition, extraProps: extraProps)
        case "av.buffer.start":
            var avPosition = 0
            if let optAvPosition = options?["av_position"] as? Int {
                avPosition = optAvPosition
            }
            bufferStart(cursorPosition: avPosition, extraProps: extraProps)
        case "av.start":
            var avPosition = 0
            if let optAvPosition = options?["av_position"] as? Int {
                avPosition = optAvPosition
            }
            playbackStart(cursorPosition: avPosition, extraProps: extraProps)
        case "av.resume":
            var avPosition = 0
            if let optAvPosition = options?["av_position"] as? Int {
                avPosition = optAvPosition
            }
            playbackResumed(cursorPosition: avPosition, extraProps: extraProps)
        case "av.pause":
            var avPosition = 0
            if let optAvPosition = options?["av_position"] as? Int {
                avPosition = optAvPosition
            }
            playbackPaused(cursorPosition: avPosition, extraProps: extraProps)
        case "av.stop":
            var avPosition = 0
            if let optAvPosition = options?["av_position"] as? Int {
                avPosition = optAvPosition
            }
            playbackStopped(cursorPosition: avPosition, extraProps: extraProps)
        case "av.backward":
            var avPreviousPosition = 0
            var avPosition = 0
            if let optAvPreviousPosition = options?["av_previous_position"] as? Int {
                avPreviousPosition = optAvPreviousPosition
            }
            if let optAvPosition = options?["av_position"] as? Int {
                avPosition = optAvPosition
            }
            seekBackward(oldCursorPosition: avPreviousPosition, newCursorPosition: avPosition, extraProps: extraProps)
        case "av.forward":
            var avPreviousPosition = 0
            var avPosition = 0
            if let optAvPreviousPosition = options?["av_previous_position"] as? Int {
                avPreviousPosition = optAvPreviousPosition
            }
            if let optAvPosition = options?["av_position"] as? Int {
                avPosition = optAvPosition
            }
            seekForward(oldCursorPosition: avPreviousPosition, newCursorPosition: avPosition, extraProps: extraProps)
        case "av.seek.start":
            var avPreviousPosition = 0
            if let optAvPreviousPosition = options?["av_previous_position"] as? Int {
                avPreviousPosition = optAvPreviousPosition
            }
            seekStart(oldCursorPosition: avPreviousPosition, extraProps: extraProps)
        case "av.error":
            var avError = ""
            if let optAvError = options?["av_player_error"] as? String {
                avError = optAvError
            }
            error(message: avError, extraProps: extraProps)
        default:
            self.avSynchronizer.sync {
                self.pa.sendEvents([self.createEvent(name: event, withOptions: false, extraProps: extraProps)], config: nil)
            }
        }
    }

    @objc public func heartbeat(cursorPosition: Int, extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.updateDuration()

            self.previousCursorPositionMillis = self.currentCursorPositionMillis
            if cursorPosition >= 0 {
                self.currentCursorPositionMillis = cursorPosition
            } else {
                self.currentCursorPositionMillis += Int(Double(self.eventDurationMillis) * self._playbackSpeed)
            }

            self.pa.sendEvents([self.createEvent(name: "av.heartbeat", withOptions: true, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func bufferHeartbeat(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.updateDuration()

            self.pa.sendEvents([self.createEvent(name: "av.buffer.heartbeat", withOptions: true, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func rebufferHeartbeat(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.updateDuration()

            self.previousCursorPositionMillis = self.currentCursorPositionMillis

            self.pa.sendEvents([self.createEvent(name: "av.rebuffer.heartbeat", withOptions: true, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func play(cursorPosition: Int, extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.eventDurationMillis = 0

            let v = max(cursorPosition, 0)
            self.previousCursorPositionMillis = v
            self.currentCursorPositionMillis = v

            self.bufferTimeMillis = 0
            self.isPlaying = false
            self.isPlaybackStartAlreadyCalled = false

            stopHeartbeatTimer()

            self.pa.sendEvents([self.createEvent(name: "av.play", withOptions: true, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func bufferStart(cursorPosition: Int, extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.updateDuration()
            self.previousCursorPositionMillis = self.currentCursorPositionMillis
            self.currentCursorPositionMillis = max(cursorPosition, 0)

            stopHeartbeatTimer()

            if self.isPlaybackStartAlreadyCalled {
                if self.autoBufferHeartbeat {
                    self.bufferTimeMillis = self.bufferTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.bufferTimeMillis
                    self.previousBufferHeartbeatDelay = updateHeartbeat(
                        previousDelay: self.previousBufferHeartbeatDelay,
                        startTimerMillis: self.bufferTimeMillis,
                        minHearbeatDuration: MinBufferHeartbeatDuration,
                        heartbeatDurations: bufferHeartbeatDurations,
                        selector: #selector(self.processAutoBufferHeartbeat)
                    )
                }
                self.pa.sendEvents([self.createEvent(name: "av.rebuffer.start", withOptions: true, extraProps: extraProps)], config: nil)

            } else {
                if self.autoBufferHeartbeat {
                    self.bufferTimeMillis = self.bufferTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.bufferTimeMillis
                    self.previousBufferHeartbeatDelay = updateHeartbeat(
                        previousDelay: self.previousBufferHeartbeatDelay,
                        startTimerMillis: self.bufferTimeMillis,
                        minHearbeatDuration: MinBufferHeartbeatDuration,
                        heartbeatDurations: bufferHeartbeatDurations,
                        selector: #selector(self.processAutoBufferHeartbeat)
                    )
                }
                self.pa.sendEvents([self.createEvent(name: "av.buffer.start", withOptions: true, extraProps: extraProps)], config: nil)
            }
        }
    }

    @objc public func playbackStart(cursorPosition: Int, extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.updateDuration()

            let v = max(cursorPosition, 0)
            self.previousCursorPositionMillis = v
            self.currentCursorPositionMillis = v

            self.bufferTimeMillis = 0
            self.isPlaying = true
            self.isPlaybackStartAlreadyCalled = true

            stopHeartbeatTimer()
            if self.autoHeartbeat {
                self.previousHeartbeatDelay = updateHeartbeat(
                    previousDelay: self.previousHeartbeatDelay,
                    startTimerMillis: startSessionTimeMillis,
                    minHearbeatDuration: MinHeartbeatDuration,
                    heartbeatDurations: heartbeatDurations,
                    selector: #selector(self.processAutoHeartbeat)
                )
            }
            self.pa.sendEvents([self.createEvent(name: "av.start", withOptions: true, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func playbackResumed(cursorPosition: Int, extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.updateDuration()
            self.previousCursorPositionMillis = self.currentCursorPositionMillis
            self.currentCursorPositionMillis = max(cursorPosition, 0)
            self.bufferTimeMillis = 0

            self.isPlaying = true
            self.isPlaybackStartAlreadyCalled = true

            stopHeartbeatTimer()
            if self.autoHeartbeat {
                self.previousHeartbeatDelay = updateHeartbeat(
                    previousDelay: self.previousHeartbeatDelay,
                    startTimerMillis: startSessionTimeMillis,
                    minHearbeatDuration: MinHeartbeatDuration,
                    heartbeatDurations: heartbeatDurations,
                    selector: #selector(self.processAutoHeartbeat)
                )
            }
            self.pa.sendEvents([self.createEvent(name: "av.resume", withOptions: true, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func playbackPaused(cursorPosition: Int, extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.updateDuration()
            self.previousCursorPositionMillis = self.currentCursorPositionMillis
            self.currentCursorPositionMillis = max(cursorPosition, 0)

            self.bufferTimeMillis = 0
            self.isPlaying = false
            self.isPlaybackStartAlreadyCalled = true

            stopHeartbeatTimer()
            self.pa.sendEvents([self.createEvent(name: "av.pause", withOptions: true, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func playbackStopped(cursorPosition: Int, extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.updateDuration()
            self.previousCursorPositionMillis = self.currentCursorPositionMillis
            self.currentCursorPositionMillis = max(cursorPosition, 0)

            self.isPlaying = false

            stopHeartbeatTimer()
            self.startSessionTimeMillis = 0
            self.sessionDurationMillis = 0
            self.bufferTimeMillis = 0
            self.previousHeartbeatDelay = 0
            self.previousBufferHeartbeatDelay = 0

            self.pa.sendEvents([self.createEvent(name: "av.stop", withOptions: true, extraProps: extraProps)], config: nil)

            self.resetState()
        }
    }

    @objc public func seek(oldCursorPosition: Int, newCursorPosition: Int, extraProps: [String: Any]?) {
        if oldCursorPosition > newCursorPosition {
            self.seekBackward(oldCursorPosition: oldCursorPosition, newCursorPosition: newCursorPosition, extraProps: extraProps)
        } else {
            self.seekForward(oldCursorPosition: oldCursorPosition, newCursorPosition: newCursorPosition, extraProps: extraProps)
        }
    }

    @objc public func seekBackward(oldCursorPosition: Int, newCursorPosition: Int, extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.processSeek(seekDirection: "backward", oldCursorPosition: oldCursorPosition, newCursorPosition: newCursorPosition, extraProps: extraProps)
        }
    }

    @objc public func seekForward(oldCursorPosition: Int, newCursorPosition: Int, extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.processSeek(seekDirection: "forward", oldCursorPosition: oldCursorPosition, newCursorPosition: newCursorPosition, extraProps: extraProps)
        }
    }

    @objc public func seekStart(oldCursorPosition: Int, extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createSeekStart(oldCursorPosition: oldCursorPosition, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func adClick(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.ad.click", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func adSkip(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.ad.skip", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func error(message: String, extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            var optExtraProps: [String: Any]?
            if extraProps != nil {
                optExtraProps = extraProps
            } else {
                optExtraProps = [String: Any]()
            }
            optExtraProps?["av_player_error"] = message
            self.pa.sendEvents([self.createEvent(name: "av.error", withOptions: false, extraProps: optExtraProps)], config: nil)
        }
    }

    @objc public func display(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.display", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func close(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.close", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func volume(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.volume", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func subtitleOn(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.subtitle.on", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func subtitleOff(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.subtitle.off", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func fullscreenOn(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.fullscreen.on", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func fullscreenOff(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.fullscreen.off", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func quality(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.quality", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func speed(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.speed", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc public func share(extraProps: [String: Any]?) {
        self.avSynchronizer.sync {
            self.pa.sendEvents([self.createEvent(name: "av.share", withOptions: false, extraProps: extraProps)], config: nil)
        }
    }

    @objc func processAutoHeartbeat() {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.updateDuration()

            self.previousCursorPositionMillis = self.currentCursorPositionMillis
            self.currentCursorPositionMillis += Int(Double(self.eventDurationMillis) * self._playbackSpeed)

            self.previousHeartbeatDelay = updateHeartbeat(
                previousDelay: self.previousHeartbeatDelay,
                startTimerMillis: startSessionTimeMillis,
                minHearbeatDuration: MinHeartbeatDuration,
                heartbeatDurations: heartbeatDurations,
                selector: #selector(self.processAutoHeartbeat)
            )
            self.pa.sendEvents([self.createEvent(name: "av.heartbeat", withOptions: true, extraProps: extraProperties)], config: nil)
        }
    }

    @objc func processAutoBufferHeartbeat() {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.updateDuration()

            self.bufferTimeMillis = self.bufferTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.bufferTimeMillis
            self.previousBufferHeartbeatDelay = updateHeartbeat(
                previousDelay: self.previousBufferHeartbeatDelay,
                startTimerMillis: self.bufferTimeMillis,
                minHearbeatDuration: MinBufferHeartbeatDuration,
                heartbeatDurations: bufferHeartbeatDurations,
                selector: #selector(self.processAutoBufferHeartbeat)
            )
            self.pa.sendEvents([self.createEvent(name: "av.buffer.heartbeat", withOptions: true, extraProps: extraProperties)], config: nil)
        }
    }

    @objc func processAutoRebufferHeartbeat() {
        self.avSynchronizer.sync {
            self.startSessionTimeMillis = self.startSessionTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.startSessionTimeMillis

            self.updateDuration()

            self.previousCursorPositionMillis = self.currentCursorPositionMillis

            self.bufferTimeMillis = self.bufferTimeMillis == 0 ? Int64(Date().timeIntervalSince1970 * 1000) : self.bufferTimeMillis
            let diffMin = Int((Int64(Date().timeIntervalSince1970 * 1000) - self.bufferTimeMillis) / 60000)
            self.previousBufferHeartbeatDelay = updateHeartbeat(
                previousDelay: self.previousBufferHeartbeatDelay,
                startTimerMillis: self.bufferTimeMillis,
                minHearbeatDuration: MinBufferHeartbeatDuration,
                heartbeatDurations: bufferHeartbeatDurations,
                selector: #selector(self.processAutoRebufferHeartbeat)
            )
            self.pa.sendEvents([self.createEvent(name: "av.rebuffer.heartbeat", withOptions: true, extraProps: extraProperties)], config: nil)
        }
    }
    
    private func updateHeartbeat(previousDelay: Int, startTimerMillis: Int64, minHearbeatDuration: Int, heartbeatDurations: [Int:Int], selector: Selector) -> Int {
        let minutesDelay = Int((Int64(Date().timeIntervalSince1970 * 1000) - startTimerMillis) / 60000)
        let heartbeatDelay = max(heartbeatDurations[minutesDelay] ?? previousDelay, minHearbeatDuration)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.heartbeatTimer = Timer.scheduledTimer(timeInterval: TimeInterval(heartbeatDelay), target: self, selector: selector, userInfo: nil, repeats: false)
        }
        return heartbeatDelay
    }

    private func createSeekStart(oldCursorPosition: Int, extraProps: [String: Any]?) -> Event {
        self.previousCursorPositionMillis = self.currentCursorPositionMillis
        self.currentCursorPositionMillis = max(oldCursorPosition, 0)

        if self.isPlaying {
            self.updateDuration()
        } else {
            self.eventDurationMillis = 0
        }
        return self.createEvent(name: "av.seek.start", withOptions: true, extraProps: extraProps)
    }

    private func processSeek(seekDirection: String, oldCursorPosition: Int, newCursorPosition: Int, extraProps: [String: Any]?) {
        let seekStart = createSeekStart(oldCursorPosition: oldCursorPosition, extraProps: extraProps)

        self.eventDurationMillis = 0
        self.previousCursorPositionMillis = max(oldCursorPosition, 0)
        self.currentCursorPositionMillis = max(newCursorPosition, 0)

        self.pa.sendEvents([seekStart, self.createEvent(name: "av." + seekDirection, withOptions: true, extraProps: extraProps)], config: nil)
    }

    private func updateDuration() {
        self.eventDurationMillis = Int(Int64(Date().timeIntervalSince1970 * 1000) - self.startSessionTimeMillis) - self.sessionDurationMillis
        self.sessionDurationMillis += self.eventDurationMillis
    }

    private func stopHeartbeatTimer() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }

    private func resetState() {
        self._sessionId = Foundation.UUID().uuidString
        self.previousEvent = ""
        self.previousCursorPositionMillis = 0
        self.currentCursorPositionMillis = 0
        self.eventDurationMillis = 0
    }

    private func createEvent(name: String, withOptions: Bool, extraProps: [String: Any]?) -> Event {
        var props = [String: Any]()
        if withOptions {
            props["av_previous_position"] = self.previousCursorPositionMillis
            props["av_position"] = self.currentCursorPositionMillis
            props["av_duration"] = self.eventDurationMillis
            props["av_previous_event"] = self.previousEvent

            self.previousEvent = name
        }
        props["av_session_id"] = self._sessionId

        if let exp = extraProps {
            for (k, v) in exp {
                props[k] = v
            }
        }

        return Event(name, data: props)
    }
}
