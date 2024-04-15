//
//  EasyCombineObserver.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/4/19.
//

import Foundation

@MainActor
protocol EasyCombineObserverType: AnyObject{
    func sendValue(for option: EasyObserveOptions)
    
    func addCombineObserver()
    
    func removeCombineObserver()
}

public typealias EasyCombineSubscriber<Value> = (_ value: Value, _ option: EasyObserveOptions) -> Void

@MainActor
public class EasyCombineObserver<Value>: EasyCombineObserverType {
    
    fileprivate var options = EasyObserveOptions([])
    
    fileprivate var subscriber: EasyCombineSubscriber<Value> = {_, _ in }
    
    func sendValue(for option: EasyObserveOptions) {}
    
    public func combineObserve(options: EasyObserveOptions = [.initial, .new], subscriber: @escaping EasyCombineSubscriber<Value>) -> EasyObserver {
        guard options.isCombineVaild else {
            assertionFailure("Invalid combine observe options.")
            return EasyObserver(nil)
        }
        self.options = options
        self.subscriber = subscriber
        if options.contains(.initial) {
            sendValue(for: .initial)
        }
        if options == .initial {
            return EasyObserver(nil)
        }
        return EasyObserver(self)
    }
    
    func addCombineObserver() {}
    
    func removeCombineObserver() {}
    
}

/// CombineObserver2
public class CombineObserver2<V1, V2>: EasyCombineObserver<(V1, V2)> {
    fileprivate let scheduler1: EasyScheduler<V1>
    fileprivate let scheduler2: EasyScheduler<V2>
    
    fileprivate init(scd1: EasyScheduler<V1>, scd2: EasyScheduler<V2>) {
        scheduler1 = scd1
        scheduler2 = scd2
    }
    
    override func sendValue(for option: EasyObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue), option)
    }
    
    override func addCombineObserver() {
        scheduler1.addCombineObserver(self)
        scheduler2.addCombineObserver(self)
    }
    
    override func removeCombineObserver() {
        scheduler1.removeCombineObserver(self)
        scheduler2.removeCombineObserver(self)
    }
}

extension EasyScheduler {
    public static func & <T>(left: EasyScheduler, right: EasyScheduler<T>) -> CombineObserver2<Value, T> {
        let observer = CombineObserver2(scd1: left, scd2: right)
        observer.addCombineObserver()
        return observer
    }
}

/// CombineObserver3
public class CombineObserver3<V1, V2, V3>: EasyCombineObserver<(V1, V2, V3)> {
    fileprivate let scheduler1: EasyScheduler<V1>
    fileprivate let scheduler2: EasyScheduler<V2>
    fileprivate let scheduler3: EasyScheduler<V3>
    
    fileprivate init(scd1: EasyScheduler<V1>, scd2: EasyScheduler<V2>, scd3: EasyScheduler<V3>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
    }
    
    override func sendValue(for option: EasyObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue), option)
    }
    
    override func addCombineObserver() {
        scheduler1.addCombineObserver(self)
        scheduler2.addCombineObserver(self)
        scheduler3.addCombineObserver(self)
    }
    
    override func removeCombineObserver() {
        scheduler1.removeCombineObserver(self)
        scheduler2.removeCombineObserver(self)
        scheduler3.removeCombineObserver(self)
    }
}

extension CombineObserver2 {
    public static func & <T>(left: CombineObserver2, right: EasyScheduler<T>) -> CombineObserver3<V1, V2, T> {
        left.removeCombineObserver()
        let observer = CombineObserver3(scd1: left.scheduler1, scd2: left.scheduler2, scd3: right)
        observer.addCombineObserver()
        return observer
    }
}

/// CombineObserver4
public class CombineObserver4<V1, V2, V3, V4>: EasyCombineObserver<(V1, V2, V3, V4)> {
    fileprivate let scheduler1: EasyScheduler<V1>
    fileprivate let scheduler2: EasyScheduler<V2>
    fileprivate let scheduler3: EasyScheduler<V3>
    fileprivate let scheduler4: EasyScheduler<V4>
    
    fileprivate init(scd1: EasyScheduler<V1>, scd2: EasyScheduler<V2>, scd3: EasyScheduler<V3>, scd4: EasyScheduler<V4>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
        scheduler4 = scd4
    }
    
    override func sendValue(for option: EasyObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue, scheduler4.lastValue), option)
    }
    
    override func addCombineObserver() {
        scheduler1.addCombineObserver(self)
        scheduler2.addCombineObserver(self)
        scheduler3.addCombineObserver(self)
        scheduler4.addCombineObserver(self)
    }
    
    override func removeCombineObserver() {
        scheduler1.removeCombineObserver(self)
        scheduler2.removeCombineObserver(self)
        scheduler3.removeCombineObserver(self)
        scheduler4.removeCombineObserver(self)
    }
}

