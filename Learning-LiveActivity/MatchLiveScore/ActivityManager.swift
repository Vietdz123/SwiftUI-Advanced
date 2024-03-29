//
//  ActivityManager.swift
//  Learning-LiveActivity
//
//  Created by MAC on 25/01/2024.
//

import Foundation
import ActivityKit
import Foundation

struct MatchLiveScoreAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var homeTeamScore: Int
        var awayTeamScore: Int
        var lastEvent: String
    }
    
    var homeTeam: String
    var awayTeam: String
    var date: String
}

final class ActivityManager: ObservableObject {
    @MainActor @Published private(set) var activityID: String?
    @MainActor @Published private(set) var activityToken: String?
    
    static let shared = ActivityManager()
    
    func start() async {
        await endActivity()
        await startNewLiveActivity()
    }
    
    private func startNewLiveActivity() async {
        let attributes = MatchLiveScoreAttributes(homeTeam: "Badger",
                                                  awayTeam: "Lion",
                                                  date: "12/09/2023")
        
        let initialContentState = ActivityContent(state: MatchLiveScoreAttributes.ContentState(homeTeamScore: 0,
                                                                                               awayTeamScore: 0,
                                                                                               lastEvent: "Match Start"),
                                                  staleDate: nil)
        
        let activity = try? Activity.request(
            attributes: attributes,
            content: initialContentState,
            pushType: nil
        )
        
        guard let activity = activity else {
            print("DEBUG: \(activity) qqq")
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
    
    func updateActivityRandomly() async {
        guard let activityID = await activityID,
              let runningActivity = Activity<MatchLiveScoreAttributes>.activities.first(where: { $0.id == activityID }) else {
            return
        }
        let newRandomContentState = MatchLiveScoreAttributes.ContentState(homeTeamScore: Int.random(in: 1...9),
                                                                          awayTeamScore: Int.random(in: 1...9),
                                                                          lastEvent: "Something random happened!")
        await runningActivity.update(using: newRandomContentState)
    }
    
    func endActivity() async {
        guard let activityID = await activityID,
              let runningActivity = Activity<MatchLiveScoreAttributes>.activities.first(where: { $0.id == activityID }) else {
            return
        }
        let initialContentState = MatchLiveScoreAttributes.ContentState(homeTeamScore: 0,
                                                                        awayTeamScore: 0,
                                                                        lastEvent: "Match Start")

        await runningActivity.end(
            ActivityContent(state: initialContentState, staleDate: Date.distantFuture),
            dismissalPolicy: .immediate
        )
        
        await MainActor.run {
            self.activityID = nil
            self.activityToken = nil
        }
    }
    
    func cancelAllRunningActivities() async {
        for activity in Activity<MatchLiveScoreAttributes>.activities {
            let initialContentState = MatchLiveScoreAttributes.ContentState(homeTeamScore: 0,
                                                                            awayTeamScore: 0,
                                                                            lastEvent: "Match Start")
            
            await activity.end(
                ActivityContent(state: initialContentState, staleDate: Date()),
                dismissalPolicy: .immediate
            )
        }
        
        await MainActor.run {
            activityID = nil
            activityToken = nil
        }
    }
    
}
