# LiveActivity And DynamicIsland

# I. How to build an iOS Live Activity

Một trong những tính năng quan trọng nhất được giới thiệu trong IOS 16 đó là `Live Activities`, tính năng này cho phép người dùng có thể quan sát các thông tin 1 cách real time trên `Lock Screen`

# 1.1 HOW IT WORKS

Ta có thể coi `Live Activities` như là một widget với khả năng được updated 1 cách real time. Việc update này được trigger bằng cách sử dụng 1 function trong code hoặc sử dụng push notification được gửi tới thiết bị từ backend service. Khi `Live Activitu` được started, nó sẽ được hiển thị trên lock screen, và dựa trên update push notification, nó sẽ được tự động refresh. Tuy nhiên có 1 thực tế là khi được present trên device, nó cũng được shown trên `Dynamic Island`, và trong trường hợp này `Live Activity` sẽ có 3 UI khác nhau:

- `Minimal`:  our live activity is secondary shown respect another one
- `Compact`:  our live activity is the main one shown to the user
- `Expanded`: our live activity has been expanded by the user with a long press or it has just received an update and so it has been automatically expanded by the system

`So, considering also the widget in the lock screen, we should think about designing 4 kinds of Live Activity UI.`

# 1.2 HOW TO START

Đầu tiên ta phải làm cho app chúng ta phải support `Live Activities`, ta vào file Info vào gán `Supports Live Activities` đi cùng với value là `yes`

![](Images-DynamicIsland/support_live.png)

Another thing to add to the app to make this sample code work, is adding the push notification capabilities in the Signin & Capabilities tab.

![](Images-DynamicIsland/push_notifi.png)

`NOTE`: This isn’t actually always necessary, as said a Live Activity can be updated through push notifications or just via code, but for the sake of this guide, I’m already showing how to add the capability to use the notification here. `Later on it will be more clear when you should or should not add it.`

Sau đó ta add `Widget extension` và bao gồm select `Include Live Activy`

![](Images-DynamicIsland/add_widget_extension.png)

Lúc này ta sẽ được các file sau đây:

![](Images-DynamicIsland/file_created.png)


- `MatchLiveScore:` Đây là file `Widget class` thông thường, và ta đã học rồi nên sẽ ko nói ở đây.

- `MatchLiveScoreLiveActivity`: Đây chính là file `Live Activity`, nơi ta sẽ viết vô vàn dạng UI khác nhau ở đây. Cũng ở chính file này, ta thấy 1 struct được define ở đây, chính là struct `MatchLiveScoreAttributes`:

```swift
struct MatchLiveScoreAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}
```

Đây là 1 struct cơ bản mà được sử dụng để định nghĩa các properties mà ta sẽ dụng trong `Live Activity UI`. Ở đây SwiftUI đã cho ta các comment, với property `name`, ta thấy hệ thống coi nó là 1 giá trị không thay đổi trong suốt quá trình update. Còn với `ContentState`, ta có biến `value` thuộc kiểu `Int`, đây chính là giá trị được update trong quá trình real time.

- `MatchLiveScoreBundle:` Ở đây ta sẽ quyết định cái gì sẽ được available tới user: 

```swift
@main
struct MatchLiveScoreBundle: WidgetBundle {
    var body: some Widget {
        MatchLiveScore()
        MatchLiveScoreLiveActivity()
    }
}
```

- `MatchLiveScore()`: this is the normal widget, the one that you can implement inside the homonym file MatchLiveScore.swift
- `MatchLiveScoreActivity()`: this is the live activity widget that we are going to implement in our app.
# V. Reference

1. [How to build an iOS Live Activity](https://medium.com/kinandcartacreated/how-to-build-ios-live-activity-d1b2f238819e)