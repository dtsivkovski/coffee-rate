//
//  FavoriteButton.swift
//  Coffee Rate
//
//  Created by Ava DeCristofaro on 5/14/25.
//
import SwiftUI

struct FavoriteButton: View {
    @Binding var isSet: Bool
    
    var body: some View {
        Button {
            isSet.toggle()
        } label: {
            Label {
                // empty on-screen text, since we only want the icon
            } icon: {
                Image(isSet ? "favorites-coffee-icon-selected" : "favorites-coffee-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

#Preview {
    FavoriteButton(isSet: .constant(true))
}
