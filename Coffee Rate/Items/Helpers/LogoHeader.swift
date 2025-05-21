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
                .opacity(0)
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
