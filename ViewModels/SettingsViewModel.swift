//
//  SettingsViewModel.swift
//  AquaFinder
//
//  Created on 11/04/2025.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var notificationsEnabled: Bool = true
    @Published var locationPermissionGranted: Bool = false
    @Published var selectedTheme: AppTheme = .system
    @Published var searchRadius: Double = 5.0 // in kilometers
    @Published var showTutorial: Bool = false
    @Published var dataUsageMode: DataUsageMode = .standard
    @Published var language: String = "en"
    @Published var autoRefresh: Bool = true
    @Published var refreshInterval: Int = 30 // in minutes
    
    private let userDefaults = UserDefaults.standard
    
    // Keys for UserDefaults
    private enum Keys {
        static let notificationsEnabled = "notificationsEnabled"
        static let selectedTheme = "selectedTheme"
        static let searchRadius = "searchRadius"
        static let showTutorial = "showTutorial"
        static let dataUsageMode = "dataUsageMode"
        static let language = "language"
        static let autoRefresh = "autoRefresh"
        static let refreshInterval = "refreshInterval"
    }
    
    init() {
        loadSettings()
        checkLocationPermission()
    }
    
    // MARK: - Settings Management
    
    func loadSettings() {
        notificationsEnabled = userDefaults.bool(forKey: Keys.notificationsEnabled)
        
        if let themeRawValue = userDefaults.string(forKey: Keys.selectedTheme),
           let theme = AppTheme(rawValue: themeRawValue) {
            selectedTheme = theme
        }
        
        let savedRadius = userDefaults.double(forKey: Keys.searchRadius)
        searchRadius = savedRadius > 0 ? savedRadius : 5.0
        
        showTutorial = userDefaults.bool(forKey: Keys.showTutorial)
        
        if let modeRawValue = userDefaults.string(forKey: Keys.dataUsageMode),
           let mode = DataUsageMode(rawValue: modeRawValue) {
            dataUsageMode = mode
        }
        
        if let savedLanguage = userDefaults.string(forKey: Keys.language) {
            language = savedLanguage
        }
        
        autoRefresh = userDefaults.bool(forKey: Keys.autoRefresh)
        
        let savedInterval = userDefaults.integer(forKey: Keys.refreshInterval)
        refreshInterval = savedInterval > 0 ? savedInterval : 30
    }
    
    func saveSettings() {
        userDefaults.set(notificationsEnabled, forKey: Keys.notificationsEnabled)
        userDefaults.set(selectedTheme.rawValue, forKey: Keys.selectedTheme)
        userDefaults.set(searchRadius, forKey: Keys.searchRadius)
        userDefaults.set(showTutorial, forKey: Keys.showTutorial)
        userDefaults.set(dataUsageMode.rawValue, forKey: Keys.dataUsageMode)
        userDefaults.set(language, forKey: Keys.language)
        userDefaults.set(autoRefresh, forKey: Keys.autoRefresh)
        userDefaults.set(refreshInterval, forKey: Keys.refreshInterval)
    }
    
    func resetSettings() {
        notificationsEnabled = true
        selectedTheme = .system
        searchRadius = 5.0
        showTutorial = false
        dataUsageMode = .standard
        language = "en"
        autoRefresh = true
        refreshInterval = 30
        
        saveSettings()
    }
    
    // MARK: - Notifications
    
    func toggleNotifications() {
        notificationsEnabled.toggle()
        saveSettings()
        
        if notificationsEnabled {
            requestNotificationPermission()
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if !granted {
                    self.notificationsEnabled = false
                    self.saveSettings()
                }
            }
        }
    }
    
    // MARK: - Location
    
    func checkLocationPermission() {
        let status = CLLocationManager.authorizationStatus()
        locationPermissionGranted = (status == .authorizedWhenInUse || status == .authorizedAlways)
    }
    
    func requestLocationPermission() {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Theme
    
    func updateTheme(_ theme: AppTheme) {
        selectedTheme = theme
        saveSettings()
    }
    
    // MARK: - Search Radius
    
    func updateSearchRadius(_ radius: Double) {
        searchRadius = radius
        saveSettings()
    }
    
    // MARK: - Data Usage
    
    func updateDataUsageMode(_ mode: DataUsageMode) {
        dataUsageMode = mode
        saveSettings()
    }
    
    // MARK: - Tutorial
    
    func showTutorialScreen() {
        showTutorial = true
    }
    
    func completeTutorial() {
        showTutorial = false
        saveSettings()
    }
    
    // MARK: - Auto Refresh
    
    func toggleAutoRefresh() {
        autoRefresh.toggle()
        saveSettings()
    }
    
    func updateRefreshInterval(_ interval: Int) {
        refreshInterval = interval
        saveSettings()
    }
    
    // MARK: - App Info
    
    func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        return "\(version) (\(build))"
    }
    
    func clearCache() {
        URLCache.shared.removeAllCachedResponses()
        
        if let bundleID = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleID)
        }
        
        loadSettings()
    }
}

// MARK: - Supporting Types

enum AppTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    case system = "System"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}

enum DataUsageMode: String, CaseIterable {
    case lowData = "Low Data"
    case standard = "Standard"
    case highQuality = "High Quality"
    
    var description: String {
        switch self {
        case .lowData:
            return "Reduces data usage by limiting image quality and background updates"
        case .standard:
            return "Balanced data usage for optimal performance"
        case .highQuality:
            return "Maximum quality with higher data consumption"
        }
    }
}

// MARK: - Required Imports
import UserNotifications
import CoreLocation
