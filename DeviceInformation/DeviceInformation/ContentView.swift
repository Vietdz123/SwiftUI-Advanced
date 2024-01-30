//
//  ContentView.swift
//  DeviceInformation
//
//  Created by MAC on 29/01/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var infomationBattery: Float = 0
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("\(infomationBattery)%")
        }
        .onAppear(perform: {
            UIDevice.current.isBatteryMonitoringEnabled = true
            infomationBattery = UIDevice.current.batteryLevel * 100
        })
        .padding()
    }
}

