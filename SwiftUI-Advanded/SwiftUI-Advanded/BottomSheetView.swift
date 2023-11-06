//
//  BottomSheetView.swift
//  SwiftUI-Advanded
//
//  Created by MAC on 06/11/2023.
//

import SwiftUI

struct BottomSheetView: View {
    
    var nameImages = ["m1", "m2", "m3", "m4"]
    @State private var showBottomSheet = false
    
    var body: some View {
        ScrollView(.vertical) {
            
                LazyVStack(spacing: 10) {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showBottomSheet = true
                        }
                    }, label: {
                        Text("Showing Bottom")
                    })
                    .zIndex(1)
                    
                    ForEach(nameImages, id: \.self) { name in
                        Image(name)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 200)
                            .clipped()
                    }
                }
            
        }
        .overlay(alignment: .bottom) {
            if showBottomSheet {
                BottomView(heightBottom: 400,
                           spaceCanBack: 150,
                           heightCanTop: 100,
                           isShowed: $showBottomSheet)
                    .transition(.move(edge: .bottom))
            }
     
                
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct BottomView: View {
    
    let heightBottom: CGFloat
    let spaceCanBack: CGFloat
    let heightCanTop: CGFloat
    @State private var offsetY: CGFloat
    @State private var latestOffset: CGFloat
    @Binding private var isShowed: Bool
    
    init(heightBottom: CGFloat,
         spaceCanBack: CGFloat,
         heightCanTop: CGFloat,
         isShowed: Binding<Bool>) {
        self.heightBottom = heightBottom + heightCanTop
        self.spaceCanBack = spaceCanBack
        self.heightCanTop = heightCanTop
        self.offsetY = heightCanTop
        self.latestOffset = heightCanTop
        self._isShowed = isShowed
    }
    
    var body: some View {
        Rectangle()
            .fill(.red)
            .ignoresSafeArea()
            .frame(width: widthDevice, height: heightBottom)
            .ignoresSafeArea()
            .cornerRadius(15, corners: [.topLeft, .topRight])
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged { drag in
                        let y = drag.translation.height
                        
                        if y <= -heightCanTop {
                            return
                        }
                        
                        offsetY = y + latestOffset
                    }
                    .onEnded { drag in
                        let y = drag.translation.height
                        
                        if y > spaceCanBack {
                            offsetY = heightBottom + heightCanTop
                            self.isShowed = false
                        } else {
                            offsetY = heightCanTop
                        }
                    }
            )
    }
    
    func showing() {
        offsetY = heightCanTop
    }
}


#Preview {
    BottomSheetView()
}
