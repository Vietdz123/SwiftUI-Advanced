# Async Await TaskGroup

# I Tasks in Swift explained

- `Async` viết tắt của `asynchronous`, nó là 1 attribute dùng để đánh dấu 1 func sẽ thực thi các công việc 1 cách bất đồng bộ.
- `Await` là 1 từ khóa được sử dụng cho việc calling 1 async func.

```swift
func fetchImages(completion: ([UIImage]?, Error?) -> Void) {
    // .. perform data request
}

do {
    let images = try await fetchImages()
    print("Fetched \(images.count) images.")
} catch {
    print("Fetching images failed with error \(error)")
}
```

Bằng cách sử dụng từ khóa `await`, we tell our program to await a result from the `fetchImages` method and **only continue after a result arrived**.

- How to create and run a Task

```swift
let basicTask = Task {
    return "This is the result of the task"
}
print(await basicTask.value)
// Prints: This is the result of the task
```

As you can see, we’re keeping a reference to our basicTask which returns a string value. We can use the reference to read out the outcome value. Ta cũng thấy rằng `A task runs immediately after creation and does not require an explicit start`.

- How to cancel a Task:

```swift

struct ContentView: View {
    @State var image: UIImage?

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
            } else {
                Text("Loading...")
            }
        }.onAppear {
            Task {
                do {
                    image = try await fetchImage()
                } catch {
                    print("Image loading failed: \(error)")
                }
            }
        }
    }

    func fetchImage() async throws -> UIImage? {
        let imageTask = Task { () -> UIImage? in
            let imageURL = URL(string: "https://source.unsplash.com/random")!
            print("Starting network request...")
            let (imageData, _) = try await URLSession.shared.data(from: imageURL)
            return UIImage(data: imageData)
        }
        // Cancel the image request right away:
        imageTask.cancel()
        return try await imageTask.value
    }
}
```

The cancellation call above is enough to stop the request from succeeding since the URLSession implementation performs cancellation checks before execution. Therefore, the above code example is printing out the following:

```php
Starting network request...
Image loading failed: Error Domain=NSURLErrorDomain Code=-999 "cancelled"
```

Ta thường kết hợp với lệnh `try Task.checkCancellation()` để kiểm tra Task bị cancel hay chưa như sau:

```swift
let imageTask = Task { () -> UIImage? in
    let imageURL = URL(string: "https://source.unsplash.com/random")!

    // Check for cancellation before the network request and Throw an error if the task was already cancelled.
    try Task.checkCancellation()
    print("Starting network request...")
    let (imageData, _) = try await URLSession.shared.data(from: imageURL)

    // Check for cancellation after the network request
    // to prevent starting our heavy image operations.
    try Task.checkCancellation()

    let image = UIImage(data: imageData)

    // Perform image operations since the task is not cancelled.
    return image
}
```

Ta thấy rằng khi gặp thằng `try Task.checkCancellation()`, nó sẽ throw lỗi ngay lập tức và ko thực hiện thêm thông tin gì, ta có thể sử dụng 1 cách khác để đưa thêm thông tin khi Task bị cancel như sau:

```swift
let imageTask = Task { () -> UIImage? in
    let imageURL = URL(string: "https://source.unsplash.com/random")!

    guard Task.isCancelled == false else {
        // Perform clean up
        print("Image request was cancelled")
        return nil
    }

    print("Starting network request...")
    let (imageData, _) = try await URLSession.shared.data(from: imageURL)
    return UIImage(data: imageData)
}
// Cancel the image request right away:
imageTask.cancel()
```

# II. Task Groups in Swift explained

Task Group cho phép ta combine multiple parallel tasks và chờ cho tất cả các Tasks hoàn thành xong mới làm việc gì đó(Giống DispatchGroup). They are commonly used for tasks like combining multiple API request responses into a single response object.

## 2.1 What is TaskGroup

Ta có thể coi `TaskGroup` như là một container của một vài child Tasks. Child Tasks có thể chạy trong song song hoặc serial, nhưng Task Grourp chỉ có thể được đánh dấu là finish khi tất cả các child task của nó thực thi xong. 

