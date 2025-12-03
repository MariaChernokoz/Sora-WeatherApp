//
//  SoraApp.swift
//  Sora
//
//  Created by Chernokoz on 06.11.2025.
//

import SwiftUI
import SwiftData

@main
struct SoraApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: CityEntity.self)
    }
}
