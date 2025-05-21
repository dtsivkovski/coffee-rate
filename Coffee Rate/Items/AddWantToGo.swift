//
//  AddWantToGo.swift
//  Coffee Rate
//
//  Created by Ava DeCristofaro on 5/20/25.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit

struct AddWantToGo: View {
    @Environment(\.modelContext) var modelContext;
    @Binding var navigationPath: NavigationPath;
    
    @State private var position = MapCameraPosition.userLocation(fallback: MapCameraPosition.automatic);
    @State private var confirmedLocation: SearchResult? = nil;
    @State private var userRegion: MKCoordinateRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 33.789082, longitude: -117.852358),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    
    
    var body: some View {
        ScrollView {
            Text("Add A Place To Go")
                .font(.title)
                .fontWeight(.bold)
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.thinMaterial)
                    .shadow(radius: 8, y: 5.0)
                MapSearchSheet(currentMapRegion: $userRegion, selectedLocation: $confirmedLocation)
                
            }
            .padding([.bottom, .trailing, .leading])
            .frame(minHeight: 300, maxHeight: 500)
            // display button to add item after a spot has been chosen
            if (confirmedLocation != nil) {
                
                SubmitWantToGo(navigationPath: $navigationPath, confirmedLocation: confirmedLocation, modelContext: modelContext)
            }
        }
    }// end body
}


struct SubmitWantToGo: View {
    
    // dismiss variable once added
    @Environment(\.dismiss) var dismiss;
    @Binding var navigationPath: NavigationPath;
    
    // include search result and model context
    var confirmedLocation: SearchResult?;
    var modelContext: ModelContext;
    
    @State private var comments: String = "";
    
    var body: some View {
        VStack {
            // container for notes
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.thinMaterial)
                    .shadow(radius: 8, y: 5.0)
                VStack {
                    Text("Notes")
                        .fontWeight(.semibold)
                    TextEditor(text: $comments)
                        .frame(minHeight: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()
        }
        Button(action: {
          let newWantToGoItem =
            WantToGoItem(
                id: UUID(),
                name: confirmedLocation!.name,
                hasVisited: false,
                comments: comments,
                latitude: confirmedLocation!.location.latitude,
                longitude: confirmedLocation!.location.longitude
            )
            
            // insert new rating into model
            modelContext.insert(newWantToGoItem);
            
            if (navigationPath.count > 0) {
                navigationPath.removeLast() // remove last if navigationpath is valid
            } else {
                dismiss() // dismisses the presentation
            }
        }){
            Text("Add Coffee Shop")
        }
        .padding(.top, 16)
        .buttonStyle(BorderedProminentButtonStyle())
        .shadow(radius: 8, y: 5.0)

    }
}

    
//within WantToGoList:
    // when visited is checked to true, reveal a button that says "Rate Coffee Shop" that navigates you to add screen

#Preview {
    ContentView()
}
