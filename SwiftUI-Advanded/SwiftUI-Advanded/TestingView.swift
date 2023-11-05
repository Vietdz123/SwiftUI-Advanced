//
//  TestingView.swift
//  SwiftUI-Advanded
//
//  Created by Three Bros on 04/11/2023.
//

import SwiftUI

struct TestingView: View {
    var body: some View {
        
//        VStack(alignment: .leading, spacing: 16) {
//            Rectangle()
//                .frame(width: 300, height: 80)
//                .overlay {
//                    Button(action: {
//                        print("DEBUG: qq")
//                    }, label: {
//                        Text("Button")
//                            .frame(width: 80, height: 80)
//                            .background(.yellow)
//                            .offset(y: 100)
//                    })
//                    .background(.red)
//                    .offset(x: 30, y: 100)
//                    .background(.blue)
//                }
//            
//            
//            Text("Siuuuuuuuuu")
//                .background(.red)
//                .offset(x: 30, y: 100)
//                .background(.purple)
//                .onTapGesture {
//                    print("DEBUG: đb")
//                }
//              
//        }
        

        
        HStack(alignment: .center, spacing: 0) {
            Text("Siuu fshvf. hghj dgfhjdgs jh ")
                .layoutPriority(1)
        
            Color.red
            
            Color.yellow
                .frame(maxWidth: .infinity)

        }
        .frame(width: 200, height: 300)
        .font(.largeTitle)
        .foregroundColor(.gray)
        .background(.green)

    }
    
//    var body: some View {
//        HStack(spacing: 0) {
//                Rectangle().fill(.gray)
//                    .frame(width: 100)
//                Rectangle().fill(.red)
//                    .frame(width: 100)
//                Rectangle().fill(.blue)
//                    .frame(width: 100)
//                    .position(x: 0, y: 0)
////                    .offset(x: 100, y: 200)
////                Rectangle().fill(.red)
////                    .frame(width: 100)
//            }
//        .frame(height: 200)
//        .background(.yellow)
//        }
}

#Preview {
    TestingView()
}
