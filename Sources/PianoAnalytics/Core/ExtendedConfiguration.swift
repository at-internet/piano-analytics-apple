import Foundation

extension PA {
    
    /// Extended configuration parameters
    public struct ExtendedConfiguration {
        
        /// Create custom URLSession
        public var urlSession: (() -> URLSession)? = nil
        
        /// Configure URL session
        public var configureURLSession: ((URLSessionConfiguration) -> Void)? = nil
        
        /// Configuration file location
        internal let configFileLocation: String
        
        public init(_ configFileLocation: String) {
            self.configFileLocation = configFileLocation
        }
        
        public init() {
            self.configFileLocation = Configuration.Location
        }
    }
}
