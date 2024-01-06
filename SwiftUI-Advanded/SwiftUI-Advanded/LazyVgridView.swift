//
//  LazyVgridView.swift
//  SwiftUI-Advanded
//
//  Created by Three Bros on 06/01/2024.
//

import SwiftUI

struct LazyVgridView: View {

    private var colors: [Color] = [.yellow, .purple, .green]

    private var gridItemLayout = [GridItem(.flexible(), spacing: 50), GridItem(.flexible(), spacing: 15), GridItem(.flexible())]
    
    @State private var textString = "dsad"
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TextField(text: $textString) {
                    Text("đâsdasdasdasdasd")
                }
                
                
                LazyVGrid(columns: gridItemLayout, spacing: 5) {
                        Text("textString")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.red)
                            .cornerRadius(10)
                    
                    Text("textString đá ád ád ád ád fdslf. hfdjkshf jksdf jdfhjks")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.red)
                        .cornerRadius(10)
                    
                    Text("textString")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.red)
                        .cornerRadius(10)
                    
                    Text("textString")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.red)
                        .cornerRadius(10)
                
                Text("textString đá ád ád ád ád")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.red)
                    .cornerRadius(10)
                
                Text("textString")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.red)
                    .cornerRadius(10)
                    
                }
                .frame(width: widthDevice, alignment: .leading)
            }
            

        }
    }
}

#Preview {
    LazyVgridView()
}
