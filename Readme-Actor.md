# Actor SwiftUI

`Data races` xảy ra khi 2 hay nhiều Thread cùng truy cập vào cùng 1 địa chỉ bộ nhớ, và có ít nhất 1 action là write. `Actor` protect their state from data races. 

```swift
actor ChickenFeeder {
    let food = "worms"
    var numberOfEatingChickens: Int = 0
}
```

Actors are like other Swift types as they can also have initializers, methods, properties, and subscripts, while you can also use them with protocols and generics. `Lastly, it’s important to realize actors are reference types.`

# I. Actors in Swift: how to use and prevent data races

## 1.1 Actors are reference types but still different compared to classes

Actors are reference types which in short means that copies refer to the same piece of data. Therefore, modifying the copy will also modify the original instance as they point to the same shared instance. Tuy nhiên **Actors have an important difference compared to classes: they do not support inheritance.**

`Not supporting inheritance means there’s no need for features like the convenience and required initializers, overriding, class members, or open and final statements.`

Tuy nhiền, điểm khác biệt lớn nhất đó là khả năng `isolating access to data`.


## 2.1 How Actors prevent Data Races with synchronization

`Actor` ngăn chặn `data races` bằng cách khởi tạo một cơ chế truy cập đồng bộ cho `isolated data` của nó. 

```swift
actor ChickenFeeder {
    let food = "worms"
    var numberOfEatingChickens: Int = 0
    
    func chickenStartsEating() {
        numberOfEatingChickens += 1
    }
    
    func chickenStopsEating() {
        numberOfEatingChickens -= 1
    }
}
```

Ta thấy rằng đoạn code này khá là đơn giản và dễ đọc, bởi vì mọi logic liên quan tới ` synchronizing access` đều được ẩn đi bởi Swift Library. Tuy nhiên khi ta cố `đọc` bất cứ diệu nào của `mutable property` hoặc method đều sẽ bị lỗi:

```swift
let feeder = ChickenFeeder()
feeder.chickenStartsEating()    ///Error
feeder.numberOfEatingChickens   ///Error    
```

Tuy nhiên, ta được cho phép:

```swift
let feeder = ChickenFeeder()
print(feeder.food) 
```

Bởi vì `food` là một property trong checkenFeeder là `let`, nghĩa là imumutable, vì vậy nó là `thread-safe`. Vì vậy nó sẽ không có rủi ro xảy ra hiện tượng `data race`.


## 1.3 Using async/await to access data from Actors

Ta không biết chắc rằng khi nào việc truy cập được cho phép, chúng ta cần phải tạo  asynchronous access to our Actor’s mutable data. Há, tại sao lại là `asynchronous access?`. Đó là bởi vì cơ chế của `actor` và `await`. 

```swift
let feeder = ChickenFeeder()
Task {
    await feeder.chickenStartsEating()
    print(await feeder.numberOfEatingChickens) // Prints: 1 
}
```

Với đoạn code này, khi ko có 1 thằng nào thread nào access the data, chúng ta sẽ được phép truy cập trực tiếp vào data. Nếu có thằng Thread nào đang truy cập vào data, ta bắt buộc phải chờ cho đến khi thread đó thực thi xong, và việc chờ đó được đánh dấu bằng `await`. Vì vậy việc truy cập vào data là sync, và thông qua `Actor`, ta đã tránh được việc tạo ra `race condition`.

```swift
let feeder = ChickenFeeder()

Task {
    await feeder.chickenStartsEating()
    print(await feeder.numberOfEatingChickens) // Prints: 1 
}
```

# II. MainActor usage in Swift explained to dispatch to the main thread

When building apps, it’s essential to perform UI updating tasks on the main thread, which can sometimes be challenging when using several background threads. Using the `@MainActor` attribute will help ensure your UI is always updated on the main thread.

## 2.1 Understanding Global Actors

Before we dive into how to use the MainActor in your code, it’s important to understand the concept of global actors. Ta có thể hiểu đơn giản `Global Actor` như là một `Singleton`: nghĩa là chỉ 1 instance tồn tại. 


```swift
@globalActor
actor SwiftLeeActor {
    static let shared = SwiftLeeActor()
}
```

Biến `shared` property là một yêu cầu của `GlobalActor` protocol và đảm bảo rằng chỉ có 1 global unique actor instance. Khi define, ta có thể sử dụng global actor xuyên suốt project:

```swift
@SwiftLeeActor
final class SwiftLeeFetcher {
    // ..
}
```

Bất cứ đâu ta sử dụng global actor attribute, ta sẽ đảm bảo rằng việc đồng bộ hóa dữ liệu thông qua shared actor instance. The underlying @MainActor implementation is similar to our custom-defined @SwiftLeeActor:

