import SwiftUI

struct RootView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var searchText = ""
    @State private var showingFilterSheet = false
    @State private var selectedWaterType: WaterType?
    @State private var maxDistance: Double = 10.0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Deep sea blue gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.0, green: 0.2, blue: 0.4),
                        Color(red: 0.0, green: 0.3, blue: 0.5),
                        Color(red: 0.0, green: 0.4, blue: 0.6)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.7))
                        TextField("Search for water sources...", text: $searchText)
                            .foregroundColor(.white)
                            .accentColor(.white)
                        Button(action: { showingFilterSheet = true }) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(12)
                    .padding()
                    
                    // Map view
                    MapView(
                        locationManager: locationManager,
                        selectedWaterType: selectedWaterType,
                        maxDistance: maxDistance
                    )
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    // Water sources list
                    WaterSourceListView(
                        searchText: searchText,
                        selectedWaterType: selectedWaterType,
                        maxDistance: maxDistance,
                        locationManager: locationManager
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(.top, 8)
                }
            }
            .navigationTitle("AquaFinder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("AquaFinder")
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showingFilterSheet) {
                FilterView(
                    selectedWaterType: $selectedWaterType,
                    maxDistance: $maxDistance
                )
            }
        }
        .accentColor(.white)
    }
}

enum WaterType: String, CaseIterable, Identifiable {
    case all = "All"
    case fountain = "Fountain"
    case bottleRefill = "Bottle Refill"
    case tap = "Tap"
    case natural = "Natural Source"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .all: return "drop.fill"
        case .fountain: return "fountain.fill"
        case .bottleRefill: return "waterbottle.fill"
        case .tap: return "spigot.fill"
        case .natural: return "leaf.fill"
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
