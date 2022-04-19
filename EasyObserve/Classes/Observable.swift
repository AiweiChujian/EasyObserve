//
//  Observable.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/4/14.
//

import Foundation
import UIKit

public struct ObserveOptions: OptionSet {
    public static let initial = ObserveOptions(rawValue: 1 << 0)
    
    public static let new = ObserveOptions(rawValue: 1 << 1)
        
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public var isVaild: Bool {
        self.intersection([.new, .initial]) != ObserveOptions([])
    }
}

public struct Change<Value> {
    public var oldValue: Value
    
    public var newValue: Value
}

public typealias Subscriber<Value> = (_ value: Value, _ change: Change<Value>, _ option: ObserveOptions) -> Void

//MARK: - Observable
@propertyWrapper
public struct ObservableWrapper<T, Value> where T: AnyObject {
    private var storage: Value
    
    public var wrappedValue: Value {
        get { storage }
        set {
            let change = Change<Value>(oldValue: storage, newValue: newValue)
            storage = newValue
            projectedValue.notify(newValue: newValue, change: change)
        }
    }
    
    public init(wrappedValue: Value) {
        storage = wrappedValue
    }
    
    public private(set) lazy var projectedValue = Scheduler<Value>(initialValue: storage)
}

public protocol EasyObserve: AnyObject {
    typealias Observable<Value>  = ObservableWrapper<Self, Value>
}

extension NSObject: EasyObserve {}

//MARK: - SingleObserver
class SingleObserver<Value> {
    private var options: ObserveOptions
    
    private var subscriber: Subscriber<Value>
    
    init(_ options: ObserveOptions, _ subscriber: @escaping Subscriber<Value>) {
        self.options = options
        self.subscriber = subscriber
    }
    
    func send(value: Value, change: Change<Value>, for option: ObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber(value, change, option)
    }
}

//MARK: - Scheduler
public class Scheduler<Value> {
    var lastValue: Value
    
    init(initialValue: Value) {
        self.lastValue = initialValue
    }
    
    struct WeakRef<T: AnyObject> {
        weak var observer: T?
    }
    
    /// Single Observe
    private typealias ObserverObj = SingleObserver<Value>
    
    private var observerList = [WeakRef<ObserverObj>]()
    
    public func observe(options: ObserveOptions = [.initial, .new], subscriber: @escaping Subscriber<Value>) -> Observer {
        guard options.isVaild else {
            return Observer(nil)
        }
        let observerObj = ObserverObj(options, subscriber)
        observerList.append(WeakRef(observer: observerObj))
        if options.contains(.initial) {
            observerObj.send(value: lastValue, change: Change<Value>(oldValue: lastValue, newValue: lastValue), for: .initial)
        }
        if options == .initial {
            return Observer(nil)
        }
        return Observer(observerObj)
    }
    
    /// Combine Observe
    private var combineOBList = [WeakRef<AnyObject>]()
    
    func appendCombineObserver<T: CombineObserverType>(_ observer: T) {
        guard combineOBList.filter({ $0.observer === observer }).count == 0 else {
            return
        }
        combineOBList.append(WeakRef (observer: observer))
    }
    
    func removeCombineObserver<T: CombineObserverType>(_ observer: T) {
        combineOBList = combineOBList.filter({ $0.observer !== observer })
    }
    
    /// Nofity
    func notify(newValue: Value, change: Change<Value>) {
        lastValue = newValue
        observerList = observerList.compactMap({ weakRef in
            guard let observer = weakRef.observer else {
                return nil
            }
            observer.send(value: newValue, change: change, for: .new)
            return weakRef
        })
        
        combineOBList = combineOBList.compactMap({ weakRef in
            guard let observer = weakRef.observer as? CombineObserverType else {
                return nil
            }
            observer.sendValue(for: .new)
            return weakRef
        })
    }
}