extension CombineObserver3 {
    public static func & <T>(left: CombineObserver3, right: EasyScheduler<T>) -> CombineObserver4<V1, V2, V3, T> {
        left.removeCombineObserver()
        let observer = CombineObserver4(scd1: left.scheduler1, scd2: left.scheduler2, scd3: left.scheduler3, scd4: right)
        observer.addCombineObserver()
        return observer
    }
}

/// CombineObserver5
public class CombineObserver5<V1, V2, V3, V4, V5>: EasyCombineObserver<(V1, V2, V3, V4, V5)> {
    fileprivate let scheduler1: EasyScheduler<V1>
    fileprivate let scheduler2: EasyScheduler<V2>
    fileprivate let scheduler3: EasyScheduler<V3>
    fileprivate let scheduler4: EasyScheduler<V4>
    fileprivate let scheduler5: EasyScheduler<V5>
    
    fileprivate init(scd1: EasyScheduler<V1>, scd2: EasyScheduler<V2>, scd3: EasyScheduler<V3>, scd4: EasyScheduler<V4>, scd5: EasyScheduler<V5>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
        scheduler4 = scd4
        scheduler5 = scd5
    }
    
    override func sendValue(for option: EasyObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue, scheduler4.lastValue, scheduler5.lastValue), option)
    }
    
    override func addCombineObserver() {
        scheduler1.addCombineObserver(self)
        scheduler2.addCombineObserver(self)
        scheduler3.addCombineObserver(self)
        scheduler4.addCombineObserver(self)
        scheduler5.addCombineObserver(self)
    }
    
    override func removeCombineObserver() {
        scheduler1.removeCombineObserver(self)
        scheduler2.removeCombineObserver(self)
        scheduler3.removeCombineObserver(self)
        scheduler4.removeCombineObserver(self)
        scheduler5.removeCombineObserver(self)
    }
}

extension CombineObserver4 {
    public static func & <T>(left: CombineObserver4, right: EasyScheduler<T>) -> CombineObserver5<V1, V2, V3, V4, T> {
        left.removeCombineObserver()
        let observer = CombineObserver5(scd1: left.scheduler1, scd2: left.scheduler2, scd3: left.scheduler3, scd4: left.scheduler4, scd5: right)
        observer.addCombineObserver()
        return observer
    }
}

/// CombineObserver6
public class CombineObserver6<V1, V2, V3, V4, V5, V6>: EasyCombineObserver<(V1, V2, V3, V4, V5, V6)> {
    fileprivate let scheduler1: EasyScheduler<V1>
    fileprivate let scheduler2: EasyScheduler<V2>
    fileprivate let scheduler3: EasyScheduler<V3>
    fileprivate let scheduler4: EasyScheduler<V4>
    fileprivate let scheduler5: EasyScheduler<V5>
    fileprivate let scheduler6: EasyScheduler<V6>
    
    fileprivate init(scd1: EasyScheduler<V1>, scd2: EasyScheduler<V2>, scd3: EasyScheduler<V3>, scd4: EasyScheduler<V4>, scd5: EasyScheduler<V5>, scd6: EasyScheduler<V6>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
        scheduler4 = scd4
        scheduler5 = scd5
        scheduler6 = scd6
    }
    
    override func sendValue(for option: EasyObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue, scheduler4.lastValue, scheduler5.lastValue, scheduler6.lastValue), option)
    }
    
    override func addCombineObserver() {
        scheduler1.addCombineObserver(self)
        scheduler2.addCombineObserver(self)
        scheduler3.addCombineObserver(self)
        scheduler4.addCombineObserver(self)
        scheduler5.addCombineObserver(self)
        scheduler6.addCombineObserver(self)
    }
    
    override func removeCombineObserver() {
        scheduler1.removeCombineObserver(self)
        scheduler2.removeCombineObserver(self)
        scheduler3.removeCombineObserver(self)
        scheduler4.removeCombineObserver(self)
        scheduler6.removeCombineObserver(self)
    }
}

extension CombineObserver5 {
    public static func & <T>(left: CombineObserver5, right: EasyScheduler<T>) -> CombineObserver6<V1, V2, V3, V4, V5, T> {
        left.removeCombineObserver()
        let observer = CombineObserver6(scd1: left.scheduler1, scd2: left.scheduler2, scd3: left.scheduler3, scd4: left.scheduler4, scd5: left.scheduler5, scd6: right)
        observer.addCombineObserver()
        return observer
    }
}

/// CombineObserver7
public class CombineObserver7<V1, V2, V3, V4, V5, V6, V7>: EasyCombineObserver<(V1, V2, V3, V4, V5, V6, V7)> {
    fileprivate let scheduler1: EasyScheduler<V1>
    fileprivate let scheduler2: EasyScheduler<V2>
    fileprivate let scheduler3: EasyScheduler<V3>
    fileprivate let scheduler4: EasyScheduler<V4>
    fileprivate let scheduler5: EasyScheduler<V5>
    fileprivate let scheduler6: EasyScheduler<V6>
    fileprivate let scheduler7: EasyScheduler<V7>
    
