//
//  PetDemoLiveAcitivyLiveActivity.swift
//  PetDemoLiveAcitivy
//
//  Created by Three Bros on 26/01/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI



struct PetDemoLiveAcitivyLiveActivity: Widget {
    
    @State private var numGuest = 0
    let imageName = ["naruto", "qq"]
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PetDemoLiveAcitivyAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.imageName)")
                
                Image(context.state.imageName)
                    .resizable()
                    .frame(width: 200, height: 130)
            }
            .onAppear {
                ActivityManager.shared
            }
//            .onAppear(perform: {
//                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
//                    
//                    if numGuest < imageName.count - 1 {
//                        
//                        
//                        
//                        Task {
//                            
//                            numGuest += 1
//                            await  ActivityManager.shared.updateActivityRandomly(imageName: imageName[numGuest])
//                        }
//                        
//                    } else {
//                        
//                        Task {
//                            numGuest = 0
//                            await  ActivityManager.shared.updateActivityRandomly(imageName: imageName[numGuest])
//                        }
//                        
//                    }
//                }
//            })
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image(context.state.imageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .background(.orange)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Image(context.state.imageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .background(.blue)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Image(context.state.imageName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .background(.red)
                    // more content
                }
            } compactLeading: {
                Image(context.state.imageName)
                    .resizable()
                    .frame(width: 40, height: 40)
            } compactTrailing: {
                Image(context.state.imageName)
                    .resizable()
                    .frame(width: 40, height: 40)
            } minimal: {
                Image(context.state.imageName)
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

