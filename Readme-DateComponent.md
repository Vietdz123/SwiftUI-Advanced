# Readme DateComponent

`Date` là 1 struct để đại diện cho một thời điểm cụ thể, tuy nhiên nó khá là khó dùng khi ta muốn chỉnh sửa thời điểm đó. Ví dụ ta muốn lấy được cũng 1 ngày nhưng mà là ở tháng sau, thì với `Date` ta phải làm như sau:

```swift
let date = Date()
let nextWeek = date.addingTimeInterval(60 * 60 * 24 * 30) // <1>
```

Tuy nhiên điều này thường ko đúng, bởi vì ko phải tháng này cũng có 30 ngày. Vì vậy ta sẽ sử dụng `DateComponent` cho trường hợp này. Để sử dụng `DateComponent`, đầu tiên ta phải khởi tạo nó, sau đó ta sẽ xét set các thuộc tính cho nó. Ví dụ giờ ta muốn 1 ngày cụ thế là `October 21, 2020`( without time components (which will default to 00:00:00).). Thì ta sẽ làm như sau:

```swift
var comps = DateComponents() // <1>
comps.day = 21
comps.month = 10
comps.year = 2020

let date = Calendar.current.date(from: comps)! // <2>
print(date)
```


# I. Getting current date

```swift
let date = Date()
```

`This gives the system date using the current user locale.`

## 1.1 Getting date components

Để có thể lấy các thành phần khác nhau của `date`(như ngày, tháng, năm,..) ta sẽ sử dụng `dateComponents` function từ current `Caledar` instance:

```swift
let date = Date()

let components = Calendar.current.dateComponents([.day, .month, .year], from: date)


let day = components.day
let month = components.month
let year = components.year
print("DEBUG: \(day) and \(month) and \(year)")
```

Output:
```
DEBUG: Optional(21) and Optional(12) and Optional(2023)
```

Some of the most commonly used are:
- `.timezone` to get Timezone information
- `.hour, .minute, .second` to get time information
- `.weekday` to get the number indicating the current day of the week
- `.weekOfYear` to get week number in the year

## 1.2 Creating date from Date Components

Ta có 2 cách:

`Cách 1`:

```swift
var components = DateComponents()
components.timeZone = TimeZone(abbreviation: “GMT”)
components.day = 2
components.month = 8
components.year = 2021
let date = Calendar.current.date(from: components)
```

`Cách 2`:

```swift
let components = DateComponents(
    timeZone: TimeZone(abbreviation: “GMT”),
    year: 2021,
    month: 8,
    day: 2)
```

## 1.3 Difference between two dates

Đôi khi ta muốn biết được sự khác biệt giữa 2 ngày. Swift has an instance method called `distance(to:)` just for this purpose. This method gives the difference in number of seconds:

```swift
let today = Date()
let date = Calendar.current.date(
    from: DateComponents(timeZone: TimeZone(abbreviation: "GMT"),
    year: 2021, month: 8, day: 2))!
 let a = date.distance(to: today)
print("DEBUG: \(a)")                                            ///DEBUG: 75270068.49419296
```


# II. Getting next / previous dates

Chúng ta có thể lấy được ngày tiếp theo hoặc ngày trước đó phù hợp với một tiêu chí nhất định bằng cách sử dụng `nextDate` của Lịch. Nó trả về một ngày tùy chọn. Let’s explore in detail how this function works:

- `after:` Ngày bắt đầu được, ngày này được sử dụng làm mốc để tính ngày tiếp theo hoặc ngày trước đó.
- `matchingPolicy:` when multiple dates are found by search algorithm this attribute specify which date to return, it is defaulted to .first
- `direction`:  indicate whether to search forward or backward from the given date, it is defaulted to `.forward`. Xác định xem ta tìm ngày tiếp theo hay ngày trước đó.


## 2.1 Finding next date

The following example finds the next date matching the day component of the given date. `For example if today date is September 5th 2021 then nextDate will give us October 5th 2021 as the result when matching day component:`

```swift
let today = Date()
let components = Calendar.current.dateComponents([.day],
    from: today)
let nextDate = Calendar.current.nextDate(
    after: today,
    matching: components,
    matchingPolicy: .nextTime,
    repeatedTimePolicy: .first,
    direction: .forward)
```

## 2.2 Finding previous date

If we want to go back from the given date we just need to specify the direction parameter as `.backward`.

```swift
let lastDate = Calendar.current.nextDate(
    after: today,
    matching: components,
    matchingPolicy: .nextTime,
    repeatedTimePolicy: .first,
    direction: .backward)
```

## 2.3 Finding list of matching dates

As we have seen in the previous example we can find next or previous date using nextDate function. But what if we want to find let’s say next 10 dates that match the criteria. How about looping through nextDate function 10 times? Lúc này ta cần sử dụng `enumerateDates`:

```swift
let today = Date()
let components = Calendar.current.dateComponents(
    [.day], from: today)
var count = 0
Calendar.current.enumerateDates(
    startingAfter: today,
    matching: components,
    matchingPolicy: .nextTime,
    repeatedTimePolicy: .first,
    direction: .forward) { (date, strict, stop) in
    count += 1
    print(date)
    if count == 10 {
        stop = true
    }
}
```

`The trailing closure has 3 parameters:`

- The 1st parameter is the date that matched the criteria. It is an optional.
- The 2nd parameter is the matching policy
- The 3rd parameter is an inout Bool. If we want to stop the search we need to set its value to true inside the closure. Failing to set it may result in an infinite loop.