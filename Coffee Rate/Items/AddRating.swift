//
//  AddRating.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 4/29/25.
//
//  Reference used for Map Search:
//   - https://www.polpiella.dev/mapkit-and-swiftui-searchable-map - This reference was used to help create the search aspects for the Add Rating view
//


import SwiftUI
import SwiftData
import MapKit

struct AddRating: View {
    
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
            Text("Rate a spot")
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
            // display remaining rating options once a spot has been chosen
            if (confirmedLocation != nil) {
                FinalRatingSubmission(navigationPath: $navigationPath, confirmedLocation: confirmedLocation, modelContext: modelContext)
            }
        }
    }
}

struct MapSearchSheet : View {
    
    @State private var locationService = LocationService(completer: .init());
    @State private var searchText: String = "";
    @State private var tappedListItem: SearchCompletion? = nil;
    
    @Binding var currentMapRegion: MKCoordinateRegion;
    @Binding var selectedLocation: SearchResult?;
    
    @FocusState private var searchFieldIsFocused: Bool;
    
    var body: some View {
            VStack {
                // search element
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search for a study spot", text: $searchText)
                        .onChange(of: searchText) { oldValue, newValue in
                            if selectedLocation != nil {
                                selectedLocation = nil;
                            }
                            locationService.update(queryFragment: newValue)
                        }
                        .focused($searchFieldIsFocused)
                    if (!searchText.isEmpty) {
                        // button to clear completions
                        Button {
                            searchText = ""
                            locationService.completions = []
                            selectedLocation = nil
                            self.tappedListItem = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                List {
                    ForEach(locationService.completions) { completion in
                        Button(action: {
                            Task {
                                do {
                                    // get location from tapped search item
                                    self.searchText = completion.title;
                                    
                                    let location = try await locationService.search(for: completion, region: currentMapRegion);
                                    
                                    self.selectedLocation = location;
                                } catch {
                                    print("error finding location")
                                }
                                
                            }
                            // update tapped list item
                            self.tappedListItem = completion;
                            self.searchFieldIsFocused = false;
                            
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(completion.title)
                                    .font(.headline)
                                    .fontDesign(.rounded)
                                Text(completion.subTitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .listRowBackground(
                            (self.tappedListItem?.subTitle == completion.subTitle && self.tappedListItem?.title == completion.title) ? Color.blue.opacity(0.2) : Color.clear
                        )
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .padding()
        }
}

struct FinalRatingSubmission : View {
    
    // dismiss variable once added
    @Environment(\.dismiss) var dismiss;
    @Binding var navigationPath: NavigationPath;
    
    // include search result and model context
    var confirmedLocation: SearchResult?;
    var modelContext: ModelContext;
    
    // state variabels for each rating type
    @State private var studyVibe: Double = 5;
    @State private var foodAndDrinkRating: Double = 5;
    @State private var availability: Double = 3;
    @State private var noiseLevel: Double = 1;
    
    @State private var comments: String = "";
    
    // function to get corresponding string of noise level
    func getNoiseLevelString(noiseLevel: Int) -> String {
        switch (NoiseLevel(rawValue: noiseLevel)) {
            case .quiet:
                return "Quiet";
            case .loud:
                return "Loud";
            default:
                return "Normal";
        }
    }
    
    var body: some View {
        VStack {
            // container for rating sliders
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.thinMaterial)
                    .shadow(radius: 8, y: 5.0)
                VStack {
                    // study vibe slider
                    RatingSlider(rating: $studyVibe, outOf: 10, icon: "laptopcomputer", label: "Study Vibe", valueLabel: "\(studyVibe.formatted())/10")
                    // food and drink rating slider
                    RatingSlider(rating: $foodAndDrinkRating, outOf: 10, icon: "cup.and.saucer.fill", label: "Food/Drink", valueLabel: "\(foodAndDrinkRating.formatted())/10")
                    // availability rating slider
                    RatingSlider(rating: $availability, outOf: 5, icon: "person.2.fill", label: "Availability", valueLabel: "\(availability.formatted())/5")
                    // noise level rating slider
                    RatingSlider(rating: $noiseLevel, outOf: 2, icon: "waveform", label: "Noise Level", valueLabel: "\(getNoiseLevelString(noiseLevel: Int(noiseLevel)))")
                    Text("Notes")
                        .fontWeight(.semibold)
                    TextEditor(text: $comments)
                        .frame(minHeight: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }.padding()
            }
            // button to submit the rating
            Button(action: {
                // calculate overall rating
                let overallRating : Double = (studyVibe + foodAndDrinkRating + availability) / 2.5;
                // create new rating
                let newRating = Rating(
                    id: UUID(),
                    name: confirmedLocation!.name,
                    latitude: confirmedLocation!.location.latitude,
                    longitude: confirmedLocation!.location.longitude,
                    whenVisited: Date(),
                    isFavorited: false,
                    studyVibe: Int(studyVibe),
                    foodOrDrinkRating: Int(foodAndDrinkRating),
                    noiseLevel: NoiseLevel(rawValue: Int(noiseLevel))!,
                    availability: Int(availability),
                    overallRating: overallRating,
                    comments: comments == "" ? nil : comments
                )
                // insert new rating into model
                modelContext.insert(newRating);
                if (navigationPath.count > 0) {
                    navigationPath.removeLast() // remove last if navigationpath is valid
                } else {
                    dismiss() // dismisses the presentation
                }
            }) {
                Text("Create Rating")
            }
                .padding(.top, 16)
                .buttonStyle(BorderedProminentButtonStyle())
                .shadow(radius: 8, y: 5.0)
        }.padding()
    }
}

struct RatingSlider : View {
    
    @Binding var rating: Double;
    var outOf: Double;
    
    var icon: String;
    var label: String;
    var valueLabel: String;
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: icon)
                Text(label)
                    .fontWeight(.medium)
                Spacer()
                Text(valueLabel)
                    .fontWeight(.semibold)
            }.padding(.bottom, -8)
            Slider(value: $rating, in: 0...outOf, step: 1)
        }
    }
}

#Preview {
//    AddRating()
    ContentView()
}
