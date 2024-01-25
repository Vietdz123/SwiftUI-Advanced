//
//  ContentView.swift
//  Learning-LiveActivity
//
//  Created by MAC on 24/01/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var activityManager = ActivityManager.shared
    
    var body: some View {
        ZStack(alignment: .center) {
            
            Color.white
            
            VStack {
                VStack(spacing: 8) {
                    Text("Activity ID:")
                        .font(.title3)
                    Text("\(activityManager.activityID ?? "-")")
                        .font(.caption2)
                    Text("Activity Token:")
                        .font(.title3)
                    Text("\(activityManager.activityToken ?? "-")")
                        .font(.caption2)
                }
                Spacer()
                
                if (activityManager.activityID?.isEmpty == false) {
                    VStack {
                    Button("UPDATE RANDOM SCORE FOR LIVE ACTIVITY") {
                        Task {
                            await activityManager.updateActivityRandomly()
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, minHeight: 70)
                    }
                    .background(Color.orange)
                    .frame(maxWidth: .infinity)
                    VStack {
                        Button("STOP LIVE ACTIVITY") {
                            Task {
                                await activityManager.cancelAllRunningActivities()
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 70)
                    }
                    .background(Color.red)
                    .frame(maxWidth: .infinity)
                }
                else {
                    VStack {
                        Button("START LIVE ACTIVITY") {
                            Task {
                                await activityManager.start()
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 70)
                    }
                    .background(Color.blue)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .onAppear(perform: {
                print("DEBUG: siuuuuuu")
            })
        }
     
    }
}
