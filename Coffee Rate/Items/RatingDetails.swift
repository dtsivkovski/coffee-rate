//
//  RatingDetails.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 4/29/25.
//
// References used for Sharing Image:
//  - https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image
//  - https://www.reddit.com/r/SwiftUI/comments/19ehpnq/sharelink_imagerenderer/
//

import SwiftUI
import SwiftData
import MapKit

struct RatingDetails: View {
    
    @Environment(\.dismiss) var dismiss;
    @Environment(\.modelContext) var modelContext;
    @Environment(\.colorScheme) var colorScheme;
    @Query var ratings: [Rating];
    var rating : Rating;
    
    // used for deletion, sharing, and navigation
    @State private var deleteAlertPresented: Bool = false;
    @State private var renderedImage = Image(systemName: "photo");
    @Binding var navigationPath: NavigationPath;
    
    // gets the index for the rating position
    var ratingIndex : Int {
        ratings.firstIndex(where: { $0.id == rating.id }) ?? 0;
    }
    
    // get a string for the noise level value
    var noiseLevelString: String {
        switch (NoiseLevel(rawValue: rating.noiseLevel)) {
            case .quiet:
                return "Quiet";
            case .loud:
                return "Loud";
            default:
                return "Normal";
        }
    }
    
    // gets background color for the rating circle
    var circleBackgroundColor : Color {
        get {
            if (colorScheme == .dark) {
                if (rating.overallRating > 7.0) {
                    return Color(red: 50/256, green: 150/256, blue: 50/256)
                } else if (rating.overallRating < 3.5) {
                    return Color(red: 150/256, green: 50/256, blue: 50/256)
                } else {
                    return .yellow.mix(with: .red, by: 0.3).mix(with: .black, by: 0.05);
                }
            }
            if (rating.overallRating > 7.0) {
                return Color(red: 170/256, green: 230/256, blue: 160/256)
            } else if (rating.overallRating < 3.5) {
                return Color(red: 255/256, green: 152/256, blue: 140/256)
            } else {
                return Color(red: 255/256, green: 227/256, blue: 135/256);
            }
        }
    }
    
    var body: some View {
        ScrollView {
            // create the map element
            if (rating.location != nil) {
                MapPreview(name: rating.name, location: rating.location!)
                    .padding(20)
                    .shadow(radius: 8, y: 5.0)
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
                    .foregroundStyle(circleBackgroundColor.shadow(.inner(color: .black.opacity(0.2),radius: 4, y: 4)))
                    .frame(height: 80)
                Text("\(rating.overallRating.formatted(.number.rounded(increment: 0.1)))")
                    .font(.title)
                    .fontWeight(.semibold)
                    .shadow(radius:1, y: 2)
            }
            .offset(y: -80)
            .padding([.bottom], -70)
            VStack {
                HStack{
                    // location name
                    Text(rating.name)
                        .font(.title)
                        .fontWeight(.bold)
                    FavoriteButton(isSet: Bindable(rating).isFavorited)
                        .frame(width: 40)
                }
                Text("Rated on \(rating.whenVisited, style: .date)")
                    .font(.subheadline)
                    .padding(.bottom, 8)
                // z stack containing background rectangle and the individual ratings
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.thinMaterial)
                        .shadow(radius: 8, y: 5.0)
                    VStack {
                        HStack {
                            Text("Ratings")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }.padding(-3)
                        // all rating progress bars
                        RatingProgress(symbol: "laptopcomputer" ,label: "Study Vibe", value: rating.studyVibe, outOf: 10)
                        RatingProgress(symbol: "cup.and.saucer.fill", label: "Food/Drink", value: rating.foodOrDrinkRating, outOf: 10)
                        RatingProgress(symbol: "person.2.fill", label: "Availability", value: rating.availability, outOf: 5)
                        RatingProgress(symbol: "waveform", label: "Noise Level", value: rating.noiseLevel, outOf: 2, alternateLabel: noiseLevelString)
                    }
                    .padding(16)
                }
                // user notes section
                if (rating.comments != nil) {
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
                            Text(rating.comments!)
                        }
                            .padding(16)
                    }.padding(.top, 10)
                }
            }
            .padding([.leading, .trailing, .bottom], 20)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // present the deletion warning
                    deleteAlertPresented = true;
                }) {
                    Image(systemName: "trash")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink( // share link for image preview
                    "Here's my rating for \(rating.name)!",
                    item: renderedImage,
                    preview: SharePreview(Text("Here's my rating for \(rating.name)!"), image: renderedImage)
                )
            }
        }
        // create alert for deletion of rating
        .alert(isPresented: $deleteAlertPresented) {
            Alert(
                title: Text("Delete this rating"),
                message: Text("Are you sure that you want to delete this rating? This cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    // remove rating from model and update path to previous
                    modelContext.delete(rating);
                    if (navigationPath.count > 0) {
                        navigationPath.removeLast() // remove last if navigationpath is valid
                    } else {
                        dismiss() // dismisses the presentation
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            renderShareableImage()
        }
    }

    // renders the view for the shareable image
    @MainActor
    func renderShareableImage() -> Void {
        let renderer = ImageRenderer(content: ShareableRating(rating: rating))
        renderer.scale = UIScreen.main.scale;
        
        if let uiImage = renderer.uiImage {
            renderedImage = Image(uiImage: uiImage)
        } else {
            renderedImage = Image(systemName: "exclamationmark.triangle") // if error
        }
        
    }
    
}

struct RatingProgress : View {
    
    var symbol: String;
    var label: String;
    
    var value: Int;
    var outOf: Int;
    
    var alternateLabel: String?;
    
    var body: some View {
        VStack {
            // labels for the specific rating
            HStack {
                Image(systemName: symbol)
                Text(label)
                    .fontWeight(.medium)
                Spacer()
                Text( alternateLabel != nil ? alternateLabel! : "\(value)/\(outOf)")
                    .fontWeight(.semibold)
            }.padding(.bottom, -2)
            // progress value
            ProgressView(value: Double(value)/Double(outOf))
        }
        .padding([.top, .bottom], 5)
    }
}

struct MapPreview : View {
    
    var name: String;
    var location: CLLocationCoordinate2D;
    
    var body: some View {
        // create map
        Map(position: .constant(.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: location.latitude,
                    longitude: location.longitude
                ),
                span: MKCoordinateSpan(
                    latitudeDelta: 0.002,
                    longitudeDelta: 0.002
                ))
        )), interactionModes: .zoom){
            // create the marker for the coffee shop
            Marker(
                name,
                coordinate: location
            )
        }
        // adjust styling for the map (POI, height, etc)
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .frame(height: 300)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 20)))
    }
}

#Preview {
    @Previewable @State var navigationPath: NavigationPath = NavigationPath();
    let r = Rating(name: "Contra Coffee and Tea",latitude: 33.788187, longitude: -117.851938, whenVisited: Date(), isFavorited: false, studyVibe: 10, foodOrDrinkRating: 9, noiseLevel: .normal, availability: 0, overallRating: 4.12341234, comments: "I'm so MAD that there aren't any spots available at any reasonable times of the day!!!")
    RatingDetails(rating: r, navigationPath: $navigationPath)
    
}
