//
//  CombineObserver.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/4/19.
//

import Foundation

protocol CombineObserverType: AnyObject{
    func sendValue(for option: ObserveOptions)
}

public typealias CombineSubscriber<Value> = (_ value: Value, _ option: ObserveOptions) -> Void

public class CombineObserver<CombineValue>: CombineObserverType {
    
    fileprivate var options = ObserveOptions([])
    
    fileprivate var subscriber: CombineSubscriber<CombineValue> = {_, _ in }
    
    func sendValue(for option: ObserveOptions) {}
    
    public func combineObserve(options: ObserveOptions = [.initial, .new], subscriber: @escaping CombineSubscriber<CombineValue>) -> Observer {
        guard options.isCombineVaild else {
            assertionFailure("invalid combine observe options")
            return Observer(nil)
        }
        self.options = options
        self.subscriber = subscriber
        if options.contains(.initial) {
            sendValue(for: .initial)
        }
        if options == .initial {
            return Observer(nil)
        }
        return Observer(self)
    }
}

/// CombineObserver2
public class CombineObserver2<V1, V2>: CombineObserver<(V1, V2)> {
    fileprivate let scheduler1: Scheduler<V1>
    fileprivate let scheduler2: Scheduler<V2>
    
    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>) {
        scheduler1 = scd1
        scheduler2 = scd2
    }
    
    override func sendValue(for option: ObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue), option)
    }
}

extension Scheduler {
    public static func & <T>(left: Scheduler, right: Scheduler<T>) -> CombineObserver2<Value, T> {
        let observer = CombineObserver2(scd1: left, scd2: right)
        observer.scheduler1.appendCombineObserver(observer)
        observer.scheduler2.appendCombineObserver(observer)
        return observer
    }
}

/// CombineObserver3
public class CombineObserver3<V1, V2, V3>: CombineObserver<(V1, V2, V3)> {
    fileprivate let scheduler1: Scheduler<V1>
    fileprivate let scheduler2: Scheduler<V2>
    fileprivate let scheduler3: Scheduler<V3>
    
    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
    }
    
    override func sendValue(for option: ObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue), option)
    }
}

extension CombineObserver2 {
    public static func & <T>(left: CombineObserver2, right: Scheduler<T>) -> CombineObserver3<V1, V2, T> {
        left.scheduler1.removeCombineObserver(left)
        left.scheduler2.removeCombineObserver(left)
        let observer = CombineObserver3(scd1: left.scheduler1, scd2: left.scheduler2, scd3: right)
        observer.scheduler1.appendCombineObserver(observer)
        observer.scheduler2.appendCombineObserver(observer)
        observer.scheduler3.appendCombineObserver(observer)
        return observer
    }
}

/// CombineObserver4
public class CombineObserver4<V1, V2, V3, V4>: CombineObserver<(V1, V2, V3, V4)> {
    fileprivate let scheduler1: Scheduler<V1>
    fileprivate let scheduler2: Scheduler<V2>
    fileprivate let scheduler3: Scheduler<V3>
    fileprivate let scheduler4: Scheduler<V4>
    
    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>, scd4: Scheduler<V4>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
        scheduler4 = scd4
    }
    
    override func sendValue(for option: ObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue, scheduler4.lastValue), option)
    }
}

extension CombineObserver3 {
    public static func & <T>(left: CombineObserver3, right: Scheduler<T>) -> CombineObserver4<V1, V2, V3, T> {
        left.scheduler1.removeCombineObserver(left)
        left.scheduler2.removeCombineObserver(left)
        left.scheduler3.removeCombineObserver(left)
        let observer = CombineObserver4(scd1: left.scheduler1, scd2: left.scheduler2, scd3: left.scheduler3, scd4: right)
        observer.scheduler1.appendCombineObserver(observer)
        observer.scheduler2.appendCombineObserver(observer)
        observer.scheduler3.appendCombineObserver(observer)
        observer.scheduler4.appendCombineObserver(observer)
        return observer
    }
}

