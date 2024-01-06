# LazyVgrid and LazyHGrid

Trước khi đi vào phần này, ta cần hiểu về `GridItem`. `GridItem` đơn giản giống như Cell trong UIKit, nó là container để chứa các View Child bên trong như `Text, Image,...`. Khi ta define ra 1 `GridItem`, ta sẽ xác định sẵn size cho nó. OK giờ đến phần size, ta sẽ lấy ví dụ như sau:
- Đầu tiên ta sẽ define: 

```swift
private var gridItemLayout = [GridItem(.fixed(300), spacing: 5), GridItem(.fixed(300)), GridItem(.fixed(30))]
```

Nếu ta áp dụng `gridItemLayout` này cho `LazyVGrid`, thì với mỗi hàng sẽ có 3 Item, với các Item có `width` lần lượt là 300, 30 và 30. Với khoảng cách mỗi Item là 300, 8(default là 8 nếu ko khai báo), và cuối cùng 30 trả có ý nghĩa gì vì nó ở cuối. Còn với `LazyHGrid` nó sẽ có `height` lần lượt tương tự.

```swift
LazyVGrid(columns: gridItemLayout, spacing: 5) {
    ForEach((0...9999), id: \.self) {
        Text(textString)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(colors[$0 % colors.count])
            .cornerRadius(10)
    }
}
.frame(width: widthDevice, alignment: .leading)
```

Output:

![](images/GeoRead/basic_vgrid1.png)

```swift
LazyHGrid(rows: gridItemLayout, spacing: 5) {
        ForEach((0...9999), id: \.self) {
            Text(textString)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(colors[$0 % colors.count])
                .cornerRadius(10)
        }
    }
```


Output:

![](images/GeoRead/basic_hgrid1.png)

Ở đây ta nhìn sự khác biệt `LazyVGrid(columns: gridItemLayout, spacing: 5)` và `LazyHGrid(rows: gridItemLayout, spacing: 5)`. Ta thấy rằng với `VGrid` thì parameter của nó là `collums)`, còn có nghĩa là cột, còn với `LazyHgrid` thì là `rows`, còn có nghĩa là hàng. Ở đây ta cũng suy được ra rằng, `LazyVGrid` sẽ chia layout theo hàng, mỗi hàng có 3 collums(cột), và mỗi hàng cách nhau spacing là 5. Tương tự như thế `LazyVgrid`.

- OK giờ ta đã biết được khi khai báo `gridItemLayout` ta có khai báo lần lượt các giá trị fixed. Đối với `LazyVgrid` thì đó là width của các Item, còn đối với `LazyHgrid` thì đó là `height` của các Item. Vậy thì `height` của Item `lazyVgrid` và width của item `LazyHgrid` đâu?? 
  
Để trả lời câu hỏi đó, bạn hãy nhìn 2 ví dụ trên, bạn thấy với `LazyVgrid` thì background của các Item trong cùng 1 hàng đều có height bằng nhau đúng không. Điều này cũng tượng tự cho `LazyHGrid`, thì các item trong cùng 1 cột đểu có width giống nhau. Vậy câu trả lời ở đây là `height` của `LazyVGrid` trong cùng 1 hàng thì sẽ lấy `height` của Item cần nhiều height nhất, điều này cũng tương tự với `LazyHgrid`:

```swift
struct LazyVgridView: View {

    private var colors: [Color] = [.yellow, .purple, .green]

    private var gridItemLayout = [GridItem(.fixed(80), spacing: 5), GridItem(.fixed(80), spacing: 0), GridItem(.fixed(30))]
    
    @State private var textString = "dsad"
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TextField(text: $textString) {
                    Text("đâsdasdasdasdasd")
                }
                
                
                LazyVGrid(columns: gridItemLayout, spacing: 5) {
                    ForEach((0...9999), id: \.self) {
                        Text(textString)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(colors[$0 % colors.count])
                            .cornerRadius(10)
                    }
                }
                .frame(width: widthDevice, alignment: .leading)
            }
            

        }
    }
}
```

Output: 

![](images/GeoRead/heightItemVgird.gif)


Ta thấy rằng, khi text thay đổi, thì thằng `green` có width bé nên nó sẽ cần nhiều height hơn để chứa text đó, dẫn đến khi càng gõ thì height nó tăng, và height trong cùng 1 hàng sẽ lấy height thằng lớn nhất, và ở đây là height của thằng `green`


# I. LazyVGrid

Ok giờ ta sẽ làm tí size của 1 item như `flexible`,...


```swift
LazyVGrid(columns: gridItemLayout, spacing: 5) {
        Text("textString")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.red)
            .cornerRadius(10)
    
    Text("textString đá ád ád ád ád")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.red)
        .cornerRadius(10)
    
    Text("textString")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.red)
        .cornerRadius(10)
    
}
```

Output:

![](images/GeoRead/heightVgrid2.png)

Ta hiểu được luôn là khi xử dụng `flexible()` khi ko truyền parameter nào thì nó sẽ chia đều `width` cho mỗi Item. và cũng thấy được luôn là height mỗi Item là bằng nhau trong cùng 1 hàng.
