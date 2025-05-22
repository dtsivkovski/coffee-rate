//
//  WantToGo.swift
//  Coffee Rate
//
//  Created by Ava DeCristofaro on 4/30.
//

import Foundation
import SwiftUI
import SwiftData
import MapKit

@Model
class WantToGoItem: Identifiable {
    var id: UUID = UUID()
    
    // Coffee Shop Info
    var name: String
    var hasVisited: Bool
    var comments: String?;
    private var latitude: Double?
    private var longitude: Double?
    
    // Computed CLLocationCoordinate2D, not stored in SwiftData
    @Transient var location: CLLocationCoordinate2D? {
        get {
            guard let latitude, let longitude else { return nil }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            self.latitude = newValue?.latitude
            self.longitude = newValue?.longitude
        }
    }
    
    // Initializer
    init(
        id: UUID = UUID(),
        name: String,
        hasVisited: Bool,
        comments: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.hasVisited = hasVisited
        self.comments = comments
        self.latitude = latitude
        self.longitude = longitude
    }
}


struct WantToGoView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme;
    @Query var items: [WantToGoItem]
    @Bindable var item: WantToGoItem
    var hasVisited: Bool = false
    
    @Binding var navigationPath: NavigationPath;
    
    var visitedColor : Color {
        get {
            if (colorScheme == .dark){
                if (item.hasVisited) {
                    return Color(red: 50/256, green: 150/256, blue: 50/256)
                } else {
                    return Color(red: 150/256, green: 50/256, blue: 50/256)
                }
            }
            if (item.hasVisited) {
                    return Color(red: 185/255, green: 242/255, blue: 184/255)
            } else {
                return Color(red: 252/255, green: 119/255, blue: 119/255)
            }
        }
    }
    
    var body: some View {
        ScrollView{
            // create the map element
            if (item.location != nil) {
                MapPreview(name: item.name, location: item.location!)
            }
            else {
                // rectangle to account for circle being shifted up when no location
                Rectangle()
                    .fill(.background)
                    .frame(height:90)
            }
            
            ZStack {
                // circle to indicate overall rating
                Circle().fill(.thinMaterial)
                    .frame(height: 90)
                    .shadow(radius: 6, y: 4)
                Circle()
                    .frame(height: 80)
                    .foregroundColor(visitedColor)
                
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(Color(.black).opacity(0.7))
                    .font(.system(size: 50))
                    .frame(width: 100, height: 100)
            }
            .offset(y: -80)
            .padding([.bottom], -100)
            
            VStack {
                //Name of Coffee Shop
                Text(item.name)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()

                // Notes section
                if (item.comments != nil) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.thinMaterial)
                            .shadow(radius: 8, y: 5.0)
                        VStack {
                            HStack {
                                Text("Notes")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                            }.padding(-2)
                            Text(item.comments!)
                        }
                        .padding(16)
                    }.padding(.top, 10)
                }
                
            } //end of Notes VStack
            .padding()
            
            //checkbox if visited
            HStack{
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thinMaterial)
                        .frame(width: 135, height: 50)
                        .shadow(radius: 8, y: 10.0)
                    
                    RoundedRectangle(cornerRadius: 14)
                        .frame(width: 125, height: 40)
                        .foregroundColor(visitedColor)
                        .shadow(radius: 8, y: 10.0)
                    
                    //checkbox
                    CheckboxView(hasVisited: $item.hasVisited)
                }
            }
            .padding(.trailing) //padding right
            .padding(.bottom)
            
            // to rate a place AFTER visiting
            if (item.hasVisited){
                HStack {
                    Spacer()
                    NavigationLink(value: "Add Rating") {
                        Text("Rate Coffee Shop")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    Spacer()
                }
            }
        } //end of ScrollView
    } //end of body
}

//Displaying Toggle as a checkbox
struct CheckboxView: View {
    @Binding var hasVisited: Bool

    var body: some View {
        Button(action: {
            hasVisited.toggle()
        }) {
            HStack {
                Image(systemName: hasVisited ? "checkmark.square" : "square")
                Text("Visited?")
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview{
    ContentView()
}
