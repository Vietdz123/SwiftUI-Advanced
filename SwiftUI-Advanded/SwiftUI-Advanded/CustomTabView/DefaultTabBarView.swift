//
//  CustomTabBarView.swift
//  SwiftUI-Advanded
//
//  Created by MAC on 03/11/2023.
//

import SwiftUI

struct DefaultTabBarView: View {
    @State private var selectionTab = 0
    
    var body: some View {
        TabView(selection: $selectionTab) {
            Color.red
            .tabItem {
                VStack(alignment: .center, spacing: 8) {
                    Image(systemName: "house.fill")
                    Text("home")
                }
            }
            
            Color.blue
            .tabItem {
                VStack(alignment: .center, spacing: 8) {
                    Image(systemName: "homepodmini.fill")
                    Text("home")
                }
            }
            
        }
        .accentColor(.red)
        
    }
}

