//
//  Rating.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 4/29/25.
//

import Foundation
import SwiftData
import MapKit

enum NoiseLevel {
    case quiet;
    case normal;
    case loud;
}

@Model
class Rating: Identifiable {
    var id: UUID = UUID();
    
    // Coffee Shop Data
    var name: String;
    var location: CLLocationCoordinate2D?;
    var whenVisited: Date;
    
    // Rating Information
    var studyVibe: Int;
    var foodOrDrinkRating: Int;
    var noiseLevel: NoiseLevel;
    var availability: Int;
    var overallRating: Int;
    var comments: String?;
    
    // initializer
    init(
        id: UUID = UUID(),
        name: String,
        location: CLLocationCoordinate2D? = nil,
        whenVisited: Date,
        studyVibe: Int,
        foodOrDrinkRating: Int,
        noiseLevel: NoiseLevel,
        availability: Int,
        overallRating: Int,
        comments: String? = nil
    ) {
        self.id = id;
        self.name = name;
        self.location = location;
        self.whenVisited = whenVisited;
        self.studyVibe = studyVibe;
        self.foodOrDrinkRating = foodOrDrinkRating;
        self.noiseLevel = noiseLevel;
        self.availability = availability;
        self.overallRating = overallRating;
        self.comments = comments;
    }
}
