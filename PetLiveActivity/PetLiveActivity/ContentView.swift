//
//  ContentView.swift
//  PetLiveActivity
//
//  Created by Three Bros on 26/01/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State @MainActor private var numGuest = 0
    let imageName = ["naruto", "qq"]

    

    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                Task {
                    await  ActivityManager.shared.start()
                }
            }, label: {
                Text("Start New Activity")
            })
            
            Button(action: {
                Task {
//                    numGuest = 1
                    await  ActivityManager.shared.updateActivityRandomly(imageName: "qq")
                }
            }, label: {
                Text("Update New Activity")
            })
            
        }
        .onAppear(perform: {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
                
                if numGuest < imageName.count - 1 {
                    
                    
                    
                    Task {
                        numGuest += 1
                        print("DEBUG: \(await numGuest) num")
                        await  ActivityManager.shared.updateActivityRandomly(imageName: imageName[numGuest])
                    }
                    
                } else {
                    
                    Task {
                        numGuest = 0
                        print("DEBUG: \(await numGuest) qq")
                        await  ActivityManager.shared.updateActivityRandomly(imageName: imageName[numGuest])
                    }
                    
                }
            }
        })
//        .onChange(of: numGuest, initial: false, { oldValue, newValue in
//            print("DEBUG: zo \(oldValue) and \(newValue)")
//            if numGuest < imageName.count - 1 {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    
//     
//                    Task {
//                        
//                        numGuest += 1
//                        await  ActivityManager.shared.updateActivityRandomly(imageName: imageName[numGuest])
//                    }
//                }
//            } else {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    Task {
//                        numGuest = 0
//                        await  ActivityManager.shared.updateActivityRandomly(imageName: imageName[numGuest])
//                    }
//                }
//            }
//            
//        })
        .padding()
        .background(.white)
    }
}
