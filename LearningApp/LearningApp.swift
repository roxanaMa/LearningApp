//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Roxy Mardare on 06.04.2021.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