    fileprivate init(scd1: EasyScheduler<V1>, scd2: EasyScheduler<V2>, scd3: EasyScheduler<V3>, scd4: EasyScheduler<V4>, scd5: EasyScheduler<V5>, scd6: EasyScheduler<V6>, scd7: EasyScheduler<V7>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
        scheduler4 = scd4
        scheduler5 = scd5
        scheduler6 = scd6
        scheduler7 = scd7
    }
    
    override func sendValue(for option: EasyObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue, scheduler4.lastValue, scheduler5.lastValue, scheduler6.lastValue, scheduler7.lastValue), option)
    }
    
    override func addCombineObserver() {
        scheduler1.addCombineObserver(self)
        scheduler2.addCombineObserver(self)
        scheduler3.addCombineObserver(self)
        scheduler4.addCombineObserver(self)
        scheduler5.addCombineObserver(self)
        scheduler7.addCombineObserver(self)
    }
    
    override func removeCombineObserver() {
        scheduler1.removeCombineObserver(self)
        scheduler2.removeCombineObserver(self)
        scheduler3.removeCombineObserver(self)
        scheduler4.removeCombineObserver(self)
        scheduler7.removeCombineObserver(self)
    }
}

extension CombineObserver6 {
    public static func & <T>(left: CombineObserver6, right: EasyScheduler<T>) -> CombineObserver7<V1, V2, V3, V4, V5, V6, T> {
        left.removeCombineObserver()
        let observer = CombineObserver7(scd1: left.scheduler1, scd2: left.scheduler2, scd3: left.scheduler3, scd4: left.scheduler4, scd5: left.scheduler5, scd6: left.scheduler6, scd7: right)
        observer.addCombineObserver()
        return observer
    }
}

/// CombineObserver8
public class CombineObserver8<V1, V2, V3, V4, V5, V6, V7, V8>: EasyCombineObserver<(V1, V2, V3, V4, V5, V6, V7, V8)> {
    fileprivate let scheduler1: EasyScheduler<V1>
    fileprivate let scheduler2: EasyScheduler<V2>
    fileprivate let scheduler3: EasyScheduler<V3>
    fileprivate let scheduler4: EasyScheduler<V4>
    fileprivate let scheduler5: EasyScheduler<V5>
    fileprivate let scheduler6: EasyScheduler<V6>
    fileprivate let scheduler7: EasyScheduler<V7>
    fileprivate let scheduler8: EasyScheduler<V8>
    
    fileprivate init(scd1: EasyScheduler<V1>, scd2: EasyScheduler<V2>, scd3: EasyScheduler<V3>, scd4: EasyScheduler<V4>, scd5: EasyScheduler<V5>, scd6: EasyScheduler<V6>, scd7: EasyScheduler<V7>, scd8: EasyScheduler<V8>) {
        scheduler1 = scd1
        scheduler2 = scd2
        scheduler3 = scd3
        scheduler4 = scd4
        scheduler5 = scd5
        scheduler6 = scd6
        scheduler7 = scd7
        scheduler8 = scd8
    }
    
    override func sendValue(for option: EasyObserveOptions) {
        guard options.contains(option) else {
            return
        }
        subscriber((scheduler1.lastValue, scheduler2.lastValue, scheduler3.lastValue, scheduler4.lastValue, scheduler5.lastValue, scheduler6.lastValue, scheduler7.lastValue, scheduler8.lastValue), option)
    }
    
    override func addCombineObserver() {
        scheduler1.addCombineObserver(self)
        scheduler2.addCombineObserver(self)
        scheduler3.addCombineObserver(self)
        scheduler4.addCombineObserver(self)
        scheduler5.addCombineObserver(self)
        scheduler7.addCombineObserver(self)
        scheduler8.addCombineObserver(self)
    }
    
    override func removeCombineObserver() {
        scheduler1.removeCombineObserver(self)
        scheduler2.removeCombineObserver(self)
        scheduler3.removeCombineObserver(self)
        scheduler4.removeCombineObserver(self)
        scheduler7.removeCombineObserver(self)
        scheduler8.removeCombineObserver(self)
    }
}

extension CombineObserver7 {
    public static func & <T>(left: CombineObserver7, right: EasyScheduler<T>) -> CombineObserver8<V1, V2, V3, V4, V5, V6, V7, T> {
        left.removeCombineObserver()
        let observer = CombineObserver8(scd1: left.scheduler1, scd2: left.scheduler2, scd3: left.scheduler3, scd4: left.scheduler4, scd5: left.scheduler5, scd6: left.scheduler6, scd7: left.scheduler7, scd8: right)
        observer.addCombineObserver()
        return observer
    }
}

extension CombineObserver8 {
    public static func & <T>(left: CombineObserver8, right: EasyScheduler<T>) -> CombineObserver8 {
        assertionFailure("The count of combined observers exceeds the maximum limit.")
        return left
    }
}
