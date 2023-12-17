# Property Wrapper and Projected Value

# I. Property Wrapper

`Property Wrapper` được sử dụng để tạo một lớp layer phân cách giữa phần code chúng ta quản lý một `Property Wrapper` và phần code nơi property đó được định nghĩa.

- To define a property wrapper, you can use the annotation `@propertyWrapper`: Khi annotate 1 struct với `@propertyWrapper`, ta sẽ được cung cấp 1 property là `wrappedValue`, và ta sẽ sử dụng biến này để lưu và quản lý giá trị thông qua chính `getter và setter` của biến `wrappedValue` này.

- Ok giờ tại sao ta lại phải sử dụng `propertyWrapper`?

Ví dụ ta có một mảng `String` cần phần `encoding` để chuyển đi, nếu sử dụng thông thường, thì mỗi phần tử `String` đó ta cần phải tự triển khải 1 func để encoding. Nếu ta sử dụng `propertyWrapper`, ta chỉ cần triển khai 1 struct cho tất cả các biến cần phải `encoding`, điều này làm code trở lên reuse và clean.

```swift
@propertyWrapper
struct Base64Encoding {
    private var value = ""
    
    var wrappedValue: String {
        get { Data(value.utf8).base64EncodedString() }
        set { value = newValue }
    }
}

struct Payload {
    @Base64Encoding var text: String
}
```

Lúc này khi ta muốn truy cập vào text của struct `Payload`, thì text đó luôn trả về 1 `base64 encoded string.`:

```swift
var p = Payload()
p.text = "Property Wrapper"
print(p.text) // UHJvcGVydHkgV3JhcHBlcg==
```

# 1.1 Access to the Property Wrapper itself

Ở phần trên, khi ta gọi `p.text`, nó print ra `UHJvcGVydHkgV3JhcHBlcg==`. Điều đó có nghĩa là `p.text` là ta đang truy cập vào `getter` của biến `wrappedValue`, chứ không phải ta đang truy cập vào `struct Base64Encoding`(truy cập vào struct `Base64Encoding` có nghĩa là ta muốn truy cập vào các property, truy cập vào method hay init của struct đó, chứ đel phải giá trị `wrappedValue`).
- Để truy cập vào `struct Base64Encoding`, you need to add an `underscore(_)` to the property.

```swift
@propertyWrapper
struct OddOrEven {
    private var number: Int
    
    var wrappedValue: Int{
        get { return number }
        set{ number = newValue }
    }
    
    init() { self.number = 0  }
    
    func checkLessThanTen() -> Bool{
        return((number < 10) ? true : false)
    }
}

struct NumberStructure {
    @OddOrEven var someNumber: Int
      
    func otherDisplay(){
        let otherMessage = _someNumber.checkLessThanTen() ? "Number is less than 10" : 
    "Number is not less than 10"
        print(otherMessage)
    }
}
```

Bạn thấy không, ta đang truy cập vào method của `checkLessThanTen()` của `struct propertyWrapper` đó thông qua `underscore(_)`


Tóm lại ta có các cách truy cập như sau:

`TH1`: truy cập bên trong struct mà khởi tạo `property wrapper`
- Khi không sử dụng `$`(có nghĩa là truy cập bình thường :))) - Thì ta đang truy cập vào `getter` và `setter` của biến `wrapperValue` của `propertyWrapper`: 

```swift
struct NumberStructure {
    @OddOrEven var someNumber: Int
      
    func setValue(){
        someNumber = 10 ///Access to setter wrappedValue of propertyWrapper
        print("DEBUG: \(someNumber)")   ///Access to getter wrappedValue of propertyWrapper
    }
}
```

- Khi sử dụng `$`: ta sẽ truy cập vào biến `projectedValue` của `propertyWraper`. Đọc `II`.
- Khi sử dụng underscore `_`, truy cập vào chính `Struct Property Wrapper itself`.

`TH2`: truy cập bên ngoài struct mà khởi tạo `property wrapper`. Tự nhìn ví dụ vì cơ bản đ khác gì.

```swift
@propertyWrapper
struct OddOrEven {
    private var number: Int
    var projectedValue: Bool
    
    var wrappedValue: Int{
        get {
            return number * number
        }
        set{ 
            projectedValue = number > 10
            number = newValue
        }
    }
    
    init(wrappedValue: Int) { 
        self.number = wrappedValue  
        projectedValue = wrappedValue > 10
    }
    
    func checkLessThanTen() -> Bool{
        return((number < 10) ? true : false)
    }
}


struct Siuu {
    
    @OddOrEven var a: Int
    
    init(value: Int) {
        self._a = OddOrEven(wrappedValue: value)
        print("Access projectedValue inside struct: \($a)")
    }
    
    
    func dauBuoi() -> Bool {
        return _a.checkLessThanTen()
    }
}

let viet = Siuu(value: 3)
print("Access wrappedValue: \(viet.a)")
print("Access propertyWrapper itself: \(viet.dauBuoi())")
print("Access projectedValue outside struct: \(viet.$a)")
```

Output: 

```php
Access projectedValue in struct: false
Access wrappedValue: 9
Access propertyWrapper itself: true
Access projectedValue outside struct: false
```

# II. Projected Value

Today we will explore one great feature of property wrappers, the projected value. It is very useful when you want to have a little more info about the wrapped value. Ví dụ, ta có một biến `property wrapper` và sẽ set a max limit to the int, lúc này ta có thể sử dụng một biến để check `property wrapper` đó đã đạt max hay chưa.

```swift
@propertyWrapper
struct UpperCaseMask {
    
    private var text: String //1
    var projectedValue: Bool //2
    
    init() {
        self.text = ""
        self.projectedValue = false
    }
    
    var wrappedValue: String { //3
        get {return text}
        set {
            if newValue.count > 3 {
                text = newValue.prefix(3).uppercased()
                projectedValue = false
            } else {
                text = newValue.uppercased()
                projectedValue = true
            }
        }
    }
}


struct Home {
    @UpperCaseMask public var homeCode: String
    
    init(homeCode: String) {
        self.homeCode = homeCode
    }
    
}

var home1 = Home(homeCode: "brln123123")
print(home1.$homeCode, home1.homeCode) // 1

home1.homeCode = "can"
print(home1.$homeCode, home1.homeCode) // 1
```

Output:

```php
false BRL
true CAN
```

Để có thể truy cập vào biến `projectedValue` bên trong `struct`, ta chỉ cần sử dụng `$` như sau:

```swift
struct Home {
    @UpperCaseMask public var homeCode: String
    
    init(homeCode: String) {
        self.homeCode = homeCode
    }
    
    func getHomeCodeFullDescription() -> String {
        if $homeCode { // < - - - Here
            return "We just need to uppercase it"
        } else {
            return "We need to cut and uppercase it"
        }
    }
}

var home1 = Home(homeCode: "brln123123")
print(home1.$homeCode, home1.homeCode, home1.getHomeCodeFullDescription())

home1.homeCode = "can"
print(home1.$homeCode, home1.homeCode, home1.getHomeCodeFullDescription())
```

Output:

```php
false BRL We need to cut and uppercase it
true CAN We just need to uppercase it
```


# V. Reference

1. [Project a Value From a Property Wrapper](https://holyswift.app/projecting-a-value-from-a-property-wrapper/)
2. [Property Wrappers in Swift - medium](https://medium.com/globant/property-wrappers-in-swift-85d2b2cc8b2)