//
//  EasyObservable.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/4/14.
//

import Foundation

public final class EasyObserveChange<Value> {
    public let oldValue: Value
    
    public var newValue: Value
    
    init(oldValue: Value, newValue: Value) {
        self.oldValue = oldValue
        self.newValue = newValue
    }
}

//MARK: - EasyObservableWrapper
@MainActor @propertyWrapper
public class EasyObservableWrapper<T, Value> where T: AnyObject {
    private var storage: Value
    
    public var wrappedValue: Value {
        get { storage }
        set {
            let change = EasyObserveChange<Value>(oldValue: storage, newValue: newValue)
            projectedValue.notify(change: change, option: .prior)
            storage = change.newValue
            projectedValue.notify(change: change, option: .new)
            projectedValue.notify(change: change, option: .defer)
        }
    }
    
    public init(wrappedValue: Value) {
        storage = wrappedValue
    }
    
    public private(set) lazy var projectedValue = EasyScheduler<Value>(initialValue: storage)
}

@MainActor @propertyWrapper
public class EasyObservableWeakWrapper<T, Value> where T: AnyObject, Value: AnyObject {
    public private(set) weak var weakObj: Value?
    
    public var wrappedValue: Value? {
        get { weakObj }
        set { weakObj = newValue }
    }
    
    public init(wrappedValue: Value?) {
        weakObj = wrappedValue
    }
}

// MARK: - EasySubscriber
public typealias EasySubscriber<Value> = (_ value: Value, _ change: EasyObserveChange<Value>, _ option: EasyObserveOptions) -> Void

// MARK: - RealObserver
@MainActor
class RealObserver<Value> {
    private var options: EasyObserveOptions
    
    private var subscriber: EasySubscriber<Value>
    
    init(_ options: EasyObserveOptions, _ subscriber: @escaping EasySubscriber<Value>) {
        self.options = options
        self.subscriber = subscriber
    }
    
    func send(value: Value, change: EasyObserveChange<Value>, for option: EasyObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber(value, change, option)
    }
}
