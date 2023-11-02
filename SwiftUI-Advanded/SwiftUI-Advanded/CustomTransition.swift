//
//  CustomTransition.swift
//  SwiftUI-Advanded
//
//  Created by MAC on 02/11/2023.
//

import SwiftUI



struct RotateViewModifier: ViewModifier {
    
    let rotation: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotation))
            .scaleEffect(rotation != 0 ? 2 : 1)
    }
    
}


extension AnyTransition {
    
    static var rotatingCustom: AnyTransition {
        return AnyTransition.modifier(active: RotateViewModifier(rotation: 100),
                                      identity: RotateViewModifier(rotation: 0))
    }
    
}


struct CustomTransition: View {
    
    @State private var showRec = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            
            if showRec {
                Rectangle()
                    .fill(.red)
                    .frame(width: 300, height: 200)
                    .transition(AnyTransition.rotatingCustom)
                    .padding(.top, 200)
            }

                
            Spacer()
            
            Button(action: {
                withAnimation(.easeOut) {
                    showRec.toggle()
                }
            }, label: {
                Text("Click Me")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .cornerRadius(20)
                    .background(.blue)
                    .cornerRadius(20)
                    .padding()
                    
            })
            .buttonStyle(ButtonStyleCustom(background: .red))
            .padding()
        }
    }
}
