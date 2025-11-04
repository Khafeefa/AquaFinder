//
//  MapViewModel.swift
//  AquaFinder
//
//  Created on 11/4/25.
//

import SwiftUI
import MapKit
import CoreLocation

class MapViewModel: NSObject, ObservableObject {
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @Published var waterFountains: [WaterFountain] = []
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var showingAddFountain = false
    @Published var selectedFountain: WaterFountain?
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        loadFountains()
    }
    
    func loadFountains() {
        // Load fountains from UserDefaults or API
        if let data = UserDefaults.standard.data(forKey: "waterFountains"),
           let decoded = try? JSONDecoder().decode([WaterFountain].self, from: data) {
            waterFountains = decoded
        } else {
            // Sample data for testing
            waterFountains = [
                WaterFountain(
                    id: UUID(),
                    name: "Golden Gate Park Fountain",
                    coordinate: CLLocationCoordinate2D(latitude: 37.7694, longitude: -122.4862),
                    type: .publicPark,
                    rating: 4.5,
                    reviewCount: 12
                ),
                WaterFountain(
                    id: UUID(),
                    name: "Union Square Fountain",
                    coordinate: CLLocationCoordinate2D(latitude: 37.7879, longitude: -122.4075),
                    type: .publicSquare,
                    rating: 4.0,
                    reviewCount: 8
                )
            ]
        }
    }
    
    func saveFountains() {
        if let encoded = try? JSONEncoder().encode(waterFountains) {
            UserDefaults.standard.set(encoded, forKey: "waterFountains")
        }
    }
    
    func addFountain(_ fountain: WaterFountain) {
        waterFountains.append(fountain)
        saveFountains()
    }
    
    func deleteFountain(_ fountain: WaterFountain) {
        waterFountains.removeAll { $0.id == fountain.id }
        saveFountains()
    }
    
    func centerOnUser() {
        if let location = userLocation {
            region = MKCoordinateRegion(
                center: location,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }
    
    func findNearestFountain() -> WaterFountain? {
        guard let userLocation = userLocation else { return nil }
        
        return waterFountains.min(by: { fountain1, fountain2 in
            let distance1 = distance(from: userLocation, to: fountain1.coordinate)
            let distance2 = distance(from: userLocation, to: fountain2.coordinate)
            return distance1 < distance2
        })
    }
    
    private func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
    }
}

extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        userLocation = location.coordinate
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}
