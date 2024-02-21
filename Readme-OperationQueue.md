# Operation Queue

`OperationQueue` là `một queue mà regulates(điều chỉnh) việc thực thi của các operations`.  `Operations` là một abstract class  mà đại diện cho phần code và data được đính với 1 task. Nghĩa là ở đây, ta có 1 `Queue` và các `operations` mà ta add vào `queue`. Một trong những ví dụ cụ thể trong việc sử dụng `OperationQueue` đó là ta có 1 async processing, và ta muốn sau khi nó kết thúc, thì ta sẽ trigger 1 hành động async khác,... Hãy nhìn đoạn code này:

```swift
let operation1 = BlockOperation { //1
    for x in 0...5 {
        print(x)
    }
}

let operation2 = BlockOperation { //1
    for x in 11...15 {
        print(x)
    }
}

let operation3 = BlockOperation { //1
    for x in 21...25 {
        print(x)
    }
}

let operationQueue = OperationQueue() //2

operationQueue.addOperations([operation1,operation2,operation3], waitUntilFinished: false) //3

print("DEBUG: siuuuuu")
```

Output:

```php
DEBUG: siuuuuu
0
21
11
1
22
2
12
3
23
13
4
14
24
15
5
25
```

Ta thấy rằng (1) là cách ta tạo ra 1 Operation Class. By default, `OperationBlock` không phải là 1 asynchronous, vì vậy ta phải đặt nó vào bên trong `OpeationQueue` để xử lý không đồng bộ. Và ta thấy kết quả in ra là 1 kết quả bất đồng bộ. Thuộc tính `waitUntilFinished` chỉ định rằng nó sẽ block ở đó cho đến khi thực thi hết hay không. Ở trên vì ta xét là `false` nên nó ko block ở đó và print `DEBUG: siuuuu` ra trước.

- Tuy nhiên kết quả vẫn chưa như ta mong muốn, nên ta tiếp tục tới phần II.

# II. Asynchronous Dependency Graph using OperationQueue in Swift

```swift
let operation1 = BlockOperation {
    for x in 0...5 {
        print(x)
    }
}

let operation2 = BlockOperation {
    for x in 11...15 {
        print(x)
    }
}
operation2.addDependency(operation1) // 1


let operation3 = BlockOperation {
    for x in 21...25 {
        print(x)
    }
}
operation3.addDependency(operation1) // 1


let operationQueue = OperationQueue()

operationQueue.addOperations([operation1,operation2,operation3], waitUntilFinished: false)
```

Output:

```php
0
1
2
3
4
5
21
11
22
12
23
13
14
24
15
25
```

Ta thấy sau khi `operation1` kết thúc thì `operation2` và `operation3` mới bắt đầu thực thi.


# III. Tweaking OperationQueues (Tinh chỉnh OperationQueues)

The `maxConcurrentOperationCount` property of the queue can give you control on guess what? How many concurrent operations you can have each time. So imagine that you have 3 items in the queue like the example above, if you set this property to 2, they will run two random operations at a time, and only when one of the finishes it works it will initiate the third one.

```swift
let operation1 = BlockOperation {
    for x in 0...6 {
        print(x)
    }
}


let operation2 = BlockOperation {
    for x in 11...15 {
        print(x)
    }
}

let operation3 = BlockOperation {
    for x in 21...25 {
        print(x)
    }
}

let operationQueue = OperationQueue()

operationQueue.maxConcurrentOperationCount = 2 // this property

operationQueue.addOperations([operation1,operation2,operation3], waitUntilFinished: false)
```

Output:

```php
0
11
1
12
2
13
14
3
15
4
21
5
22
6
23
24
25
```

# IV. Cancelling Operations

Không giống như `DispatchQueue`, ta có thể `cancel operations`. Nếu việc thực thi `operation` vẫn đang `pending`, ta có thể `cancel()` chúng, về thực tế việc `cancel` sẽ không được thực thi, mà chúng sẽ được đánh dấu là `completed`. Và vì như vậy, nếu 1 operation B phụ thuộc vào operation A, thì nếu operation A bị cancel thì operationB sẽ được thực thi ngay lập tức.
.






































# IV. Reference

1. [Operation](https://developer.apple.com/documentation/foundation/operation)
2. [OperationQueue](https://developer.apple.com/documentation/foundation/operationqueue)
3. [OperationQueue in Swift](https://holyswift.app/operationqueues-in-swift-more-control-to-your-async-operations-with-asynchronous-dependency-graph/)
4. [Adding Dependency](https://www.swiftpal.io/articles/concurrency-programming-with-operation-queue-part-two)