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


# VI. GeometryReader - Global, local, custom


# VII. Understand AlignmentGuild Layout


# IX. Data Flow 

- `OnChange()`

- `OnReceive()`


# XI. Async Await and TaskGroup


## 1.1 Concurrency
1. [Getting Started with async/await in SwiftUI](https://peterfriese.dev/posts/swiftui-concurrency-essentials-part1/)
2. [How to run tasks using SwiftUI’s task() modifier](https://www.hackingwithswift.com/quick-start/concurrency/how-to-run-tasks-using-swiftuis-task-modifier)
3. [Task Groups in Swift explained with code examples](https://www.avanderlee.com/concurrency/task-groups-in-swift/)
4. [Tasks in Swift explained with code examples](https://www.avanderlee.com/concurrency/tasks/)
5. [Async await in Swift explained with code examples](https://www.avanderlee.com/swift/async-await/)