//
//  Part2View.swift
//  SwiftUI-Advanded
//
//  Created by Three Bros on 05/11/2023.
//

import SwiftUI

struct EventInfoBadge: View {
    var iconName: String
    var text: String

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Text(text)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
        .background(.secondary)
        .cornerRadius(8)
        .padding()
    }
}

struct Part2View: View {
    var body: some View {
        VStack {
            
            Spacer()
            HStack {
                EventInfoBadge(
                    iconName: "video.circle.fill",
                    text: "Video call available"
                )
                
                EventInfoBadge(
                    iconName: "doc.text.fill",
                    text: "Files are attached"
                )
                EventInfoBadge(
                    iconName: "person.crop.circle.badge.plus",
                    text: "Invites enabled, 5 people maximum"
                )
            }
        }
        .padding()
        
    }
}

#Preview {
    Part2View()
}
