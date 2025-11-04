import Foundation
import CoreLocation

/// API client for fetching drinking fountain data from OpenStreetMap via Overpass API
class OverpassFountainsAPI {
    
    private let overpassURL = "https://overpass-api.de/api/interpreter"
    
    /// Fetch fountains within a given radius of a location
    /// - Parameters:
    ///   - coordinate: Center coordinate to search around
    ///   - radiusInMeters: Search radius in meters (default: 5000m = 5km)
    ///   - completion: Completion handler with array of fountains or error
    func fetchFountains(near coordinate: CLLocationCoordinate2D, radiusInMeters: Double = 5000, completion: @escaping (Result<[Fountain], Error>) -> Void) {
        
        let query = buildOverpassQuery(coordinate: coordinate, radius: radiusInMeters)
        
        var request = URLRequest(url: URL(string: overpassURL)!)
        request.httpMethod = "POST"
        request.httpBody = query.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "OverpassAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let fountains = try self.parseOverpassResponse(data)
                completion(.success(fountains))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Build Overpass QL query for drinking fountains
    private func buildOverpassQuery(coordinate: CLLocationCoordinate2D, radius: Double) -> String {
        let lat = coordinate.latitude
        let lon = coordinate.longitude
        
        // Query for nodes and ways tagged as drinking water fountains
        let query = """
        [out:json][timeout:25];
        (
          node["amenity"="drinking_water"](around:\(radius),\(lat),\(lon));
          node["amenity"="water_point"](around:\(radius),\(lat),\(lon));
          node["drinking_water"="yes"](around:\(radius),\(lat),\(lon));
        );
        out body;
        """
        
        return query
    }
    
    /// Parse Overpass API JSON response into Fountain objects
    private func parseOverpassResponse(_ data: Data) throws -> [Fountain] {
        let decoder = JSONDecoder()
        let response = try decoder.decode(OverpassResponse.self, from: data)
        
        return response.elements.compactMap { element in
            guard let lat = element.lat, let lon = element.lon else {
                return nil
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let name = element.tags?.name ?? "Drinking Fountain"
            let description = element.tags?.description ?? extractDescription(from: element.tags)
            let isOperational = element.tags?.operational != "no"
            
            return Fountain(
                id: String(element.id),
                name: name,
                coordinate: coordinate,
                description: description,
                isOperational: isOperational
            )
        }
    }
    
    /// Extract a meaningful description from available tags
    private func extractDescription(from tags: OverpassTags?) -> String {
        guard let tags = tags else { return "Public drinking water" }
        
        var components: [String] = []
        
        if let access = tags.access, access != "yes" {
            components.append("Access: \(access)")
        }
        
        if let bottle = tags.bottle {
            if bottle == "yes" {
                components.append("Bottle refill available")
            }
        }
        
        if let wheelchair = tags.wheelchair {
            if wheelchair == "yes" {
                components.append("Wheelchair accessible")
            }
        }
        
        return components.isEmpty ? "Public drinking water" : components.joined(separator: " • ")
    }
}

// MARK: - Overpass Response Models

private struct OverpassResponse: Codable {
    let elements: [OverpassElement]
}

private struct OverpassElement: Codable {
    let id: Int
    let lat: Double?
    let lon: Double?
    let tags: OverpassTags?
}

private struct OverpassTags: Codable {
    let name: String?
    let description: String?
    let operational: String?
    let access: String?
    let bottle: String?
    let wheelchair: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case operational
        case access
        case bottle
        case wheelchair
    }
}
