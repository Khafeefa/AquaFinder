import Foundation

class LocalCacheFountainsAPI: FountainsAPI {
    private let cacheFileName = "fountains_cache.json"
    private let cacheExpirationInterval: TimeInterval = 24 * 60 * 60 // 24 hours
    
    private var cacheFileURL: URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(cacheFileName)
    }
    
    func getFountains(completion: @escaping ([Fountain]?, Error?) -> Void) {
        // Try to load from cache first
        if let cachedFountains = loadCachedFountains() {
            completion(cachedFountains, nil)
            return
        }
        
        // If no cache or cache expired, return empty array
        completion([], nil)
    }
    
    func saveFountains(_ fountains: [Fountain]) {
        guard let cacheURL = cacheFileURL else {
            print("Error: Could not get cache file URL")
            return
        }
        
        let cacheData = CacheData(fountains: fountains, timestamp: Date())
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(cacheData)
            try data.write(to: cacheURL, options: .atomic)
            print("Successfully saved \(fountains.count) fountains to cache")
        } catch {
            print("Error saving fountains to cache: \(error.localizedDescription)")
        }
    }
    
    private func loadCachedFountains() -> [Fountain]? {
        guard let cacheURL = cacheFileURL else {
            return nil
        }
        
        guard FileManager.default.fileExists(atPath: cacheURL.path) else {
            print("Cache file does not exist")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: cacheURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let cacheData = try decoder.decode(CacheData.self, from: data)
            
            // Check if cache is still valid
            let timeElapsed = Date().timeIntervalSince(cacheData.timestamp)
            if timeElapsed < cacheExpirationInterval {
                print("Loaded \(cacheData.fountains.count) fountains from cache")
                return cacheData.fountains
            } else {
                print("Cache expired")
                return nil
            }
        } catch {
            print("Error loading cached fountains: \(error.localizedDescription)")
            return nil
        }
    }
    
    func clearCache() {
        guard let cacheURL = cacheFileURL else {
            return
        }
        
        do {
            if FileManager.default.fileExists(atPath: cacheURL.path) {
                try FileManager.default.removeItem(at: cacheURL)
                print("Cache cleared successfully")
            }
        } catch {
            print("Error clearing cache: \(error.localizedDescription)")
        }
    }
    
    func isCacheValid() -> Bool {
        guard let cacheURL = cacheFileURL else {
            return false
        }
        
        guard FileManager.default.fileExists(atPath: cacheURL.path) else {
            return false
        }
        
        do {
            let data = try Data(contentsOf: cacheURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let cacheData = try decoder.decode(CacheData.self, from: data)
            
            let timeElapsed = Date().timeIntervalSince(cacheData.timestamp)
            return timeElapsed < cacheExpirationInterval
        } catch {
            return false
        }
    }
}

// MARK: - Cache Data Structure
private struct CacheData: Codable {
    let fountains: [Fountain]
    let timestamp: Date
}