/// CombineObserver5
public class CombineObserver5<V1, V2, V3, V4, V5>: CombineObserver<(V1, V2, V3, V4, V5)> {
    fileprivate let scheduler1: Scheduler<V1>
    fileprivate let scheduler2: Scheduler<V2>
    fileprivate let scheduler3: Scheduler<V3>
    fileprivate let scheduler4: Scheduler<V4>
    fileprivate let scheduler5: Scheduler<V5>
    
    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>, scd4: Scheduler<V4>, scd5: Scheduler<V5>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
        scheduler4 = scd4
        scheduler5 = scd5
    }
    
    override func sendValue(for option: ObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue, scheduler4.lastValue, scheduler5.lastValue), option)
    }
}

extension CombineObserver4 {
    public static func & <T>(left: CombineObserver4, right: Scheduler<T>) -> CombineObserver5<V1, V2, V3, V4, T> {
        left.scheduler1.removeCombineObserver(left)
        left.scheduler2.removeCombineObserver(left)
        left.scheduler3.removeCombineObserver(left)
        left.scheduler4.removeCombineObserver(left)
        let observer = CombineObserver5(scd1: left.scheduler1, scd2: left.scheduler2, scd3: left.scheduler3, scd4: left.scheduler4, scd5: right)
        observer.scheduler1.appendCombineObserver(observer)
        observer.scheduler2.appendCombineObserver(observer)
        observer.scheduler3.appendCombineObserver(observer)
        observer.scheduler4.appendCombineObserver(observer)
        observer.scheduler5.appendCombineObserver(observer)
        return observer
    }
}

/// CombineObserver6
public class CombineObserver6<V1, V2, V3, V4, V5, V6>: CombineObserver<(V1, V2, V3, V4, V5, V6)> {
    fileprivate let scheduler1: Scheduler<V1>
    fileprivate let scheduler2: Scheduler<V2>
    fileprivate let scheduler3: Scheduler<V3>
    fileprivate let scheduler4: Scheduler<V4>
    fileprivate let scheduler5: Scheduler<V5>
    fileprivate let scheduler6: Scheduler<V6>
    
    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>, scd4: Scheduler<V4>, scd5: Scheduler<V5>, scd6: Scheduler<V6>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
        scheduler4 = scd4
        scheduler5 = scd5
        scheduler6 = scd6
    }
    
    override func sendValue(for option: ObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue, scheduler4.lastValue, scheduler5.lastValue, scheduler6.lastValue), option)
    }
}

extension CombineObserver5 {
    public static func & <T>(left: CombineObserver5, right: Scheduler<T>) -> CombineObserver6<V1, V2, V3, V4, V5, T> {
        left.scheduler1.removeCombineObserver(left)
        left.scheduler2.removeCombineObserver(left)
        left.scheduler3.removeCombineObserver(left)
        left.scheduler4.removeCombineObserver(left)
        left.scheduler5.removeCombineObserver(left)
        let observer = CombineObserver6(scd1: left.scheduler1, scd2: left.scheduler2, scd3: left.scheduler3, scd4: left.scheduler4, scd5: left.scheduler5, scd6: right)
        observer.scheduler1.appendCombineObserver(observer)
        observer.scheduler2.appendCombineObserver(observer)
        observer.scheduler3.appendCombineObserver(observer)
        observer.scheduler4.appendCombineObserver(observer)
        observer.scheduler5.appendCombineObserver(observer)
        observer.scheduler6.appendCombineObserver(observer)
        return observer
    }
}

/// CombineObserver7
public class CombineObserver7<V1, V2, V3, V4, V5, V6, V7>: CombineObserver<(V1, V2, V3, V4, V5, V6, V7)> {
    fileprivate let scheduler1: Scheduler<V1>
    fileprivate let scheduler2: Scheduler<V2>
    fileprivate let scheduler3: Scheduler<V3>
    fileprivate let scheduler4: Scheduler<V4>
    fileprivate let scheduler5: Scheduler<V5>
    fileprivate let scheduler6: Scheduler<V6>
    fileprivate let scheduler7: Scheduler<V7>
    
    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>, scd4: Scheduler<V4>, scd5: Scheduler<V5>, scd6: Scheduler<V6>, scd7: Scheduler<V7>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
        scheduler4 = scd4
        scheduler5 = scd5
        scheduler6 = scd6
        scheduler7 = scd7
    }
    
    override func sendValue(for option: ObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue, scheduler4.lastValue, scheduler5.lastValue, scheduler6.lastValue, scheduler7.lastValue), option)
    }
}

