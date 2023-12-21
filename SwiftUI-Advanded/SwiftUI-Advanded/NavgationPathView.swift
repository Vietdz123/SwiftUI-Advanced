//
//  TabView.swift
//  SwiftUI-Advanded
//
//  Created by MAC on 18/12/2023.
//

import SwiftUI

struct TabView: View {
    @State private var showNewTweetView = false
    @State private var path = NavigationPath()
    @Binding var text: String
    @State var showView1: Bool = false
    var body: some View {
        NavigationStack(path: $path) {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .onTapGesture {
                    
                }
        }
        .navigationDestination(isPresented: $showView1) {
            Text("View")
        }

        
        
    }
}

struct View1: View {
    
    @Binding var path: NavigationPath
    let title: String
    var body: some View {
        Text(title)
            .onAppear {
                print("DEBUG: \(path.count)")
            }
            .onTapGesture {
                
            }
    }
}