```swift
await withTaskGroup(of: UIImage.self) { taskGroup in
    let photoURLs = await listPhotoURLs(inGallery: "Amsterdam Holiday")
    for photoURL in photoURLs {
        taskGroup.addTask { await downloadPhoto(url: photoURL) }
    }
}
```

Ví dụ trên cho phép ta downloading một vài images từ url. `The withTaskGroup method will return once all photos are downloaded.`

## 2.2 How to use a Task Group

Ta có thể nhóm các Tasks theo các cách khác nhau, bao gồm cả việc handling errors hoặc returning the final collection of results. 

- Returning the final collection of results

```swift
let images = await withTaskGroup(of: UIImage.self, returning: [UIImage].self) { taskGroup in
    let photoURLs = await listPhotoURLs(inGallery: "Amsterdam Holiday")
    for photoURL in photoURLs {
        taskGroup.addTask { await downloadPhoto(url: photoURL) }
    }

    var images = [UIImage]()
    for await result in taskGroup {
        images.append(result)
    }
    return images
}
```

Phân tích:
- ở đây ta có vòng for này `for await result in taskGroup`, bạn thấy chữ `await result` không, đây ám chỉ là result của mỗi `Child Task`, và kiểu dữ liệu return của `child Task` được xác định theo parameter `of: `.
- Cuối cùng ta thấy Task Group return lại images thông qua đoạn code `return images`, và kiểu dữ liệu return của cả `Task Group` được xác định thông qua parameter `returning: `.

Ta có một cách viết khác như sau:

```swift
 func printMessage() async {
    let string = await withTaskGroup(of: String.self) { group -> String in
        group.addTask { "Hello" }
        group.addTask { "From" }
        group.addTask { "A" }
        group.addTask { "Task" }
        group.addTask { "Group" }

        var collected = [String]()

        for await value in group {
            collected.append(value)
        }

        return collected.joined(separator: " ")
    }

    print(string)
}

await printMessage()
```

- Handling errors by using a throwing variant(khác nhau):

It’s common for image downloading methods to throw an error on failure. We can rewrite our example to handle these cases by renaming `withTaskGroup()` to `withThrowingTaskGroup()`:

```swift
let images = try await withThrowingTaskGroup(of: UIImage.self, returning: [UIImage].self) { taskGroup in
    let photoURLs = try await listPhotoURLs(inGallery: "Amsterdam Holiday")
    for photoURL in photoURLs {
        taskGroup.addTask { try await downloadPhoto(url: photoURL) }
    }

    return try await taskGroup.reduce(into: [UIImage]()) { partialResult, name in
        partialResult.append(name)
    }
}
```

Tuy nhiên với đoạn code trên thì `TaskGroup` của ta sẽ không failed nếu chỉ 1 Child Task của ta throw an error. Để có thể đánh dấu `TaskGroup` failed khi có bất kì Child Task nào throw error, ta sẽ sử dụng `next()`:

```swift
let images = try await withThrowingTaskGroup(of: UIImage.self, returning: [UIImage].self) { taskGroup in
    let photoURLs = try await listPhotoURLs(inGallery: "Amsterdam Holiday")
    for photoURL in photoURLs {
        taskGroup.addTask { try await downloadPhoto(url: photoURL) }
    }

    var images = [UIImage]()

    /// Note the use of `next()`:
    while let downloadImage = try await taskGroup.next() {
        images.append(downloadImage)
    }
    return images
}
```

The `next()` method receives errors from individual tasks, allowing you to handle them accordingly. In this case, we forward the error to the group closure, **making the entire task group fail**. `Any other running child tasks will be canceled at this point.`

- Cancellations in groups:

You can cancel a group of tasks by canceling the task it’s running in or by calling the `cancelAll()` method on the group itself.

When tasks are added to a canceled group using the `addTask()`, they’ll be canceled directly after creation. It will stop its work directly depending on whether that task respects cancelation correctly. Optionally, you can use `addTaskUnlessCancelled()` to prevent the task from starting.


