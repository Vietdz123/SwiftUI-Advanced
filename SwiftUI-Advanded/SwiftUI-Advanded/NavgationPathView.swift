//
//  TabView.swift
//  SwiftUI-Advanded
//
//  Created by MAC on 18/12/2023.
//

import SwiftUI

struct NavgationPathView: View {
    @State private var showNewTweetView = false
    @State private var path = NavigationPath()
    @State var showView1: Bool = false
    var body: some View {
        NavigationStack(path: $path) {
            ZStack(alignment: .center) {
                Image("background")
                Image("khunglong_1")
            }
                .onTapGesture {
                    showView1 = true
                }
                .onAppear {
                    print("DEBUG: qqqq")
                    print("DEBUG: \(path.count) ")
                }
                .navigationDestination(isPresented: $showView1) {
                    View1(path: $path, title: "View 111")
                }
        }


        
        
    }
}

struct View1: View {
    
    @Binding var path: NavigationPath
    let title: String
    @State var showView3: Bool = false
    var body: some View {
        Text(title)
            .onAppear {
                print("DEBUG: \(path.count)")
            }
            .onTapGesture {
                showView3 = true
            }
            .navigationDestination(isPresented: $showView3) {
                View3(path: $path, title: "View 3 SIuuu")
            }
    }
}

struct View3: View {
    
    @Binding var path: NavigationPath
    let title: String
    @State var showView3: Bool = false
    var body: some View {
        Text(title)
            .onAppear {
                print("DEBUG: \(path.count)")
            }
            .onTapGesture {
                showView3 = true
            }
            .navigationDestination(isPresented: $showView3) {
                Text("Quan que")
            }
    }
}
