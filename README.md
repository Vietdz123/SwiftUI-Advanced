# SwiftUI-Advanced

# I. Custom Button Style

Được sử dụng để custom action khi press Button và sth :))

```swift
struct ButtonStyleCustom: ButtonStyle {
    
    let background: Color
    
    init(background: Color = .red) {
        self.background = background
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? background : .yellow)
            .scaleEffect(configuration.isPressed ? 0.5 : 1.0)
            
    }
    
}


struct ButtonStyleView: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            Text("Click Me")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .cornerRadius(20)
                .background(.blue)
                .cornerRadius(20)
                .padding()
                
        })
        .buttonStyle(ButtonStyleCustom(background: .red))
    }
}
```

![](gif/styleButton.gif)

# II. Custom AnyTransition

Được sử dụng để custom 1 View biến mất hay xuất hiện, dưới đây là ta sử dụng `transition(.move)` của hệ thống:

```swift
struct CustomTransition: View {
    
    @State private var showRec = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            
            if showRec {
                Rectangle()
                    .fill(.red)
                    .frame(width: 300, height: 200)
                    .transition(.move(edge: .leading))
                    .padding(.top, 200)
            }

                
            Spacer()
            
            Button(action: {
                withAnimation(.easeOut) {
                    showRec.toggle()
                }
            }, label: {
                Text("Click Me")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .cornerRadius(20)
                    .background(.blue)
                    .cornerRadius(20)
                    .padding()
                    
            })
            .buttonStyle(ButtonStyleCustom(background: .red))
            .padding()
        }
    }
}

```

Output:

![](gif/transition_default.gif)

Bây giờ ta sẽ tự triển khai `custom transition`:


```swift
struct RotateViewModifier: ViewModifier {
    
    let rotation: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotation))
            .scaleEffect(rotation != 0 ? 2 : 1)
    }
    
}


extension AnyTransition {
    
    static var rotatingCustom: AnyTransition {
        return AnyTransition.modifier(active: RotateViewModifier(rotation: 100),
                                      identity: RotateViewModifier(rotation: 0))
    }
    
}


struct CustomTransition: View {
    
    @State private var showRec = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            
            if showRec {
                Rectangle()
                    .fill(.red)
                    .frame(width: 300, height: 200)
                    .transition(AnyTransition.rotatingCustom)
                    .padding(.top, 200)
            }

                
            Spacer()
            
            Button(action: {
                withAnimation(.easeOut) {
                    showRec.toggle()
                }
            }, label: {
                Text("Click Me")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .cornerRadius(20)
                    .background(.blue)
                    .cornerRadius(20)
                    .padding()
                    
            })
            .buttonStyle(ButtonStyleCustom(background: .red))
            .padding()
        }
    }
}

```

Output:

![](gif/transition_custom.gif)

Về cơ bản ta hiểu là mỗi khi view được xuất hiện hoặc biến mất, thì nó sẽ gọi vào `modifier .transition`, ở đây ta triển khai `rotatingCustom` có `identity` và `active`. `identity` là modifier sau khi đã thực hiện xong quá trình `transition` còn `active` là modifier trong quá trình transition. 

# III. How to use @ViewBuilder in SwiftUI 

Để hiểu về `@ViewBuilder`, ta cần hiểu về `generic`. Giờ ta muốn struct comform `View`, trong đó có 1 parameter `content`, `content` là kiểu generic mà có thể pass bất kì `View` nào vào trong, ta làm như sau:

```swift
struct GenericstructView<CustomType: View>: View {
    
    var content: CustomType
    
    var body: some View {
        content
    }
    
}
```

Lúc này khi sử dụng View đó sẽ như thế này 

```swift
struct ViewBuilderView: View {
    var body: some View {
        GenericstructView(content: HStack(content: {
            Text("Placeholder")
        }))
    }
}
```

Bạn thấy không, nó nhấn rất là rồi mắt, giờ ta mong muốn đoạn `content` đó sẽ được pass như các view khác như `HStack { Text("Placeholder") }`. Để làm được điều này, ta sẽ sử dụng `@ViewBuilder`:


```swift
struct GenericstructView<CustomType: View>: View {
    
    var content: CustomType
    
    init( @ViewBuilder content: () -> CustomType) {
        self.content = content()
    }
    
    var body: some View {
        content
    }
    
}


struct ViewBuilderView: View {
    var body: some View {
        GenericstructView {
            HStack(content: {
                Text("Placeholder")
            })
        }
    }
}

```