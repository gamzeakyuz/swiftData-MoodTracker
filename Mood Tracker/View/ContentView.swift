//
//  ContentView.swift
//  Mood Tracker
//
//  Created by GamzeAkyuz on 5.11.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        TabView {
            EntriesListView()
                .tabItem {
                    Label("Daily", systemImage: "book.fill")
                }
            
            StatusView()
                .tabItem {
                    Label("Status", systemImage: "chart.bar.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
