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
    //var comments: String?;
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
        //comments: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.hasVisited = hasVisited
        self.latitude = latitude
        self.longitude = longitude
    }
}


struct WantToGoView: View {
    @Environment(\.modelContext) var modelContext
    @Query var items: [WantToGoItem]
    @Bindable var item: WantToGoItem
    var hasVisited: Bool = false
    
    @Binding var navigationPath: NavigationPath;
    
    @AppStorage("comments") var comments: String = "Insert Comments Here"
    
    var visitedColor : Color {
            get {
                if (item.hasVisited == true) {
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
                
               
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thinMaterial)
                        .shadow(radius: 8, y: 5.0)
                    
                    VStack(alignment: .center) {
                        Text("Notes")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.thinMaterial) // Match the card background
                            
                            TextEditor(text: $comments)
                                .font(.caption)
                                .padding(8) // internal padding for text
                                .scrollContentBackground(.hidden)
                                .background(Color.clear) // disable native background
                                .cornerRadius(12)
                            
                        } //end of inner ZStack
                        .frame(height: 100)
                    } //end of VStack
                    .padding(10)
                } //end of ZStack
                .padding(10)

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
            
            
               
            // TODO: add rating to AllRatings
                //if hasVisited = true
                    //have an 'Add' button after hasVisited is toggled to 'true' that has the same function as AddRating in order to add it to RatingsList
            
            
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
    
}
