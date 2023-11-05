//
//  PdfToWordTabView.swift
//  SwiftUI-Advanded
//
//  Created by MAC on 03/11/2023.
//

import SwiftUI

enum AssetConstant {
    static let ic_file_selected = "ic_file_selected"
    static let ic_file = "ic_file"
    static let ic_home_selected = "ic_home_selected"
    static let ic_home = "ic_home"
    static let ic_setting = "ic_setting"
    static let ic_setting_selected = "ic_setting_selected"
    static let ic_tool_selected = "ic_tool_selected"
    static let ic_tool = "ic_tool"
    
    static let ic_plus = "ic_plus"
}


enum TapBarType: Int, CaseIterable {
    
    case home
    case files
    case tools
    case settings
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .files:
            return "Files"
        case .tools:
            return "Tools"
        case .settings:
            return "Settings"
        }
    }
    
    var imageName: String {
        switch self {
        case .home:
            return AssetConstant.ic_home
        case .files:
            return AssetConstant.ic_file
        case .tools:
            return AssetConstant.ic_tool
        case .settings:
            return AssetConstant.ic_setting
        }
    }
    
    var imageNameSelected: String {
        switch self {
        case .home:
            return AssetConstant.ic_home_selected
        case .files:
            return AssetConstant.ic_file_selected
        case .tools:
            return AssetConstant.ic_tool_selected
        case .settings:
            return AssetConstant.ic_setting_selected
        }
    }
}


struct TabBarItemView: View {
    
    var data: TapBarType
    @Binding var selected: TapBarType
    
    var image: String {
        return selected == data ? data.imageNameSelected : data.imageName
    }
    
    var foregroundColor: Color {
        return selected != data ? Color(hex: "0xA6B1BB") :  Color(hex: "0x3F6CE1")
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            Button(action: {
                selected = data
            }, label: {
                VStack(alignment: .center, spacing: 8) {
                    Image(image)
                        
                    Text(data.title)
                        .foregroundColor(foregroundColor)
                    
                }
     
            })
          
        }
    }
}

struct TabPDFView: View {
    
    @Binding var selectedTab: TapBarType
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            
            TabBarItemView(data: .home, selected: $selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.leading, 16)
      
            
            TabBarItemView(data: .files, selected: $selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: -26)
          
            TabBarItemView(data: .tools, selected: $selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: 26)
          
            
            TabBarItemView(data: .settings, selected: $selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.trailing, 16)
            
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 56)
        .overlay {
            
            Button(action: {
                print("DEBUG: plussss")
            }, label: {
                Circle()
                    .fill(.blue)
                    .frame(width: 76, height: 76)
                    .overlay{
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 22, height: 22)
                    }
                
            })
            .offset(y : -80)
            
        }
        
    }
    
}



struct PdfToWordTabView: View {
    @State var selectedTab: TapBarType = .home
    
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
            VStack(spacing: 0) {
                TabView(selection: $selectedTab) {
                    Color.red
                        .tag(TapBarType.home)
                    
                    Color.blue
                        .tag(TapBarType.files)
                    
                    Color.yellow
                        .tag(TapBarType.tools)
                    
                    Color.orange
                        .tag(TapBarType.settings)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                
                TabPDFView(selectedTab: $selectedTab)
                    
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

    }
}

#Preview(body: {
    PdfToWordTabView()
})
