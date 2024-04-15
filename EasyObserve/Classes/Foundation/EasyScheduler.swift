//
//  EasyScheduler.swift
//  EasyObserve
//
//  Created by Aiwei on 2024/4/15.
//

import Foundation

@MainActor
public class EasyScheduler<Value> {
    var lastValue: Value
    
    init(initialValue: Value) {
        self.lastValue = initialValue
    }
    
    struct WeakBox<T: AnyObject> {
        weak var observer: T?
    }
    
    private var observerList: [WeakBox<RealObserver<Value>>] = []
    
    private var combineObserverList = [WeakBox<AnyObject>]()
    
    private var isNotifying = false
}

extension EasyScheduler {
    public func observe(options: EasyObserveOptions = [.initial, .new], subscriber: @escaping EasySubscriber<Value>) -> EasyObserver {
        guard options.isVaild else {
            assertionFailure("invalid observe options")
            return EasyObserver(nil)
        }
        let realObserver = RealObserver<Value>(options, subscriber)
        observerList.append(WeakBox(observer: realObserver))
        if options.contains(.initial) {
            realObserver.send(value: lastValue, change: EasyObserveChange<Value>(oldValue: lastValue, newValue: lastValue), for: .initial)
        }
        if options == .initial {
            return EasyObserver(nil)
        }
        return EasyObserver(realObserver)
    }
    
    /// 通知观察者
    func notify(change: EasyObserveChange<Value>, option: EasyObserveOptions) {
        guard !isNotifying else {
            assertionFailure("There is a cycle of observe.")
            return
        }
        isNotifying = true
        defer { isNotifying = false }
        // 通知普通观察者
        observerList = observerList.compactMap({ weakBox in
            guard let observer = weakBox.observer else {
                return nil
            }
            if option == .prior {
                observer.send(value: change.newValue, change: change, for: option)
            } else {
                // 确保非 .prior 时, 订阅中对 change 的修改不会被传递
                let sendChange =  EasyObserveChange(oldValue: change.newValue, newValue: change.oldValue)
                observer.send(value: change.newValue, change: sendChange, for: option)
            }
            return weakBox
        })
        
        lastValue = change.newValue
        
        if option == .new {
            // 通知合并观察者
            combineObserverList = combineObserverList.compactMap({ weakBox in
                guard let observer = weakBox.observer as? EasyCombineObserverType else {
                    return nil
                }
                observer.sendValue(for: option)
                return weakBox
            })
        }
    }
}

extension EasyScheduler {
    func addCombineObserver<T: EasyCombineObserverType>(_ observer: T) {
        guard combineObserverList.filter({ $0.observer === observer }).count == 0 else {
            return
        }
        combineObserverList.append(WeakBox (observer: observer))
    }
    
    func removeCombineObserver<T: EasyCombineObserverType>(_ observer: T) {
        combineObserverList = combineObserverList.filter({ $0.observer !== observer })
    }
}
