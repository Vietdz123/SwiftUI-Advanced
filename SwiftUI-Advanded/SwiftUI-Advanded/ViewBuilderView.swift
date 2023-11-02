//
//  ViewBuilderView.swift
//  SwiftUI-Advanded
//
//  Created by MAC on 02/11/2023.
//

import SwiftUI

struct GenericstructView<CustomType: View>: View {
    
    var content: CustomType
    
    init( @ViewBuilder content: () -> CustomType) {
        self.content = content()
    }
    
    var body: some View {
        content
    }
    
}


struct ViewBuilderView: View {
    var body: some View {
        GenericstructView {
            HStack(content: {
                Text("Placeholder")
            })
        }
    }
}

#Preview {
    ViewBuilderView()
}
