import Foundation

public extension PA {
    
    final class Err: LocalizedError, CustomStringConvertible, CustomDebugStringConvertible {
        
        public let message: String
        
        public var errorDescription: String? { message }
        public var description: String { message }
        public var debugDescription: String { message }
        
        init(message: String) {
            self.message = message
        }
    }
}
