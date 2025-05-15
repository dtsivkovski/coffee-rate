//
//  Rating.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 4/29/25.
//

import Foundation
import SwiftData
import MapKit

enum NoiseLevel : Int {
    case quiet = 0
    case normal = 1
    case loud = 2
}

@Model
class Rating: Identifiable {
    var id: UUID = UUID();
    
    // Coffee Shop Data
    var name: String;
    var whenVisited: Date;
    var isFavorited: Bool
    private var latitude: Double?
    private var longitude: Double?
    
    // have to calculate location coordinate using doubles because swift data cannot store this type
    @Transient var location: CLLocationCoordinate2D? {
        get {
            guard let latitude, let longitude else { return nil } // return nil if no latitude or longitude
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        set {
            self.latitude = newValue?.latitude;
            self.longitude = newValue?.longitude;
        }
    }
    
    // Rating Information
    var studyVibe: Int;
    var foodOrDrinkRating: Int;
    var noiseLevel: NoiseLevel.RawValue;
    var availability: Int;
    var overallRating: Double;
    var comments: String?;
    
    // initializer
    init(
        id: UUID = UUID(),
        name: String,
        latitude: Double? = nil,
        longitude: Double? = nil,
        whenVisited: Date,
        isFavorited: Bool,
        studyVibe: Int,
        foodOrDrinkRating: Int,
        noiseLevel: NoiseLevel,
        availability: Int,
        overallRating: Double,
        comments: String? = nil
    ) {
        self.id = id;
        self.name = name;
        self.latitude = latitude;
        self.longitude = longitude;
        self.whenVisited = whenVisited;
        self.isFavorited = isFavorited;
        self.studyVibe = studyVibe;
        self.foodOrDrinkRating = foodOrDrinkRating;
        self.noiseLevel = noiseLevel.rawValue;
        self.availability = availability;
        self.overallRating = overallRating;
        self.comments = comments;
    }
}
