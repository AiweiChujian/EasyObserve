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

EasyObserve是为了提供一种简单、轻量的观察者模式工具，EasyObserve的使用和闭包KVO相似，相比于闭包KVO，主要解决了以下痛点：

* NSObject的子类才能使用KVO（需要`@objc dynamic`修饰属性），而任意类类型都可以使用EasyObserve
* 闭包KVO在对多个观察的管理和避免重复观察时很不方便，EasyObserve提供了[EasyObserverBag](#3-EasyObserverBag) 和[EasyObserverMap](#4-EasyObserverMap)来方便对观察的管理
* KVO对多个值的合并观察需要引入一个中间值，再对中间值进行观察才能完成，EasyObserver可以通过[EasyCombineObserver](#5-EasyCombineObserver)非常方便对多个值进行合并观察

> KXYZObserve 不是线程安全的，设计为主线程中进行数据和状态的同步。

### 1. EasyObservable

通常只有类（引用类型）才具有被观察的意义，通过`@EasyObservable`包装类的可观察属性：

```swift
import EasyObserve

class UserModel: EasyObserved {
    @EasyObservable var name: String
    @EasyObservable var age: Int
        
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}
```

### 2. EasyObserver

EasyObserver使用和系统闭包KVO相似的观察管理策略，即对属性观察后返回一个观察者对象，在观察者对象释放时，自动移除对应的观察。`@EasyObservable`包装的可观察属性通过其呈现值（`$<属性名>`）添加观察：

```swift
var nameObserver: EasyObserver?
var ageObserver: EasyObserver?

// 默认为 [.initial, .new]
nameObserver = user.$name.observe(subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})

// new
ageObserver = user.$age.observe(options: [.new], subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})
```

> EasyObserve在添加观察时，支持`.inintial`、`.new`、`prior` 和 `defer` 四种 options

### 3. EasyObserverBag

通常在每个Controller中会添加多个观察者，你可以通过`EasyObserverBag`和`+=`运算符来集中持有它们，上面的代码可以改为：

```swift
let observerBag = EasyObserverBag()

observerBag += user.$name.observe(subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})

observerBag += user.$age.observe(subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})
```

#### EasyObserving

遵循`EasyObserving`协议的对象，会由协议默认创建一个关联的`observerBag`，EasyObserver 也可以通过`held(by:)`方法快捷快捷添加到 EasyObserverBag 中。

### 4. EasyObserverMap

向`EasyObserverBag`中添加的观察是**可以重复并存**的，在重复设值的场景中（如：复用的 UITableViewCell），往往希望对同一类型的同一属性的观察是不重复的，你可以通过`EasyObserverMap` 来完成：

```swift
typealias UserModelObserver = EasyObserverMap<UserModel>

let observerMap = UserModelObserver()

// 默认为 [.initial, .new]
observerMap[\.name] = user.$name.observe(subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})

// new
observerMap[\.age] = user.$age.observe(options: [.new], subscriber: {[unowned self] value, change, option in
    /* 订阅代码 */
})
```

### 5. EasyCombineObserver

很多时候我们需要对属性进行合并观察，EasyObserve提供了`&`运算符来创建CombineObserver，最多支持8个属性的合并观察：
```swift
var combineObserver: EasyObserver?

combineObserver = (user.$name & user.$age & user.$age).combineObserve(subscriber: { [unowned self] value, option in
    /* 订阅代码 */
})
```

> 对更多值的合并观察，可以将观察结果写入到一个合并的值类型（元组、结构体、字典等）中，再对这个合并的中间值添加观察。

> 合并观察返回的也是一个`EasyObserver`，可以通过`EasyObserverBag`或`EasyObserverMap`进行管理。

### 6. Others

EasyObserve 还对 Notification 和 UIControl 进行了扩展，让通知和 UIControl 的事件的响应可以与对 EasyObserver 的观察有一致的管理方式。

> 使用方式查看 `EasyNotification`和`EasyControlObserver`。

## Author

AiweiChujian, hellohezhili@gmail.com

## License

AWMaster 支持 MIT 许可协议，详情见 LICENSE 文件。