# III. Async let explained: call async functions in parallel

`Async let` là một phần của Swift’s concurrency framework, nó cho phép ta khởi tạo một constant một cách bất đồng bộ.

## 3.1 How to use async let

When explaining how to use async let, it’s more important to know when to use async let. I’m going to take you through code examples that make use of an asynchronous method to load a random image:

```swift
func loadImage(index: Int) async -> UIImage {
    let imageURL = URL(string: "https://picsum.photos/200/300")!
    let request = URLRequest(url: imageURL)
    let (data, _) = try! await URLSession.shared.data(for: request, delegate: nil)
    print("Finished loading image \(index)")
    return UIImage(data: data)!
}
```

Without `async let` we would call this method as follows:

```swift
func loadImages() {
    Task {
        let firstImage = await loadImage(index: 1)
        let secondImage = await loadImage(index: 2)
        let thirdImage = await loadImage(index: 3)
        let images = [firstImage, secondImage, thirdImage]
    }
}
```

This way, we tell our application to wait for the first image to be returned until it can continue to fetch the second image. All images are loaded in sequence, and we will always see the following order being printed out in the console:

```php
Finished loading image 1
Finished loading image 2
Finished loading image 3
```

Đầu tiên, ta thấy rằng việc này tương đối ổn, nhưng mà đel, đầu tiên ta phải request xong image 1, sau đó mới request image 2, rồi sau đó là 3. Ta bây giờ muốn nó request 3 image 1 cách đồng thời. Vì vậy ta sẽ sử dụng `async let` như sau:

```swift
func loadImages() {
    Task {
        async let firstImage = loadImage(index: 1)
        async let secondImage = loadImage(index: 2)
        async let thirdImage = loadImage(index: 3)
        let images = await [firstImage, secondImage, thirdImage]
    }
}
```

There are a few important parts to point out:
- Our array of images now needs to be defined using the `await` keyword as we’re dealing with asynchronous constants.
- Việc thực thi sẽ thực thi ngay lập tức khi ta khai báo `async let`. 
- The last point basically means that `one of the images could already be downloaded by your app before it’s even been awaited in the array`. Vì 3 đoạn code này chạy song song với nhau, dẫn đến out put print ra sẽ giống async và ko đoán trước được thứ tự:

```php
Finished loading image 3
Finished loading image 1
Finished loading image 2
```

- When to use async let?:

Ta thấy rằng thằng `async let` không block thread hiện tại(giống như đẩy code vào queue khác xong async queue đó). Điều đó có nghĩa là ta sẽ sử dụng `async let` khi đoạn code sau ko phụ thuộc vào kết quả của `async let`. Nếu đoạn code sau mà phụ thuộc vào kết quả của đoạn code trước, thì ta phải sử dụng `await` để đợi giá trị trả về của `await`.

- Can I declare async let at top level?: Câu trả lời là `Không` luôn.

```swift
final class ContentViewModel: ObservableObject {
    
    async let firstImage = await loadImage(index: 1)  ////Error

    // .. rest of your code
}
```

`‘async let’ can only be used on local declarations`, điều này có nghĩa ta chỉ có thể sử dụng `async let` trong việc khai báo local của 1 method.








# V. Reference

1. [Getting Started with async/await in SwiftUI](https://peterfriese.dev/posts/swiftui-concurrency-essentials-part1/)
2. [How to run tasks using SwiftUI’s task() modifier](https://www.hackingwithswift.com/quick-start/concurrency/how-to-run-tasks-using-swiftuis-task-modifier)
3. [Task Groups in Swift explained with code examples](https://www.avanderlee.com/concurrency/task-groups-in-swift/)
4. [Tasks in Swift explained with code examples](https://www.avanderlee.com/concurrency/tasks/)
5. [Async await in Swift explained with code examples](https://www.avanderlee.com/swift/async-await/)
6. [Async let explained: call async functions in parallel](https://www.avanderlee.com/swift/async-let-asynchronous-functions-in-parallel/)