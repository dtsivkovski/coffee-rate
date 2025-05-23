//
//  ContentView.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 4/29/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var selection: Int = 0;
    
    
    var body: some View {
        
        VStack(spacing: 0){
            LogoHeader()
            
            TabView(selection: $selection) {
                Tab("My Ratings", systemImage: "list.bullet", value: 0) {
                    RatingsList()
                }
                Tab("Wishlist", systemImage: "moon.stars.fill", value: 1) {
                    WantToGoList()
                }
                Tab("Map", systemImage: "map", value: 2) {
                    AllRatingsMap()
                }
                Tab("Favorites", systemImage: "star", value: 3) {
                    Favorites()
                }
                Tab("My Stats", systemImage: "person.crop.circle", value: 4) {
                    StatsView()
                }
            }.tint(.accentColor)
        }.background(.logoHeaderBackground)
    }
}

#Preview {
    ContentView()
        
}
