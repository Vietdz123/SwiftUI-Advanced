//
//  LayoutReaderView.swift
//  SwiftUI-Advanded
//
//  Created by Three Bros on 06/01/2024.
//

import SwiftUI

struct LayingOutUsingPhi: View {
    var body: some View {
        GeometryReader { gr in
            VStack {
                Rectangle()
                    .fill(Color.blue)
                    // Adjust the height to be 38% of the device height
                    .frame(height: gr.size.height * 0.38)
                    .overlay(Text("Height: \(gr.size.height * 0.38)"))
                Rectangle()
                    .fill(Color.purple)
                    .overlay(Text("Height: \(gr.size.height * 0.62)"))
            }
            .edgesIgnoringSafeArea(.vertical)
            .font(.largeTitle)
        }
        .edgesIgnoringSafeArea(.vertical)
        .onAppear(perform: {
             print("DEBUG: \(heightDevice) and ")
        })
    }
        
}

