//
//  Fountain.swift
//  AquaFinder
//
//  Model representing a water fountain location
//

import Foundation
import CoreLocation

struct Fountain: Identifiable, Codable {
    let id: UUID
    var name: String
    var location: Location
    var type: FountainType
    var accessibility: AccessibilityFeatures
    var rating: Double
    var ratingCount: Int
    var status: FountainStatus
    var imageURLs: [String]
    var addedBy: String
    var dateAdded: Date
    var lastVerified: Date?
    var amenities: [Amenity]
    
    init(id: UUID = UUID(),
         name: String,
         location: Location,
         type: FountainType = .standard,
         accessibility: AccessibilityFeatures = AccessibilityFeatures(),
         rating: Double = 0.0,
         ratingCount: Int = 0,
         status: FountainStatus = .active,
         imageURLs: [String] = [],
         addedBy: String,
         dateAdded: Date = Date(),
         lastVerified: Date? = nil,
         amenities: [Amenity] = []) {
        self.id = id
        self.name = name
        self.location = location
        self.type = type
        self.accessibility = accessibility
        self.rating = rating
        self.ratingCount = ratingCount
        self.status = status
        self.imageURLs = imageURLs
        self.addedBy = addedBy
        self.dateAdded = dateAdded
        self.lastVerified = lastVerified
        self.amenities = amenities
    }
}

// MARK: - Location
struct Location: Codable {
    let latitude: Double
    let longitude: Double
    var address: String?
    var building: String?
    var floor: String?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double, address: String? = nil, building: String? = nil, floor: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.building = building
        self.floor = floor
    }
}

// MARK: - FountainType
enum FountainType: String, Codable, CaseIterable {
    case standard = "Standard"
    case bottleFiller = "Bottle Filler"
    case combined = "Combined"
    case petFriendly = "Pet Friendly"
    case filtered = "Filtered"
    
    var icon: String {
        switch self {
        case .standard:
            return "drop.fill"
        case .bottleFiller:
            return "waterbottle.fill"
        case .combined:
            return "drop.triangle.fill"
        case .petFriendly:
            return "pawprint.fill"
        case .filtered:
            return "aqi.medium"
        }
    }
}

// MARK: - AccessibilityFeatures
struct AccessibilityFeatures: Codable {
    var wheelchairAccessible: Bool
    var lowHeight: Bool
    var highHeight: Bool
    
    init(wheelchairAccessible: Bool = false, lowHeight: Bool = false, highHeight: Bool = false) {
        self.wheelchairAccessible = wheelchairAccessible
        self.lowHeight = lowHeight
        self.highHeight = highHeight
    }
}

// MARK: - FountainStatus
enum FountainStatus: String, Codable {
    case active = "Active"
    case outOfOrder = "Out of Order"
    case removed = "Removed"
    case underMaintenance = "Under Maintenance"
    
    var color: String {
        switch self {
        case .active:
            return "green"
        case .outOfOrder:
            return "red"
        case .removed:
            return "gray"
        case .underMaintenance:
            return "orange"
        }
    }
}

// MARK: - Amenity
enum Amenity: String, Codable, CaseIterable {
    case cold = "Cold Water"
    case hot = "Hot Water"
    case sparkling = "Sparkling Water"
    case indoor = "Indoor"
    case outdoor = "Outdoor"
    case twentyFourSeven = "24/7 Access"
    case secure = "Secure Location"
    
    var icon: String {
        switch self {
        case .cold:
            return "snowflake"
        case .hot:
            return "flame.fill"
        case .sparkling:
            return "sparkles"
        case .indoor:
            return "house.fill"
        case .outdoor:
            return "sun.max.fill"
        case .twentyFourSeven:
            return "clock.fill"
        case .secure:
            return "lock.fill"
        }
    }
}

// MARK: - Fountain Extensions
extension Fountain {
    func distance(from userLocation: CLLocation) -> Double {
        let fountainLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        return userLocation.distance(from: fountainLocation)
    }
    
    func formattedDistance(from userLocation: CLLocation) -> String {
        let distanceInMeters = distance(from: userLocation)
        
        if distanceInMeters < 1000 {
            return String(format: "%.0f m", distanceInMeters)
        } else {
            let distanceInKm = distanceInMeters / 1000
            return String(format: "%.1f km", distanceInKm)
        }
    }
    
    var isVerified: Bool {
        guard let lastVerified = lastVerified else { return false }
        let daysSinceVerification = Calendar.current.dateComponents([.day], from: lastVerified, to: Date()).day ?? 0
        return daysSinceVerification <= 30
    }
    
    var formattedRating: String {
        return String(format: "%.1f", rating)
    }
}

// MARK: - Sample Data
extension Fountain {
    static var sampleData: [Fountain] = [
        Fountain(
            name: "Main Library Fountain",
            location: Location(latitude: 40.7128, longitude: -74.0060, address: "123 Library St", building: "Main Library", floor: "1st Floor"),
            type: .combined,
            accessibility: AccessibilityFeatures(wheelchairAccessible: true, lowHeight: true, highHeight: true),
            rating: 4.5,
            ratingCount: 124,
            status: .active,
            addedBy: "user123",
            amenities: [.cold, .indoor, .twentyFourSeven]
        ),
        Fountain(
            name: "Campus Center Bottle Filler",
            location: Location(latitude: 40.7138, longitude: -74.0070, address: "456 Campus Dr", building: "Student Center", floor: "Ground Floor"),
            type: .bottleFiller,
            accessibility: AccessibilityFeatures(wheelchairAccessible: true, lowHeight: false, highHeight: true),
            rating: 4.8,
            ratingCount: 89,
            status: .active,
            addedBy: "user456",
            amenities: [.cold, .filtered, .indoor]
        ),
        Fountain(
            name: "Park Outdoor Fountain",
            location: Location(latitude: 40.7118, longitude: -74.0050, address: "789 Park Ave"),
            type: .petFriendly,
            accessibility: AccessibilityFeatures(wheelchairAccessible: true, lowHeight: true, highHeight: false),
            rating: 3.9,
            ratingCount: 45,
            status: .active,
            addedBy: "user789",
            amenities: [.outdoor, .twentyFourSeven]
        )
    ]
}
