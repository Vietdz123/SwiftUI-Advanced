# Các vấn đề giải quyết trong Repo này


# Starting:

- Understand `viewModifier` của `View`, của `Font`.... : func, static func return some view,...

# I. Navigation Stack

Tìm hiểu mối liên hệ giữa `NavigationStack` với `NavigationLink` và `NavigationPath`
- Khi ta sử dụng `.navigationDestination` để push qua màn mới sẽ làm tăng `NavigationPath`, vậy sử dụng `NavigationLink(isPresented:)` thì có thế hay không ? (Câu hỏi này sẽ liên kết với `#2` bên dưới).
- Ta biết rằng khi sử dụng `Router` để chuyển màn thì khá dễ dàng, vậy khi ta muốn sử dụng 1 cách mới đó là sử dụng 2 kiểu dữ liệu khác nhau như `Int và String` để push qua 2 màn controller khác nhau thì sẽ thế nào ? Nâng cao hơn đó là sử dụng 2 kiểu dữ liệu này ở 2 bên TapBar thì có chạy không, bởi vì trước đây tôi làm thì nó ko chạy và ko hiểu tạo sao.

- Điều gì xảy ra khi ta lông 2 `NavigationStack` cho nhau.


# II. Đẩy thông tin từ UIKit ra SwiftUI

Giờ ta có bên ngoài là 1 `SwfitUI View`, chứa bên trong là 1 component là `UIKit`(sử dụng `UIRespenableController` để làm), vậy có cách nào khi nhấn 1 `UIButton` hay thực hiện 1 action thì ta sẽ bắn action đó ra cho View SwiftUI thực hiện:
- Ví dụ khi ta nhấn `UIButton`, thì ta sẽ pass 1 image ra cho `Swiftui View`, thì ta có thể sử dụng `binding`, cái này basic vl. 
- Vấn đề lớn hơn, là trong `UIKit` có 1 nút `Button Done`, khi nhấn `Button` đó thì`SwiftUI View` sẽ push qua màn mới, vậy thì có cách nào để làm việc này. Nếu ta sử `NavigationLink(isPresented:)`  thì `binding` qua 1 biến `@State var presented` thì khá đơn giản. Nhưng ở đây là ta ko muốn sử dụng `NavigationLink(isPresented)`, cái ta muốn sử dụng là `navigationDestination()`.

# III. How to know order of modifier

- Hiểu rõ order of modifier
- Xét `frame(maxwidth, maxheight)` sau đó xét `padding` khác thế nào giữa xét `padding` xong xét `frame(maxwidth, maxheight)`. Tương tự với xét `frame(width, height)` sau đó xét `padding`.

# IV. Tap Are Gesture

- Hiểu về vùng nhấn của `Button` và của 1 View và `TapGesture`. `Offset` sẽ ảnh hưởng thế nào lên `Tap Are Gesture` đó.


# V. Understand PreferenKey and when to use it


# VI. GeometryReader - Global, local, custom and GeometryReader + ScrollView

Done


# VII. Understand AlignmentGuild Layout


# IX. Data Flow 

- `OnChange():`
- `OnReceive()`

## 9.1 OnChange()

Trong SwiftUI, ta gần như không thể sử dụng `property observer` như `didSet` với các biến như `@State`. Vì vậy thằng `SwiftUI` cung cấp cho ta 1 modifier khác để track sự thay đổi này, đó là `onChange()`.

**Important**: This behavior is changing in iOS 17 and later, with the older behavior being deprecated.

- If you need to target iOS 16 and earlier, `onChange()` chấp nhận 1 parameter và gửi new value vào parameter của closure đó. ` For example, this will print name changes as they are typed:`

```swift
struct ContentView: View {
    @State private var name = ""

    var body: some View {
        TextField("Enter your name:", text: $name)
            .textFieldStyle(.roundedBorder)
            .onChange(of: name) { newValue in
                print("Name changed to \(name)!")
            }
    }
}
```

Mỗi khi gõ text mới cho textField, thì nó sẽ vào `onChange()`

- If you’re targeting iOS 17 or later, nó sẽ nhận 2 parameter mới cho newValue và oldValue:

```swift
struct ContentView: View {
    @State private var name = ""

    var body: some View {
        TextField("Enter your name", text: $name)
            .onChange(of: name) { oldValue, newValue in
                print("Changing from \(oldValue) to \(newValue)")
            }
    }
}
```

Tuy nhiên với trong trường hợp này `onChaneg(of: )` chỉ trigger action khi `name` thay đổi, đôi khi ta muốn nó trigger value luôn ngay khi khởi tạo thì ta sẽ sử dụng `initial: true` như sau:

```swift
struct ContentView: View {
    @State private var name = ""

    var body: some View {
        TextField("Enter your name", text: $name)
            .onChange(of: name, initial: true) {
                print("Name is now \(name)")
            }
    }
}
```

Đôi khi, ta muốn thêm 1 custom extension vào `Binding` để phát hiện sự thay đổi của chính biến `Binding` dó, thay vì phải đính nó vào `View`.

```swift
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

struct ContentView: View {
    @State private var name = ""

    var body: some View {
        TextField("Enter your name:", text: $name.onChange(nameChanged))
            .textFieldStyle(.roundedBorder)
    }

    func nameChanged(to value: String) {
        print("Name changed to \(name)!")
    }
}
```


# X. Async Await and TaskGroup

OK Done

#  XI. Property Wrapper

OK Done

OK Done

# XII. EquatableView

SwiftUI provides us a very fast and easy to use `diffing algorithm`, but as you might know, `diffing is a linear operation.` Vì vậy thuật toán diffing sẽ rất nhanh trong các trường hợp layout đơn giản và sẽ khá châmh với các trường hợp layout phức tạp. Tuy nhiên, SwiftUI cho phép ta thay thế diffing alogorithm với custom logic của ta. ` This week we will talk about optimizing our SwiftUI layouts using the equatable modifier.`

## 12.1 Diffing in SwiftUI

As you remember, we already talked about `diffing in SwiftUI`, but let me remind how it works. Bất cứ khi nào ta thay đổi `source of truth` cho views của mình như `@State or @ObservableObject`,.. SwiftUI sẽ `run body property of your view to generate a new one`. As the last step, SwiftUI renders a new view if something changed. The process of calculating a new body depends on how deep is your view hierarchy. Happily, we can replace SwiftUI diffing with our simplified version whenever we know the better way to determine changes.

## 12.2 EquatableView

Đôi khi chúng ta ko muốn sử dụng thuật toán diffing của SwiftUI, hoặc đôi khi ta muốn ignore some changes in data, and this is the exact place where we can use the `EquatableView` struct.


# XIII. ViewModifier


# XIV. LazyVGrid and LazyHGrid 

Done

# XIII. LiveActivity

# X. Reference

## 10.1 Async Await
1. [Getting Started with async/await in SwiftUI](https://peterfriese.dev/posts/swiftui-concurrency-essentials-part1/)
2. [How to run tasks using SwiftUI’s task() modifier](https://www.hackingwithswift.com/quick-start/concurrency/how-to-run-tasks-using-swiftuis-task-modifier)
3. [Task Groups in Swift explained with code examples](https://www.avanderlee.com/concurrency/task-groups-in-swift/)
4. [Tasks in Swift explained with code examples](https://www.avanderlee.com/concurrency/tasks/)
5. [Async await in Swift explained with code examples](https://www.avanderlee.com/swift/async-await/)

## 10.2 EquatableView
1. [Optimizing views in SwiftUI using EquatableView](https://swiftwithmajid.com/2020/01/22/optimizing-views-in-swiftui-using-equatableview/)

