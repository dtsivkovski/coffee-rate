//
//  ShareableRating.swift
//  Coffee Rate
//
//  Created by Daniel Tsivkovski on 5/18/25.
//

import SwiftUI


struct ShareableRating: View {
    let rating: Rating;

    // noise level string
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

    // get color of rating circle
    var overallRatingCircleColor: Color {
        if rating.overallRating > 7.0 {
            return Color.green
        } else if rating.overallRating < 3.5 {
            return Color.red
        } else {
            return Color.orange
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // name and visited date
            HStack {
                VStack (alignment: .leading) {
                    Text(rating.name)
                        .font(.system(size: 20, weight: .bold))
                    Text("Visited on: \(rating.whenVisited.formatted(date: .abbreviated, time: .omitted))")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                Spacer()
                ZStack {
                    // circle for overall rating
                    Circle()
                        .fill(overallRatingCircleColor)
                        .frame(width: 36, height: 36) // Slightly larger circle
                    Text("\(rating.overallRating.formatted(.number.rounded(increment: 0.1)))")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(2)
                .shadow(radius: 2, y: 1.0)
            }
            
            Divider().padding(.vertical, 2)

            // individual category ratings
            VStack(alignment: .leading, spacing: 4) {
                Text("Details")
                     .font(.system(size: 14, weight: .semibold))
                     .padding(.bottom, 2)
                RatingShareDetailRow(label: "Study Vibe", value: "\(rating.studyVibe)/10", symbol: "laptopcomputer")
                RatingShareDetailRow(label: "Food/Drink", value: "\(rating.foodOrDrinkRating)/10", symbol: "cup.and.saucer.fill")
                RatingShareDetailRow(label: "Availability", value: "\(rating.availability)/5", symbol: "person.2.fill")
                RatingShareDetailRow(label: "Noise Level", value: noiseLevelString, symbol: "waveform")
            }
            
            // show comments if they exist
            if let comments = rating.comments, !comments.isEmpty {
                Divider().padding(.vertical, 2)
                Text("Notes:")
                    .font(.system(size: 14, weight: .semibold))
                Text(comments)
                    .font(.system(size: 12))
                    .lineLimit(3) // limit to 3 lines so it doesn't overflow
                    .foregroundColor(.secondary)
            }
        }
        .padding(15)
        .background(Color(uiColor: .systemBackground)) // system background color
        .cornerRadius(12)
        .frame(width: 320)
        .shadow(color: Color.black.opacity(0.1), radius: 5, y: 2)
    }
}

// view for rows of rating
struct RatingShareDetailRow: View {
    let label: String
    let value: String
    let symbol: String?

    var body: some View {
        HStack {
            if let symbol = symbol {
                Image(systemName: symbol)
                    .font(.system(size: 12))
                    .foregroundColor(.accentColor)
                    .frame(width: 20)
            }
            Text(label + "")
                .font(.system(size: 12))
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .semibold))
        }
    }
}

#Preview {
    let r = Rating(name: "Contra Coffee and Tea",latitude: 33.788187, longitude: -117.851938, whenVisited: Date(), isFavorited: false, studyVibe: 10, foodOrDrinkRating: 9, noiseLevel: .normal, availability: 0, overallRating: 4.12341234, comments: "I'm so MAD that there aren't any spots available at any reasonable times of the day!!! asdfasdfaksdljfjhaksdfhasdklfahsdifahsdfausdfaisdfasdiufhoiwuufehoiqwehfioqweuhfoqiuwehfqiwuehfqiwuehfqiowefuqiwehfiqwehufqiwoefhuqiwoefuhqiwoeufhqioweufhqiweuhfqiwehfuiqwehfiquwehfiquwehfiqweuhfioquwehfiquwehfqw")
    ShareableRating(rating: r)
}
