//
//  LocationService.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 5/4/25.
//
//  Reference used for Map Search:
//   - https://www.polpiella.dev/mapkit-and-swiftui-searchable-map
//
//  Note: NOT counted as part of our 7 swiftUI view requirements, as the majority of this was from a tutorial.
//

import MapKit

struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let location: CLLocationCoordinate2D

    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct SearchCompletion: Identifiable {
    let id = UUID()
    let title: String
    let subTitle: String
    let mapKitCompletion: MKLocalSearchCompletion
    
    init (mapKitCompletion : MKLocalSearchCompletion) {
        self.title = mapKitCompletion.title;
        self.subTitle = mapKitCompletion.subtitle;
        self.mapKitCompletion = mapKitCompletion
    }
}

@Observable
class LocationService: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter

    var completions = [SearchCompletion]()

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer;
        super.init();
        self.completer.delegate = self;
    }

    func update(queryFragment: String) {
        completer.resultTypes = .pointOfInterest;
        completer.queryFragment = queryFragment;
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results.map { .init(mapKitCompletion: $0) }
    }
    
    // search using a search completion - the tutorial originally searched using a string, but I modified it to take a searchcompletion value
    func search(for selectedCompletion: SearchCompletion, region: MKCoordinateRegion? = nil) async throws -> SearchResult? {
        // built the request using completion
        let mapKitRequest = MKLocalSearch.Request(completion: selectedCompletion.mapKitCompletion);
        if let region = region {
            mapKitRequest.region = region;
        }
        let search = MKLocalSearch(request: mapKitRequest)
        
        let response = try await search.start();
        
        // check if mapItem exists for the query
        guard let mapItem = response.mapItems.first else {
            return nil;
        }
        // check if coordinates exist
        guard let location = mapItem.placemark.location?.coordinate else {
            return nil;
        }
        // check if name exists
        guard let name = mapItem.name ?? mapItem.placemark.name else {
            return nil;
        }
        
        return SearchResult(name: name, location: location);
    }
}
