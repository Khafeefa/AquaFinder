//
//  ListViewModel.swift
//  AquaFinder
//
//  Created on 04/11/2025.
//

import Foundation
import SwiftUI
import CoreLocation

class ListViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var filteredLocations: [Location] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: LocationCategory = .all
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var sortOption: SortOption = .distance
    @Published var userLocation: CLLocationCoordinate2D?
    
    private let locationManager = LocationManager.shared
    private let dataService = DataService.shared
    
    init() {
        setupLocationManager()
        loadLocations()
    }
    
    // MARK: - Setup
    
    private func setupLocationManager() {
        locationManager.requestLocationPermission()
        locationManager.onLocationUpdate = { [weak self] location in
            self?.userLocation = location.coordinate
            self?.updateDistances()
            self?.sortLocations()
        }
    }
    
    // MARK: - Data Loading
    
    func loadLocations() {
        isLoading = true
        errorMessage = nil
        
        dataService.fetchLocations { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let locations):
                    self?.locations = locations
                    self?.updateDistances()
                    self?.filterLocations()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func refreshLocations() {
        loadLocations()
    }
    
    // MARK: - Filtering
    
    func filterLocations() {
        var filtered = locations
        
        // Filter by category
        if selectedCategory != .all {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.address.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        filteredLocations = filtered
        sortLocations()
    }
    
    func updateSearchText(_ text: String) {
        searchText = text
        filterLocations()
    }
    
    func updateCategory(_ category: LocationCategory) {
        selectedCategory = category
        filterLocations()
    }
    
    // MARK: - Sorting
    
    func updateSortOption(_ option: SortOption) {
        sortOption = option
        sortLocations()
    }
    
    private func sortLocations() {
        switch sortOption {
        case .distance:
            filteredLocations.sort { location1, location2 in
                guard let distance1 = location1.distance,
                      let distance2 = location2.distance else {
                    return false
                }
                return distance1 < distance2
            }
        case .name:
            filteredLocations.sort { $0.name < $1.name }
        case .rating:
            filteredLocations.sort { $0.rating > $1.rating }
        case .newest:
            filteredLocations.sort { $0.createdDate > $1.createdDate }
        }
    }
    
    // MARK: - Distance Calculation
    
    private func updateDistances() {
        guard let userLocation = userLocation else { return }
        
        let userCLLocation = CLLocation(latitude: userLocation.latitude,
                                       longitude: userLocation.longitude)
        
        for index in locations.indices {
            let locationCoordinate = locations[index].coordinate
            let locationCLLocation = CLLocation(latitude: locationCoordinate.latitude,
                                               longitude: locationCoordinate.longitude)
            let distance = userCLLocation.distance(from: locationCLLocation)
            locations[index].distance = distance
        }
        
        filterLocations()
    }
    
    // MARK: - Location Management
    
    func addLocation(_ location: Location) {
        locations.append(location)
        dataService.saveLocation(location) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.filterLocations()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteLocation(_ location: Location) {
        locations.removeAll { $0.id == location.id }
        dataService.deleteLocation(location) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.filterLocations()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func updateLocation(_ location: Location) {
        if let index = locations.firstIndex(where: { $0.id == location.id }) {
            locations[index] = location
            dataService.updateLocation(location) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.filterLocations()
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func toggleFavorite(for location: Location) {
        if let index = locations.firstIndex(where: { $0.id == location.id }) {
            locations[index].isFavorite.toggle()
            dataService.updateLocation(locations[index]) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.filterLocations()
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func getLocationsByCategory(_ category: LocationCategory) -> [Location] {
        return locations.filter { $0.category == category }
    }
    
    func getFavoriteLocations() -> [Location] {
        return locations.filter { $0.isFavorite }
    }
    
    func getNearbyLocations(within meters: Double) -> [Location] {
        return locations.filter {
            guard let distance = $0.distance else { return false }
            return distance <= meters
        }
    }
    
    func clearFilters() {
        searchText = ""
        selectedCategory = .all
        filterLocations()
    }
    
    func dismissError() {
        errorMessage = nil
    }
}

// MARK: - Supporting Enums

enum SortOption: String, CaseIterable {
    case distance = "Distance"
    case name = "Name"
    case rating = "Rating"
    case newest = "Newest"
}

enum LocationCategory: String, CaseIterable {
    case all = "All"
    case drinkingFountain = "Drinking Fountain"
    case waterStation = "Water Station"
    case refillStation = "Refill Station"
    case publicFacility = "Public Facility"
    case restaurant = "Restaurant"
    case store = "Store"
    
    var icon: String {
        switch self {
        case .all:
            return "line.3.horizontal.decrease.circle"
        case .drinkingFountain:
            return "drop.fill"
        case .waterStation:
            return "waterbottle.fill"
        case .refillStation:
            return "arrow.clockwise"
        case .publicFacility:
            return "building.2.fill"
        case .restaurant:
            return "fork.knife"
        case .store:
            return "cart.fill"
        }
    }
}
