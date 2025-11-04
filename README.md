# AquaFinder

AquaFinder is an iOS application designed to help users locate and explore water-related locations including beaches, pools, water parks, and aquariums. Built with SwiftUI, the app provides an intuitive interface with a beautiful aquatic-themed color scheme.

## Features

### Core Functionality
- **Location Discovery**: Search and discover various water-related venues including:
  - Beaches
  - Swimming pools
  - Water parks
  - Aquariums
- **Interactive Map**: View all locations on an integrated map interface
- **Detailed Information**: Access comprehensive details about each location
- **User-Friendly Interface**: Clean, modern design with intuitive navigation

### Color Scheme
AquaFinder uses a carefully selected aquatic-themed color palette:
- **Primary Blue**: `#0077BE` - Main brand color representing water
- **Light Aqua**: `#7FCDCD` - Accent color for highlights and interactive elements
- **Deep Ocean**: `#003F5C` - Dark accent for depth and contrast
- **Seafoam**: `#B8E6E6` - Light background and subtle elements
- **White**: `#FFFFFF` - Text and clean backgrounds

These colors create a cohesive, water-inspired visual experience throughout the app.

## Build Requirements

- **Xcode**: 14.0 or later
- **iOS Deployment Target**: iOS 15.0 or later
- **Swift**: 5.7 or later
- **macOS**: macOS Monterey (12.0) or later

## Build Steps

### 1. Clone the Repository
```bash
git clone https://github.com/Khafeefa/AquaFinder.git
cd AquaFinder
```

### 2. Open in Xcode
```bash
open AquaFinder.xcodeproj
```
Or simply double-click the `AquaFinder.xcodeproj` file in Finder.

### 3. Configure Project Settings
1. Select the AquaFinder project in the Project Navigator
2. Select the AquaFinder target
3. In the "Signing & Capabilities" tab:
   - Select your development team
   - Ensure "Automatically manage signing" is checked
   - Update the Bundle Identifier if needed (e.g., `com.yourname.AquaFinder`)

### 4. Build and Run
1. Select your target device or simulator from the scheme menu (top toolbar)
2. Press `⌘ + R` or click the Play button to build and run
3. Wait for the build process to complete
4. The app will launch on your selected device/simulator

### 5. Troubleshooting Build Issues

**If you encounter signing errors:**
- Ensure you're logged into Xcode with your Apple ID (Xcode > Settings > Accounts)
- Create a new Bundle Identifier unique to your account

**If dependencies are missing:**
```bash
# Clean build folder
Product > Clean Build Folder (⌘ + Shift + K)
# Rebuild the project
Product > Build (⌘ + B)
```

**If the simulator won't launch:**
- Restart Xcode
- Reset the simulator: Device > Erase All Content and Settings

## Usage

### Getting Started
1. **Launch the App**: Open AquaFinder on your iOS device or simulator
2. **Grant Permissions**: Allow location access when prompted for personalized results
3. **Explore Locations**: Browse the main screen to see nearby water venues

### Navigating the App

#### Home Screen
- View featured water locations
- Access quick filters for different venue types
- See recently viewed locations

#### Search Functionality
- Use the search bar to find specific locations
- Filter by category (Beach, Pool, Water Park, Aquarium)
- Search by location name or address

#### Map View
- Tap the map icon to view all locations geographically
- Tap markers to see location details
- Use pinch gestures to zoom in/out

#### Location Details
- Tap any location card to view detailed information
- See photos, descriptions, and amenities
- Get directions to the location
- Save favorites for quick access

### Tips for Best Experience
- Enable location services for accurate nearby results
- Save your favorite locations for quick access
- Use filters to narrow down your search
- Check location details for hours and amenities before visiting

## Project Structure

```
AquaFinder/
├── AquaFinder.xcodeproj
├── AquaFinder/
│   ├── AquaFinderApp.swift      # App entry point
│   ├── Views/                   # SwiftUI views
│   ├── Models/                  # Data models
│   ├── ViewModels/             # View models
│   └── Resources/              # Assets and resources
├── Resources/                   # Additional resources
└── README.md                   # This file
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is available for educational and personal use.

## Contact

Project Link: [https://github.com/Khafeefa/AquaFinder](https://github.com/Khafeefa/AquaFinder)

---

**Made with 💙 for water enthusiasts everywhere**
