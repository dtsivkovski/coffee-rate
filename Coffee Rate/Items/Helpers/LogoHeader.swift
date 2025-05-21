//
//  LogoHeader.swift
//  Coffee Rate
//
//  Created by Ava DeCristofaro on 5/20/25.
//

import SwiftUI
import SwiftData

struct LogoHeader: View {

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 15/255, green: 102/255, blue: 23/255))
                .opacity(0.1)
                .frame(height: 70)
                .frame(maxWidth: .infinity)

            Image("home-button")
                .resizable()
                .frame(width: 150, height: 140)
                .padding(-30)
        }
    }
}


#Preview {
    LogoHeader()
}
