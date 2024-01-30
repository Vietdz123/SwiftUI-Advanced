# Device Information - Battery Information And CPU Information

# I. Get Battery Information

```swift
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
```