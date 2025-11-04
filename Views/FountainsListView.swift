//
//  FountainsListView.swift
//  AquaFinder
//
//  Created on 11/04/2025.
//

import SwiftUI

struct FountainsListView: View {
    @State private var searchText = ""
    @State private var fountains: [Fountain] = [
        Fountain(name: "Central Park Fountain", distance: "0.3 mi", address: "123 Park Ave", isWorking: true),
        Fountain(name: "City Hall Water Station", distance: "0.5 mi", address: "456 Main St", isWorking: true),
        Fountain(name: "Beach Pier Fountain", distance: "0.8 mi", address: "789 Ocean Blvd", isWorking: false),
        Fountain(name: "Library Square Fountain", distance: "1.2 mi", address: "321 Book Ln", isWorking: true),
        Fountain(name: "Marina Bay Fountain", distance: "1.5 mi", address: "654 Harbor Way", isWorking: true)
    ]
    
    var filteredFountains: [Fountain] {
        if searchText.isEmpty {
            return fountains
        } else {
            return fountains.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Deep sea blue background
                Color(red: 0.03, green: 0.15, blue: 0.25)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.6))
                        
                        TextField("Search fountains...", text: $searchText)
                            .foregroundColor(.white)
                            .placeholder(when: searchText.isEmpty) {
                                Text("Search fountains...")
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.6))
                            }
                        }
                    }
                    .padding()
                    .background(Color(red: 0.05, green: 0.2, blue: 0.3))
                    .cornerRadius(10)
                    .padding()
                    
                    // Fountains list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredFountains) { fountain in
                                FountainRowView(fountain: fountain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Nearby Fountains")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color(red: 0.03, green: 0.15, blue: 0.25), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct FountainRowView: View {
    let fountain: Fountain
    
    var body: some View {
        HStack(spacing: 15) {
            // Icon
            ZStack {
                Circle()
                    .fill(fountain.isWorking ? Color(red: 0.1, green: 0.4, blue: 0.6) : Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: fountain.isWorking ? "drop.fill" : "drop.triangle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
            }
            
            // Fountain details
            VStack(alignment: .leading, spacing: 6) {
                Text(fountain.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "location.fill")
                        .font(.caption)
                    Text(fountain.address)
                        .font(.subheadline)
                }
                .foregroundColor(.white.opacity(0.7))
                
                HStack {
                    Image(systemName: "figure.walk")
                        .font(.caption)
                    Text(fountain.distance)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    // Status indicator
                    HStack(spacing: 4) {
                        Circle()
                            .fill(fountain.isWorking ? Color.green : Color.red)
                            .frame(width: 8, height: 8)
                        Text(fountain.isWorking ? "Working" : "Not Working")
                            .font(.caption)
                            .foregroundColor(fountain.isWorking ? .green : .red)
                    }
                }
                .foregroundColor(.white.opacity(0.7))
            }
            
            Spacer()
            
            // Navigation arrow
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.4))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(red: 0.05, green: 0.2, blue: 0.3))
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
        )
    }
}

struct Fountain: Identifiable {
    let id = UUID()
    let name: String
    let distance: String
    let address: String
    let isWorking: Bool
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

struct FountainsListView_Previews: PreviewProvider {
    static var previews: some View {
        FountainsListView()
    }
}
