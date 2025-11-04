//
//  InfoView.swift
//  AquaFinder
//
//  Created on 11/4/25.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Section
                    VStack(spacing: 10) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.6))
                        
                        Text("About AquaFinder")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.5))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                    
                    Divider()
                        .background(Color(red: 0.0, green: 0.5, blue: 0.7))
                    
                    // App Description
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What is AquaFinder?")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.5))
                        
                        Text("AquaFinder helps you locate the nearest water fountains quickly and easily. Stay hydrated wherever you go!")
                            .font(.body)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(Color(red: 0.0, green: 0.5, blue: 0.7))
                    
                    // Features Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Features")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.5))
                        
                        FeatureRow(icon: "map.fill", title: "Find Fountains", description: "Discover water fountains near your location")
                        FeatureRow(icon: "location.fill", title: "Real-time Navigation", description: "Get directions to the nearest fountain")
                        FeatureRow(icon: "star.fill", title: "Save Favorites", description: "Mark your favorite fountain locations")
                        FeatureRow(icon: "plus.circle.fill", title: "Add New Locations", description: "Help the community by adding fountains")
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(Color(red: 0.0, green: 0.5, blue: 0.7))
                    
                    // Version Info
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Version Information")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.5))
                        
                        HStack {
                            Text("Version:")
                                .fontWeight(.semibold)
                            Text("1.0.0")
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Build:")
                                .fontWeight(.semibold)
                            Text("2025.11.04")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(Color(red: 0.0, green: 0.5, blue: 0.7))
                    
                    // Contact Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Contact & Support")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.5))
                        
                        Text("For questions, feedback, or support, please reach out to our team.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                }
                .padding()
            }
            .navigationTitle("Info")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(red: 0.9, green: 0.95, blue: 0.98))
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.6))
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.5))
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
