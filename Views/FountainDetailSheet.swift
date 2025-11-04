import SwiftUI
import MapKit

struct FountainDetailSheet: View {
    let fountain: Fountain
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text(fountain.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(fountain.address)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(red: 0.0, green: 0.3, blue: 0.5), Color(red: 0.0, green: 0.2, blue: 0.4)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
                    
                    // Map Preview
                    Map(coordinateRegion: .constant(
                        MKCoordinateRegion(
                            center: CLLocationCoordinate2D(
                                latitude: fountain.latitude,
                                longitude: fountain.longitude
                            ),
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    ), annotationItems: [fountain]) { location in
                        MapMarker(
                            coordinate: CLLocationCoordinate2D(
                                latitude: location.latitude,
                                longitude: location.longitude
                            ),
                            tint: Color(red: 0.0, green: 0.4, blue: 0.6)
                        )
                    }
                    .frame(height: 200)
                    .cornerRadius(12)
                    
                    // Details Section
                    VStack(alignment: .leading, spacing: 16) {
                        DetailRow(
                            icon: "drop.fill",
                            title: "Water Type",
                            value: fountain.waterType ?? "Drinking Water"
                        )
                        
                        DetailRow(
                            icon: "clock.fill",
                            title: "Availability",
                            value: fountain.availability ?? "24/7"
                        )
                        
                        DetailRow(
                            icon: "location.fill",
                            title: "Coordinates",
                            value: String(format: "%.4f, %.4f", fountain.latitude, fountain.longitude)
                        )
                        
                        if let notes = fountain.notes, !notes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Image(systemName: "note.text")
                                        .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.6))
                                    Text("Notes")
                                        .font(.headline)
                                        .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.5))
                                }
                                Text(notes)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                            .background(Color(red: 0.9, green: 0.95, blue: 1.0))
                            .cornerRadius(8)
                        }
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            openInMaps()
                        }) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("Open in Maps")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.0, green: 0.4, blue: 0.6))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            shareLocation()
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share Location")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 0.0, green: 0.4, blue: 0.6), lineWidth: 2)
                            )
                        }
                    }
                }
                .padding()
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.6))
                            .font(.title2)
                    }
                }
            }
        }
    }
    
    private func openInMaps() {
        let coordinate = CLLocationCoordinate2D(
            latitude: fountain.latitude,
            longitude: fountain.longitude
        )
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = fountain.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
    
    private func shareLocation() {
        let coordinate = CLLocationCoordinate2D(
            latitude: fountain.latitude,
            longitude: fountain.longitude
        )
        let shareText = "Check out this water fountain: \(fountain.name)\nLocation: \(fountain.address)\nCoordinates: \(coordinate.latitude), \(coordinate.longitude)"
        
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true)
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.0, green: 0.4, blue: 0.6))
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(red: 0.95, green: 0.97, blue: 1.0))
        .cornerRadius(8)
    }
}

struct FountainDetailSheet_Previews: PreviewProvider {
    static var previews: some View {
        FountainDetailSheet(
            fountain: Fountain(
                id: UUID(),
                name: "Central Park Fountain",
                address: "123 Park Avenue, New York, NY",
                latitude: 40.7829,
                longitude: -73.9654,
                waterType: "Filtered Drinking Water",
                availability: "6:00 AM - 10:00 PM",
                notes: "Located near the main entrance. Clean and well-maintained."
            )
        )
    }
}
