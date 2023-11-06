//
//  LearnAnimationStack.swift
//  SwiftUI-Advanded
//
//  Created by MAC on 06/11/2023.
//

import SwiftUI

struct LearnAnimationStack: View {
    @State private var path: [Int] = []
    
    var body: some View {
        
        NavigationStack(path: $path) {
            Button("Start") {
                path.append(1)

            }
            .navigationDestination(for: Int.self) { int in
                DetailView(path: $path, count: int)
            }
        }
    }
}

struct DetailView: View {

    @Binding var path: [Int]
    let count: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button("Go deeper \(count)") {
                path.append(count + 1)
            }
            .navigationBarTitle(count.description)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Pop to Root") {
                        path = []

                    }
                }
            }
            
            Button("Go back ") {
                path.remove(at: count - 1)
            }
            
        }

    }
}

#Preview {
    LearnAnimationStack()
}
