//
//  TestingGeometryReaderView.swift
//  SwiftUI-Advanded
//
//  Created by Three Bros on 05/01/2024.
//

import SwiftUI

struct TestingGeometryReaderView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                GeometryReader { gr in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.pink)
                        .overlay(
                            VStack {
                                Text("X: \(Int(gr.frame(in: .global).origin.x))")
                                Text("Y: \(Int(gr.frame(in: .global).origin.y))")
                        })
                }.frame(height: 400)
                
                GeometryReader { gr in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.orange)
                        .overlay(
                            VStack {
                                Text("X: \(Int(gr.frame(in: .global).origin.x))")
                                Text("Y: \(Int(gr.frame(in: .global).origin.y))")
                        })
                }.frame(height: 400)
                
                GeometryReader { gr in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                        .overlay(
                            VStack {
                                Text("X: \(Int(gr.frame(in: .global).origin.x))")
                                Text("Y: \(Int(gr.frame(in: .global).origin.y))")
                        })
                }.frame(height: 400)
            }
        }

        
    }
}

#Preview {
    TestingGeometryReaderView()
}
