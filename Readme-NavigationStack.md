# Navigation Stack and Navigation Link

# I. NavigationLink

Về cơ bản đây là 2 cách dùng đơn giản nhất giữa `NavigationLink` và `NavigationStack`:

```swift
NavigationStack {
    NavigationLink("Navigate", value: "AppCircle")
        .navigationDestination(for: String.self) { value in
            Text("Second screen")
            Text("Value is \(value)")
    }
}
```

Output:

![](gif/simple_stack.gif)


Và 

```swift
NavigationStack {
    NavigationLink {
        Text("Siuuu")
    } label: {
        Text("Siuuuu screen")
    }
}
```

Ở đây ta có 2 kiểu sử dụng đó là `NavigationLink(value: ,label: ) + navigationDestination` và `NavigationLink(destination: , label: )`. Vậy điểm khác biệt là gì ? Điểm khác biệt là `navigationDestination` là `lazy loading`:

```swift
struct DiffView: View {
    var body: some View {
        NavigationStack {
            ForEach(0 ..< 20, id: \.self) { value in
                NavigationLink {
                    NavInitView(value: value)
                } label: {
                    Text("Click to \(value)")
                }

            }
        }

    }
}

struct NavInitView: View {
    
    let value: Int
    
    init(value: Int) {
        print("DEBUG: Init \(value)")
        self.value = value
    }
    
    var body: some View {
        Text("View \(value)")
    }
}
```

Dù ta chưa `click` vào `view nào nma tất cả các View trong NavigationLink đều đã được init` và ở dưới console in:

```
DEBUG: Init 0
DEBUG: Init 0
DEBUG: Init 1
DEBUG: Init 1
DEBUG: Init 2
DEBUG: Init 2
DEBUG: Init 3
```

Tuy nhiên khi thay thế nó bằng `navigationDestination` thì sẽ như sau:

```swift
struct DiffView: View {
    var body: some View {
        NavigationStack {
            ForEach(0 ..< 20, id: \.self) { value in
                NavigationLink(value: value) {
                    Text("Click to \(value)")
                }
                .navigationDestination(for: Int.self) { value in
                    NavInitView(value: value)
                }

            }
        }


    }
}
```

Khi `Click` vào `View` nào thì `View` đó mới được init. Best loadding

# II. Pop To Root

`NavigationStack` có 1 phương thức init chấp nhận tham số là một `array of navigation paths`. Ta có thể coi `Paths` như là một `data source representing all views in a navigation stack.`:
- To pop a view, you remove that path from the array.
- To pop to the root view, you remove everything out of that array.

```swift

struct LearnAnimationStack: View {
    @State private var path: [Int] = []
    
    var body: some View {
        
        NavigationStack(path: $path) {
            Button("Start") {
                path.append(1)

            }
            .navigationDestination(for: Int.self) { int in
                DetailView(path: $path, count: int)
            }
        }
    }
}

struct DetailView: View {

    @Binding var path: [Int]
    let count: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button("Go deeper \(count)") {
                path.append(count + 1)
            }
            .navigationBarTitle(count.description)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button("Pop to Root") {
                        path = []

                    }
                }
            }
            
            Button("Go back ") {
                path.remove(at: count - 1)
            }
            
        }

    }
}
```

Output:

![](gif/popToRoot.gif)



# II. Mastering NavigationStack



# III. Reference

1. [How to Pop to the Root view in SwiftUI](https://sarunw.com/posts/how-to-pop-to-root-view-in-swiftui/?fbclid=IwAR0kJf86XoYteFXX-P8VOU0K81FGvfx8Bai39nNeKRHzFY2CFHkmVevlK3o)
2. [Mastering NavigationStack in SwiftUI. Navigator Pattern.](https://swiftwithmajid.com/2022/06/15/mastering-navigationstack-in-swiftui-navigator-pattern/)