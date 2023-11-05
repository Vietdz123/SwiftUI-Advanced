//
//  ButtonStyleView.swift
//  SwiftUI-Advanded
//
//  Created by MAC on 02/11/2023.
//

import SwiftUI

struct ButtonStyleCustom: ButtonStyle {
    
    let background: Color
    
    init(background: Color = .red) {
        self.background = background
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? background : .yellow)
            .scaleEffect(configuration.isPressed ? 0.5 : 1.0)
            
    }
    
}


struct ButtonStyleView: View {
    var body: some View {
        Button(action: {
            
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
        
    }
    
}
                     
                                       
                                       
                                       
                                       
                                       
                                    
