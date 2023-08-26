//
//  Business_SearchApp.swift
//  Business Search
//
//  Created by Bo Tang on 11/18/22.
//

import SwiftUI

@main
struct Business_SearchApp: App {
    @StateObject var businessSearchViewModel = BusinessSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            SearchView()
                .environmentObject(businessSearchViewModel)
        }
    }
}
