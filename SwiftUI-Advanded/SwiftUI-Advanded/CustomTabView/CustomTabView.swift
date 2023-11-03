//
//  CustomTabView.swift
//  SwiftUI-Advanded
//
//  Created by MAC on 03/11/2023.
//

import SwiftUI

struct TabItemData {
    let image: String
    let selectedImage: String
    let title: String
}



struct TabItemView: View {
    
    let data: TabItemData
    let isSelected: Bool
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 8) {
            
            Image(systemName: isSelected ? data.selectedImage : data.image)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
            
            Text(data.title)
                   .foregroundColor(isSelected ? .black : .gray)
                   .font(.system(size: 14))
            
        }
        
    }
    
}

struct TabBottomView: View {
    
    let tabbarItems: [TabItemData]
    var height: CGFloat = 70
    var width: CGFloat = UIScreen.main.bounds.width - 32
    @Binding var selectedIndex: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            
            ForEach(0 ..< tabbarItems.count, id: \.self) { index in
                let item = tabbarItems[index]
                Button {
                    self.selectedIndex = index
                } label: {
                    let isSelected = selectedIndex == index
                    TabItemView(data: item, isSelected: isSelected)
                }
                Spacer()
            }

        }
        .frame(width: width, height: height)
        .background(Color.white)
        .cornerRadius(13)
        .shadow(radius: 5, x: 0, y: 4)
    }
}

struct CustomTabView: View {
    @State private var selectedIndex = 0
    var tabItems: [TabItemData] = [TabItemData(image: "house.circle", selectedImage: "house.circle.fill", title: "Home"),
                                   TabItemData(image: "homepodmini", selectedImage: "homepodmini.2", title: "Thùng"), 
                                   TabItemData(image: "homepodmini.and.appletv", selectedImage: "homepodmini.and.appletv.fill", title: "Apple") ]
    
    
//    [.init(data: TabItemData(image: "house.circle", selectedImage: "house.circle.fill", title: "Home"), isSelected: true),
//                                   .init(data: TabItemData(image: "homepodmini", selectedImage: "homepodmini.2", title: "Thùng"), isSelected: true),
//                                   .init(data: TabItemData(image: "homepodmini.and.appletv", selectedImage: "homepodmini.and.appletv.fill", title: "Apple"), isSelected: true)]
    
    var body: some View {
        TabBottomView(tabbarItems: tabItems, height: 70, selectedIndex: $selectedIndex)
    }
}

