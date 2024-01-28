//
//  ActivityManager.swift
//  PetLiveActivity
//
//  Created by Three Bros on 26/01/2024.
//

import SwiftUI

import ActivityKit
import Foundation

struct PetDemoLiveAcitivyAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        
        var imageName: String
    }
    
    var namePet: String
}

final class ActivityManager: ObservableObject {
    @MainActor @Published private(set) var activityID: String?
    @MainActor @Published private(set) var activityToken: String?
    
    static let shared = ActivityManager()
    @MainActor private var numGuest = 0
    let imageName = ["naruto", "qq"]
    
    init() {
        //        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
//            
//            if numGuest < imageName.count - 1 {
//                
//                
//                
//                Task {
//                    
//                    numGuest += 1
//                    await  updateActivityRandomly(imageName: imageName[numGuest])
//                }
//                
//            } else {
//                
//                Task {
//                    numGuest = 0
//                    await  updateActivityRandomly(imageName: imageName[numGuest])
//                }
//                
//            }
//        }
    }
    
    
    func start() async {
        await endActivity(imageName: "naruto")
        await startNewLiveActivity()
        
//        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
//            
//            if numGuest < imageName.count - 1 {
//                
//                
//                
//                Task {
//                    
//                    numGuest += 1
//                    await  updateActivityRandomly(imageName: imageName[numGuest])
//                }
//                
//            } else {
//                
//                Task {
//                    numGuest = 0
//                    await  updateActivityRandomly(imageName: imageName[numGuest])
//                }
//                
//            }
//        }
    }
    
    private func startNewLiveActivity() async {
        var alertConfig: AlertConfiguration? = nil
        alertConfig = AlertConfiguration(
            title: "qq has been knocked down!",
            body: "Open the app and use a potion to heal qq.",
            sound: .default
        )
        let attributes = PetDemoLiveAcitivyAttributes(namePet: "Sasuke")
        
        let initialContentState = ActivityContent(state: PetDemoLiveAcitivyAttributes.ContentState(imageName: "naruto"), staleDate: nil)
        
        let activity = try? Activity.request(
            attributes: attributes,
            content: initialContentState,
            pushType: nil
        )
        
        guard let activity = activity else {
            return
        }
        await MainActor.run { activityID = activity.id }
        
        for await data in activity.pushTokenUpdates {
            let token = data.map {String(format: "%02x", $0)}.joined()
            print("Activity token: \(token)")
            await MainActor.run { activityToken = token }
            // HERE SEND THE TOKEN TO THE SERVER
        }
    }
    
    func updateActivityRandomly(imageName: String) async {
        
        guard let activityID = await activityID,
              let runningActivity = Activity<PetDemoLiveAcitivyAttributes>.activities.first(where: { $0.id == activityID }) else {
            return
        }
        

        
        let newContentState = PetDemoLiveAcitivyAttributes.ContentState(imageName: imageName)
        await runningActivity.update(using: newContentState, alertConfiguration: nil)
    }
    
    func endActivity(imageName: String) async {
        guard let activityID = await activityID,
              let runningActivity = Activity<PetDemoLiveAcitivyAttributes>.activities.first(where: { $0.id == activityID }) else {
            return
        }
        let endContentState = PetDemoLiveAcitivyAttributes.ContentState(imageName: imageName)
        
        
        await runningActivity.end(
            ActivityContent(state: endContentState, staleDate: Date.distantFuture),
            dismissalPolicy: .immediate
        )
        
        await MainActor.run {
            self.activityID = nil
            self.activityToken = nil
        }
    }
    
    
}