```swift
@globalActor
final actor MainActor: GlobalActor {
    static let shared: MainActor
}
```

It’s available by default and defined inside the concurrency framework. Điều đó có nghĩa là ta có thể bắt đầu sử dụng `global actor` ngay lập tức và mark your code để đảm bảo việc code được thực thi trên main thread bằng cách đồng bộ thông qua `global actor`.

## 2.2 How to use MainActor in Swift?

Ta có thể add `@MainActor` attribute vào 1 viewmodel để thực thi mọi task đều trên main thread.

```swift
@MainActor
final class HomeViewModel {
    // ..
}
```

Bằng cách sử dụng [nonisolated](https://www.avanderlee.com/swift/actors/#nonisolated-access-within-actors), chúng ta đảm bảo rằng các methods mà không cần đợi main thread để được thực thi sẽ thực thi ngay khi có thể bằng cách not waiting for the main thread to become available. 

`Explain`: Đoạn trên có ý là, khi 1 class được đánh dấu là `@MainActor`, điều đó có nghĩa là mọi method của nó sẽ được thực thi trên main thread. Mà ta biết rằng, main thread là serial queue, nghĩa là nó thực thi hết đoạn code này thì mới thực thi đoạn code khác. Tuy nhiên trong class ta có một vài biến ko liên quan tới `UI`, nghĩa là nó ko cần thiết phải thực thi trên main thread. Vì vậy ta muốn truy cập vào biến đó mà ko cần đánh dấu là await, thì ta sẽ truy cập nó thông qua `nonisolated func` đã nói trên kia.

- Đôi khi ta chỉ muốn đánh dấu 1 biến là 1 `global actor`, Marking the images property with the @MainActor property ensures that it can only be updated from the main thread:

```swift
final class HomeViewModel {
    
    @MainActor var images: [UIImage] = []

    func updateImage() {
        images = []     ///Error
    }

}
```

Ta thấy rằng đoạn code trên lỗi, bởi vì thằng `images` được mark là `@MainActor`, nghĩa là nó phải được truy cập trên main thread, tuy nhiên thằng `func updateImage()` trong trường hợp trên có thể được gọi ở bất cứ đâu, dẫn đến lỗi. Để có thể giải quyết vấn đề này, ta cũng đánh dấu luôn func `updateImage()` là `@MainActor` để chị định rằng func này sẽ được thực thi trên main thread.

```swift
@MainActor func updateViews() {
    // Perform UI updates..
}
```

Ta thậm chí có thể đánh dấu 1 closure là `@MainActor` để chị định nó được thực thi trên main.

```swift
func updateData(completion: @MainActor @escaping () -> ()) {
    Task {
        await someHeavyBackgroundOperation()
        await completion()
    }
}
```

Although in this case, you should rewrite the updateData method to an async variant without needing a completion closure.


## 2.3 Using the main actor directly

The MainActor in Swift comes with an extension to use the actor directly:

```swift
extension MainActor {

    /// Execute the given body closure on the main actor.
    public static func run<T>(resultType: T.Type = T.self, body: @MainActor @Sendable () throws -> T) async rethrows -> T
}
```

This allows us to use the MainActor directly from within methods, even if we didn’t define any of its body using the global actor attribute:

```swift
Task {
    await someHeavyBackgroundOperation()
    await MainActor.run {
        // Perform UI updates
    }
}
```

In other words, there’s no need to use `DispatchQueue.main.async` anymore. However,` I do recommend using the global attribute to restrict any access to the main thread`. Without the global actor attribute, anyone could forget to use MainActor.run, potentially leading to UI updates taking place on a background thread.

- Đoạn dưới ảo vlonnn:

```swift
@MainActor
func fetchImage(for url: URL) async throws -> UIImage {
    let (data, _) = try await URLSession.shared.data(from: url)
    guard let image = UIImage(data: data) else {
        throw ImageFetchingError.imageDecodingFailed
    }
    return image
}
```

**The @MainActor attribute ensures the logic executes on the main thread while the network request is still performed on the background queue**. Dispatching to the main actor only takes place if needed to ensure the best performance possible. Vlon ảo ác, nó thông mình thế :)))













# V. Reference

1. [Actors in Swift: how to use and prevent data races](https://www.avanderlee.com/swift/actors/)
2. [MainActor usage in Swift explained to dispatch to the main thread](https://www.avanderlee.com/swift/mainactor-dispatch-main-thread/#continuing-your-journey-into-swift-concurrency)













# V. Reference