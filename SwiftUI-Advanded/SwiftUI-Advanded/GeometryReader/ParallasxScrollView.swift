//
//  ParallasxScrollView.swift
//  SwiftUI-Advanded
//
//  Created by Three Bros on 06/01/2024.
//

import SwiftUI

struct ParallaxScrolling: View {
    var body: some View {
        ScrollView {
            ZStack(alignment: .leading) {
                GeometryReader { gr in
                    Image("map")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .blur(radius: 1)
                        .scaleEffect(1.8)
                        .opacity(0.4)
                        .offset(y: -gr.frame(in: .global).origin.y / 2)
                        
                }
                VStack(spacing: 40) {
                                    Text("UTAH")
                                        .font(.system(size: 30, weight: .black))
                                    Tile(imageName: "Arches", tileLabel: "Arches")
                                    Tile(imageName: "Canyonlands", tileLabel: "Canyonlands")
                                    Tile(imageName: "BryceCanyon", tileLabel: "Bryce Canyon")
                                    Tile(imageName: "GoblinValley", tileLabel: "Goblin Valley")
                                    Tile(imageName: "Zion", tileLabel: "Zion")
                                }
                                .padding(.horizontal, 40)
                        
            }.edgesIgnoringSafeArea(.vertical)
        }
    }
}

struct Tile: View {
    var imageName = ""
    var tileLabel = ""

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 200, alignment: .bottom)
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10, x: 0, y: 5)
            .overlay(VStack {
                Spacer()
                Text(tileLabel)
                    .padding(.bottom, 20)
                    .opacity(0.85)
                    .font(.system(size: 30, weight: .black))
                    .foregroundColor(.white)
            })
    }
}
