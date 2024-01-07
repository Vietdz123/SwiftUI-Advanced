//
//  ContentView.swift
//  AsyncAwaitLearning
//
//  Created by Three Bros on 06/01/2024.
//

import SwiftUI

class ConcurrencyModel: ObservableObject {
    
    @MainActor
    func sayHello() async {
        print("DEBUG: \(Thread.current)")
        
        try? await Task.sleep(nanoseconds: 500000)
        print("DEBUG: \(Thread.current)")
        
        try? await Task.sleep(nanoseconds: 2000)
        print("DEBUG: \(Thread.current)")
        
        for i in 0 ... 5000 {
            print("DEBUG: \(i) qq")
        }
    }
}

struct ContentView: View {
    
    @ObservedObject private var viewModel = ConcurrencyModel()
    
    var body: some View {
        VStack {
            Text("Hello, world!")
        }
        .task {
            await viewModel.sayHello()
        }
        .task {
            for i in 0 ... 10 {
                if i == 5 {
                    try? await Task.sleep(nanoseconds: 1000000)
                }
                print("DEBUG: \(i)")
            }
        }
    }
}

