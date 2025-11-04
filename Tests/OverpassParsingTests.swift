import XCTest
@testable import AquaFinder

class OverpassParsingTests: XCTestCase {
    
    // MARK: - Test Parsing Valid Fountain Data
    
    func testParseValidFountainResponse() {
        // Given: A valid Overpass API response with fountain data
        let json = """
        {
            "elements": [
                {
                    "type": "node",
                    "id": 123456789,
                    "lat": 40.7128,
                    "lon": -74.0060,
                    "tags": {
                        "amenity": "drinking_water",
                        "name": "Central Park Fountain"
                    }
                }
            ]
        }
        """
        
        let data = json.data(using: .utf8)!
        
        // When: Parsing the JSON response
        let decoder = JSONDecoder()
        let response = try? decoder.decode(OverpassResponse.self, from: data)
        
        // Then: The response should be parsed correctly
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.elements.count, 1)
        XCTAssertEqual(response?.elements.first?.id, 123456789)
        XCTAssertEqual(response?.elements.first?.lat, 40.7128)
        XCTAssertEqual(response?.elements.first?.lon, -74.0060)
        XCTAssertEqual(response?.elements.first?.tags?["amenity"], "drinking_water")
        XCTAssertEqual(response?.elements.first?.tags?["name"], "Central Park Fountain")
    }
    
    func testConvertOverpassElementToFountain() {
        // Given: A valid Overpass element
        let element = OverpassElement(
            type: "node",
            id: 987654321,
            lat: 34.0522,
            lon: -118.2437,
            tags: [
                "amenity": "drinking_water",
                "name": "Venice Beach Fountain",
                "wheelchair": "yes"
            ]
        )
        
        // When: Converting to Fountain model
        let fountain = Fountain(from: element)
        
        // Then: Fountain should be created with correct properties
        XCTAssertEqual(fountain.id, "987654321")
        XCTAssertEqual(fountain.latitude, 34.0522)
        XCTAssertEqual(fountain.longitude, -118.2437)
        XCTAssertEqual(fountain.name, "Venice Beach Fountain")
        XCTAssertTrue(fountain.isAccessible)
    }
    
    // MARK: - Test Empty and Invalid Responses
    
    func testParseEmptyResponse() {
        // Given: An empty Overpass API response
        let json = """
        {
            "elements": []
        }
        """
        
        let data = json.data(using: .utf8)!
        
        // When: Parsing the JSON response
        let decoder = JSONDecoder()
        let response = try? decoder.decode(OverpassResponse.self, from: data)
        
        // Then: Response should be valid but contain no elements
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.elements.count, 0)
    }
    
    func testParseInvalidJSON() {
        // Given: Invalid JSON data
        let invalidJSON = "{ invalid json }"
        let data = invalidJSON.data(using: .utf8)!
        
        // When: Attempting to parse
        let decoder = JSONDecoder()
        let response = try? decoder.decode(OverpassResponse.self, from: data)
        
        // Then: Parsing should fail
        XCTAssertNil(response)
    }
    
    // MARK: - Test Multiple Fountains
    
    func testParseMultipleFountains() {
        // Given: Overpass response with multiple fountains
        let json = """
        {
            "elements": [
                {
                    "type": "node",
                    "id": 111,
                    "lat": 40.7128,
                    "lon": -74.0060,
                    "tags": {
                        "amenity": "drinking_water",
                        "name": "Fountain 1"
                    }
                },
                {
                    "type": "node",
                    "id": 222,
                    "lat": 34.0522,
                    "lon": -118.2437,
                    "tags": {
                        "amenity": "drinking_water",
                        "name": "Fountain 2"
                    }
                },
                {
                    "type": "node",
                    "id": 333,
                    "lat": 41.8781,
                    "lon": -87.6298,
                    "tags": {
                        "amenity": "drinking_water"
                    }
                }
            ]
        }
        """
        
        let data = json.data(using: .utf8)!
        
        // When: Parsing the response
        let decoder = JSONDecoder()
        let response = try? decoder.decode(OverpassResponse.self, from: data)
        
        // Then: All fountains should be parsed
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.elements.count, 3)
        XCTAssertEqual(response?.elements[0].id, 111)
        XCTAssertEqual(response?.elements[1].id, 222)
        XCTAssertEqual(response?.elements[2].id, 333)
    }
    
    // MARK: - Test Tag Parsing
    
    func testParseFountainWithOptionalTags() {
        // Given: Fountain with various optional tags
        let json = """
        {
            "elements": [
                {
                    "type": "node",
                    "id": 555,
                    "lat": 51.5074,
                    "lon": -0.1278,
                    "tags": {
                        "amenity": "drinking_water",
                        "name": "Hyde Park Fountain",
                        "wheelchair": "yes",
                        "bottle": "yes",
                        "operator": "Thames Water",
                        "description": "Historic fountain"
                    }
                }
            ]
        }
        """
        
        let data = json.data(using: .utf8)!
        
        // When: Parsing the response
        let decoder = JSONDecoder()
        let response = try? decoder.decode(OverpassResponse.self, from: data)
        
        // Then: All tags should be accessible
        XCTAssertNotNil(response)
        let element = response?.elements.first
        XCTAssertEqual(element?.tags?["name"], "Hyde Park Fountain")
        XCTAssertEqual(element?.tags?["wheelchair"], "yes")
        XCTAssertEqual(element?.tags?["bottle"], "yes")
        XCTAssertEqual(element?.tags?["operator"], "Thames Water")
        XCTAssertEqual(element?.tags?["description"], "Historic fountain")
    }
    
    func testParseFountainWithoutOptionalTags() {
        // Given: Minimal fountain data without optional tags
        let json = """
        {
            "elements": [
                {
                    "type": "node",
                    "id": 777,
                    "lat": 48.8566,
                    "lon": 2.3522,
                    "tags": {
                        "amenity": "drinking_water"
                    }
                }
            ]
        }
        """
        
        let data = json.data(using: .utf8)!
        
        // When: Parsing the response
        let decoder = JSONDecoder()
        let response = try? decoder.decode(OverpassResponse.self, from: data)
        
        // Then: Element should still parse successfully
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.elements.count, 1)
        let element = response?.elements.first
        XCTAssertNil(element?.tags?["name"])
        XCTAssertNil(element?.tags?["wheelchair"])
    }
    
    // MARK: - Test Coordinate Validation
    
    func testParseCoordinatesInRange() {
        // Given: Fountains with boundary coordinates
        let json = """
        {
            "elements": [
                {
                    "type": "node",
                    "id": 888,
                    "lat": 90.0,
                    "lon": 180.0,
                    "tags": {"amenity": "drinking_water"}
                },
                {
                    "type": "node",
                    "id": 999,
                    "lat": -90.0,
                    "lon": -180.0,
                    "tags": {"amenity": "drinking_water"}
                }
            ]
        }
        """
        
        let data = json.data(using: .utf8)!
        
        // When: Parsing coordinates
        let decoder = JSONDecoder()
        let response = try? decoder.decode(OverpassResponse.self, from: data)
        
        // Then: Coordinates should be parsed correctly
        XCTAssertNotNil(response)
        XCTAssertEqual(response?.elements[0].lat, 90.0)
        XCTAssertEqual(response?.elements[0].lon, 180.0)
        XCTAssertEqual(response?.elements[1].lat, -90.0)
        XCTAssertEqual(response?.elements[1].lon, -180.0)
    }
}

// MARK: - Supporting Models for Testing

struct OverpassResponse: Codable {
    let elements: [OverpassElement]
}

struct OverpassElement: Codable {
    let type: String
    let id: Int
    let lat: Double
    let lon: Double
    let tags: [String: String]?
}

extension Fountain {
    init(from element: OverpassElement) {
        self.id = String(element.id)
        self.latitude = element.lat
        self.longitude = element.lon
        self.name = element.tags?["name"] ?? "Unknown Fountain"
        self.isAccessible = element.tags?["wheelchair"] == "yes"
    }
}
