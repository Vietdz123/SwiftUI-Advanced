//
//  OffsetView.swift
//  SwiftUI-Advanded
//
//  Created by MAC on 06/11/2023.
//

import SwiftUI

struct OffsetView: View {
    
    @State private var offset: CGSize = .zero
    @State private var latestOffset: CGSize = .zero
    
    var body: some View {
        Rectangle()
            .fill(.red)
            .frame(width: 200, height: 300)
            .offset(x: offset.width, y: offset.height)
            .gesture(
                DragGesture()
                    .onChanged { drag in
                        self.offset = .init(width: drag.translation.width + self.latestOffset.width, height: drag.translation.height + self.latestOffset.height)

                    }
                    .onEnded { drag in
            
                        self.latestOffset.width = drag.translation.width + self.latestOffset.width
                        self.latestOffset.height = drag.translation.height + self.latestOffset.height
                    }
            )
    }
}

#Preview {
    OffsetView()
}
