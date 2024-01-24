//
//  MatchLiveScoreLiveActivity.swift
//  MatchLiveScore
//
//  Created by MAC on 24/01/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MatchLiveScoreAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MatchLiveScoreLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchLiveScoreAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MatchLiveScoreAttributes {
    fileprivate static var preview: MatchLiveScoreAttributes {
        MatchLiveScoreAttributes(name: "World")
    }
}

extension MatchLiveScoreAttributes.ContentState {
    fileprivate static var smiley: MatchLiveScoreAttributes.ContentState {
        MatchLiveScoreAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MatchLiveScoreAttributes.ContentState {
         MatchLiveScoreAttributes.ContentState(emoji: "🤩")
     }
}

//#Preview("Notification", as: .content, using: MatchLiveScoreAttributes.preview) {
//   MatchLiveScoreLiveActivity()
//} contentStates: {
//    MatchLiveScoreAttributes.ContentState.smiley
//    MatchLiveScoreAttributes.ContentState.starEyes
//}
