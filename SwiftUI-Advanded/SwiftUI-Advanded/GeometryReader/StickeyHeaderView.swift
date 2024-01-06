//
//  StickeyHeaderView.swift
//  SwiftUI-Advanded
//
//  Created by Three Bros on 06/01/2024.
//

import SwiftUI

struct StickyHeader: View {
    var body: some View {
        ScrollView {
            ZStack {
                // Bottom Layer
                VStack(spacing: 20) {
                    Tile(imageName: "Arches", tileLabel: "Arches")
                    Tile(imageName: "Canyonlands", tileLabel: "Canyonlands")
                    Tile(imageName: "BryceCanyon", tileLabel: "Bryce Canyon")
                    Tile(imageName: "GoblinValley", tileLabel: "Goblin Valley")
                    Tile(imageName: "Zion", tileLabel: "Zion")
                }
                .padding(.horizontal, 20)
                .padding(.top, 330)
               
                // Top Layer (Header)
                GeometryReader { gr in
                    VStack(alignment: .leading) {
                        Image("Utah")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: getHeightHeader(offset: gr.frame(in: .global).minY))
                            .overlay(alignment: .leading) {
                                Text("UTAH")
                                    .font(.system(size: 70, weight: .black))
                                    .foregroundColor(.white)
                                    .opacity(0.8)
                            }
                            .offset(y: -gr.frame(in: .global).minY)
                        Spacer() // Push header to top
                    }
                }
            }
        }.edgesIgnoringSafeArea(.vertical)
    }
    
    func getHeightHeader(maxHeight: CGFloat = 300, minHeight: CGFloat = 150, offset: CGFloat) -> CGFloat {
        
        if maxHeight + offset < minHeight {
            return minHeight //maxHeight + offset
        }
        
//        return minHeight
        return maxHeight + offset
    }
}

#Preview {
    StickyHeader()
}
