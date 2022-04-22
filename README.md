# EasyObserve

[![CI Status](https://img.shields.io/travis/AiweiChujian/EasyObserve.svg?style=flat)](https://travis-ci.org/AiweiChujian/EasyObserve)
[![Version](https://img.shields.io/cocoapods/v/EasyObserve.svg?style=flat)](https://cocoapods.org/pods/EasyObserve)
[![License](https://img.shields.io/cocoapods/l/EasyObserve.svg?style=flat)](https://cocoapods.org/pods/EasyObserve)
[![Platform](https://img.shields.io/cocoapods/p/EasyObserve.svg?style=flat)](https://cocoapods.org/pods/EasyObserve)

## Description

EasyObserve为Swift提供了一个简单、易用、轻量的观察者模式，核心代码仅200多行，你可以用它代替使用成本过高的KVO和Notification，可以很方便的用于MVC架构中，也可以作为MVVM中不想使用响应式编程时的替代方案。

## Installation

EasyObserve支持通过 [CocoaPods](https://cocoapods.org) 安装：

```ruby
pod 'EasyObserve'
```

## Example

`repo`中包含一个demo, 运行demo之前，需要先执行`pod install`。

## Usage

EasyObserve的使用和闭包KVO相似，相比于闭包KVO，主要解决了以下痛点：

* NSObject的子类才能使用KVO（需要`@objc dynamic`修饰属性），而任意类类型都可以使用EasyObserve
* 闭包KVO在对多个观察的管理和避免重复观察时很不方便，EasyObserve提供了[UnionObserver](#3-unionobserver) 和[DistinctObserver](#4-distinctobserver)来方便对观察的管理
* KVO对多个值的合并观察需要引入一个中间值，再对中间值进行观察才能完成，EasyObserver可以通过[CombineObserver](#5-combineobserver)非常方便对多个值进行合并观察

### 1. Observable

通常只有类（引用类型）才具有被观察的意义，通过`@Observable`包装类的可观察属性：

```swift
import EasyObserve

class UserModel: EasyObserve {
    @Observable var name: String
    @Observable var gender: UserGender
    @Observable var age: Int
        
    init(name: String, gender: UserGender, age: Int) {
        self.name = name
        self.gender = gender
        self.age = age
    }
}

enum UserGender: Equatable {
    case male, female
}
```

### 2. Observer

EasyObserver使用和系统闭包KVO相同的观察管理策略，即对属性观察后返回一个观察者对象，在观察者对象释放时，自动移除对应的观察。`Observable`包装的可观察属性通过其呈现值（`$+属性名`）添加观察：

```swift
var nameObserver: Observer?
var genderObserver: Observer?
var ageObserver: Observer?

// 默认为 [.initial, .new]
nameObserver = user.$name.observe(subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})

// initial
genderObserver = user.$gender.observe(options: [.initial], subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})

// new
ageObserver = user.$age.observe(options: [.new], subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})
```

> EasyObserve在添加观察时，支持`.inintial`和`.new`两种option

### 3. UnionObserver

通常在每个Controller中会添加多个观察者，你可以通过`UnionObserver`和`+=`运算符来集中持有它们，上面的代码可以改为：

```swift
let unionObserver = UnionObserver()

// 默认为 [.initial, .new]
unionObserver += user.$name.observe(subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})

// initial
unionObserver += user.$gender.observe(options: [.initial], subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})

// new
unionObserver += user.$age.observe(options: [.new], subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})
```

### 4. DistinctObserver

向`UnionObserver`中添加的观察是**可以重复并存**的，在重复设值的场景中（如：UITableViewCell），往往希望对同一类型的同一属性的观察是不重复的，你可以通过`DistinctObserver`和`-=`运算符来完成：

```swift
typealias UserModelObserver = DistinctObserver<UserModel>

let distinctObserver = UserModelObserver()

// 默认为 [.initial, .new]
distinctObserver[\.name] -= user.$name.observe(subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})

// initial
distinctObserver[\.gender] -= user.$gender.observe(options: [.initial], subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})

// new
distinctObserver[\.age] -= user.$age.observe(options: [.new], subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})
```

### 5. CombineObserver

很多时候我们需要对属性进行合并观察，EasyObserve提供了`&`运算符来创建CombineObserver，最多支持8个属性的合并观察，对更多值的合并观察，可以将观察结果写入到一个合并的值类型（元组、结构体、字典等）中，再对这个合并的中间值添加观察：

```swift
var combineObserver: Observer?

combineObserver = (user.$name & user.$gender & user.$age).combineObserve(subscriber: { [unowned self] value, option in
    /* 订阅代码 */
})
```

> 合并观察返回的也是一个`Observer`，可以通过`UnionObserver`或`DistinctObserver`进行管理

## Author

AiweiChujian, hellohezhili@gmail.com

## License

AWMaster 支持 MIT 许可协议，详情见 LICENSE 文件。