extension CombineObserver6 {
    public static func & <T>(left: CombineObserver6, right: Scheduler<T>) -> CombineObserver7<V1, V2, V3, V4, V5, V6, T> {
        left.scheduler1.removeCombineObserver(left)
        left.scheduler2.removeCombineObserver(left)
        left.scheduler3.removeCombineObserver(left)
        left.scheduler4.removeCombineObserver(left)
        left.scheduler5.removeCombineObserver(left)
        left.scheduler6.removeCombineObserver(left)
        let observer = CombineObserver7(scd1: left.scheduler1, scd2: left.scheduler2, scd3: left.scheduler3, scd4: left.scheduler4, scd5: left.scheduler5, scd6: left.scheduler6, scd7: right)
        observer.scheduler1.appendCombineObserver(observer)
        observer.scheduler2.appendCombineObserver(observer)
        observer.scheduler3.appendCombineObserver(observer)
        observer.scheduler4.appendCombineObserver(observer)
        observer.scheduler5.appendCombineObserver(observer)
        observer.scheduler6.appendCombineObserver(observer)
        observer.scheduler7.appendCombineObserver(observer)
        return observer
    }
}

/// CombineObserver8
public class CombineObserver8<V1, V2, V3, V4, V5, V6, V7, V8>: CombineObserver<(V1, V2, V3, V4, V5, V6, V7, V8)> {
    fileprivate let scheduler1: Scheduler<V1>
    fileprivate let scheduler2: Scheduler<V2>
    fileprivate let scheduler3: Scheduler<V3>
    fileprivate let scheduler4: Scheduler<V4>
    fileprivate let scheduler5: Scheduler<V5>
    fileprivate let scheduler6: Scheduler<V6>
    fileprivate let scheduler7: Scheduler<V7>
    fileprivate let scheduler8: Scheduler<V8>
    
    fileprivate init(scd1: Scheduler<V1>, scd2: Scheduler<V2>, scd3: Scheduler<V3>, scd4: Scheduler<V4>, scd5: Scheduler<V5>, scd6: Scheduler<V6>, scd7: Scheduler<V7>, scd8: Scheduler<V8>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
        scheduler4 = scd4
        scheduler5 = scd5
        scheduler6 = scd6
        scheduler7 = scd7
        scheduler8 = scd8
    }
    
    override func sendValue(for option: ObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue, scheduler4.lastValue, scheduler5.lastValue, scheduler6.lastValue, scheduler7.lastValue, scheduler8.lastValue), option)
    }
}

extension CombineObserver7 {
    public static func & <T>(left: CombineObserver7, right: Scheduler<T>) -> CombineObserver8<V1, V2, V3, V4, V5, V6, V7, T> {
        left.scheduler1.removeCombineObserver(left)
        left.scheduler2.removeCombineObserver(left)
        left.scheduler3.removeCombineObserver(left)
        left.scheduler4.removeCombineObserver(left)
        left.scheduler5.removeCombineObserver(left)
        left.scheduler6.removeCombineObserver(left)
        left.scheduler7.removeCombineObserver(left)
        let observer = CombineObserver8(scd1: left.scheduler1, scd2: left.scheduler2, scd3: left.scheduler3, scd4: left.scheduler4, scd5: left.scheduler5, scd6: left.scheduler6, scd7: left.scheduler7, scd8: right)
        observer.scheduler1.appendCombineObserver(observer)
        observer.scheduler2.appendCombineObserver(observer)
        observer.scheduler3.appendCombineObserver(observer)
        observer.scheduler4.appendCombineObserver(observer)
        observer.scheduler5.appendCombineObserver(observer)
        observer.scheduler6.appendCombineObserver(observer)
        observer.scheduler7.appendCombineObserver(observer)
        observer.scheduler8.appendCombineObserver(observer)
        return observer
    }
}

extension CombineObserver8 {
    public static func & <T>(left: CombineObserver8, right: Scheduler<T>) -> CombineObserver8 {
        assertionFailure("The count of combined observers exceeds the maximum limit.")
        return left
    }
}
