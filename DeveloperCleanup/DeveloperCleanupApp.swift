//
//  DeveloperCleanupApp.swift
//  DeveloperCleanup
//
//  Created by Giorgos Charitakis on 26/12/21.
//

import SwiftUI

@main
struct DeveloperCleanupApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel())
        }
    }
}
