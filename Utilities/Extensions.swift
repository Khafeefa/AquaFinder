//
//  Extensions.swift
//  AquaFinder
//
//  Utility extensions for coordinate distance calculations and formatted distance strings
//

import Foundation
import CoreLocation

// MARK: - CLLocationCoordinate2D Extensions

extension CLLocationCoordinate2D {
    /// Calculate the distance in meters between two coordinates using the Haversine formula
    /// - Parameter coordinate: The destination coordinate
    /// - Returns: Distance in meters
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        return location1.distance(from: location2)
    }
}

// MARK: - CLLocationDistance Extensions

extension CLLocationDistance {
    /// Format the distance as a human-readable string
    /// - Returns: Formatted string (e.g., "1.2 km" or "350 m")
    func formattedDistance() -> String {
        if self >= 1000 {
            let kilometers = self / 1000
            return String(format: "%.1f km", kilometers)
        } else {
            return String(format: "%.0f m", self)
        }
    }
}

// MARK: - Double Extensions

extension Double {
    /// Format a distance value (in meters) as a human-readable string
    /// - Returns: Formatted string (e.g., "1.2 km" or "350 m")
    func formattedDistance() -> String {
        if self >= 1000 {
            let kilometers = self / 1000
            return String(format: "%.1f km", kilometers)
        } else {
            return String(format: "%.0f m", self)
        }
    }
}
