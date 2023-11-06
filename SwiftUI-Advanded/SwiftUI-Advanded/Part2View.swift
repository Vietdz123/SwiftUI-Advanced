//
//  Part2View.swift
//  SwiftUI-Advanded
//
//  Created by Three Bros on 05/11/2023.
//

import SwiftUI

struct EventInfoBadge: View {
    var iconName: String
    var text: String

    var body: some View {
        VStack {
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Text(text)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
        .cornerRadius(8)
        .padding()
    }
}

struct HeightRowSync<Background: View, ContentView: View>: View {
    
    let contentView: ContentView
    let background: Background
    @State private var childHeight: CGFloat?
    
    init(background: Background,
         @ViewBuilder contentView: () -> ContentView) {
        self.contentView = contentView()
        self.background = background
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            contentView
                .syncHeightLarger(than: $childHeight)
                .frame(height: childHeight)
                .background(background)
        }
        

    }
}


struct Part2View: View {
    var body: some View {
        VStack {
            
            Spacer()
            HeightRowSync(background: Color.secondary.opacity(0.3)) {
                EventInfoBadge(
                    iconName: "video.circle.fill",
                    text: "Video call available"
                )
                
                EventInfoBadge(
                    iconName: "doc.text.fill",
                    text: "Files are attached"
                )
                EventInfoBadge(
                    iconName: "person.crop.circle.badge.plus",
                    text: "Invites enabled, 5 people maximum"
                )
            }
        }
        .padding()
        
    }
}

struct HeightSyncRowPreference: PreferenceKey {

    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
    
}

extension View {
    
    func syncHeightLarger(than height: Binding<CGFloat?>) -> some View {
        
        background {
            GeometryReader { geo in
                Color.clear.preference(key: HeightSyncRowPreference.self,
                                       value: geo.size.height)
                
            }
            .onPreferenceChange(HeightSyncRowPreference.self, perform: { value in
                height.wrappedValue = max(height.wrappedValue ?? 0, value)
            })
        }
    }
    
}

#Preview {
    Part2View()
}
