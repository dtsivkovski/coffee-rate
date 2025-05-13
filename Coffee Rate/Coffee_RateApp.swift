//
//  Coffee_RateApp.swift
//  Coffee Rate
//
//  Boilerplate created by Daniel Tsivkovski on 4/29/25.
//

import SwiftUI
import SwiftData

@main
struct Coffee_RateApp: App {
    var body: some Scene {
        WindowGroup {
//            NavigationStack{
                ContentView()
                
//                WantToGoView(item: WantToGoItem(name: "Long Dog Coffee", hasVisited: false, latitude: 33.788187, longitude: -117.851938))
//                
//                WantToGoList(items: [
//                    WantToGoItem(name: "Long Dog Coffee and Treats", hasVisited: false, latitude: 33.789180, longitude: -117.853625),
//                    WantToGoItem(name: "Contra", hasVisited: false, latitude: 33.789180, longitude: -117.853625)
//                ])
            }
//        }
        .modelContainer(for: [Rating.self, WantToGoItem.self])
        //.modelContainer(for: Rating.self)
    }
}
