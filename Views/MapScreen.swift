//
//  MapScreen.swift
//  AquaFinder
//
//  Deep sea blue and white themed map screen
//

import SwiftUI
import MapKit

struct MapScreen: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var searchText = ""
    @State private var showingFilters = false
    
    // Deep sea blue color theme
    let deepSeaBlue = Color(red: 0.0, green: 0.25, blue: 0.4)
    let lightSeaBlue = Color(red: 0.2, green: 0.4, blue: 0.6)
    
    var body: some View {
        ZStack {
            // Map view
            Map(coordinateRegion: $region)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Top search bar
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white)
                            .padding(.leading, 12)
                        
                        TextField("Search water sources...", text: $searchText)
                            .foregroundColor(.white)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Search water sources...")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                searchText = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .padding(.trailing, 8)
                        }
                    }
                    .padding(.vertical, 12)
                    .background(deepSeaBlue)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    
                    // Filter button
                    Button(action: {
                        showingFilters.toggle()
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(deepSeaBlue)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 60)
                
                Spacer()
                
                // Bottom action buttons
                HStack(spacing: 16) {
                    // My Location button
                    Button(action: {
                        // Center map on user location
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.title3)
                            Text("My Location")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(deepSeaBlue)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                    
                    // Add Water Source button
                    Button(action: {
                        // Add new water source
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                            Text("Add Source")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(lightSeaBlue)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                    
                    // Water Quality button
                    Button(action: {
                        // Show water quality info
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "drop.fill")
                                .font(.title3)
                            Text("Quality")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        .background(deepSeaBlue)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
            
            // Filter panel
            if showingFilters {
                VStack {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Filters")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                showingFilters = false
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 12) {
                            FilterOption(icon: "drop.fill", title: "Drinking Water")
                            FilterOption(icon: "shower.fill", title: "Public Fountains")
                            FilterOption(icon: "building.2.fill", title: "Water Stations")
                            FilterOption(icon: "flag.fill", title: "Emergency Supplies")
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // Apply filters
                            showingFilters = false
                        }) {
                            Text("Apply Filters")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(lightSeaBlue)
                                .cornerRadius(12)
                        }
                    }
                    .padding(24)
                    .background(deepSeaBlue)
                    .cornerRadius(20)
                    .shadow(radius: 10)
                    .frame(maxWidth: 350)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.4))
                .onTapGesture {
                    showingFilters = false
                }
            }
        }
    }
}

struct FilterOption: View {
    let icon: String
    let title: String
    @State private var isSelected = false
    
    var body: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .frame(width: 24)
                
                Text(title)
                    .foregroundColor(.white)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            .padding()
            .background(Color.white.opacity(isSelected ? 0.2 : 0.1))
            .cornerRadius(10)
        }
    }
}

// TextField placeholder extension
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen()
    }
}
