//
//  EasyObserve.swift
//  KXYZKit
//
//  Created by Aiwei on 2024/4/15.
//

import Foundation

// MARK: - EasyObserved
@MainActor
public protocol EasyObserved: AnyObject {
    typealias EasyObservable<Value>  = EasyObservableWrapper<Self, Value>
    
    typealias EasyObservableWeak<Value: AnyObject>  = EasyObservableWeakWrapper<Self, Value>
}

// MARK: - EasyObserving
@MainActor
public protocol EasyObserving: EasyNamespace, AnyObject {}

extension EasyObserving {
    fileprivate var observerBag: EasyObserverBag {
        if let table = objc_getAssociatedObject(self, &observingTableKey) as? EasyObserverBag {
            return table
        } else {
            let table = EasyObserverBag()
            objc_setAssociatedObject(self, &observingTableKey, table, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return table
        }
    }
    
    fileprivate func cleanObseverBag() {
        observerBag.removeAll()
    }
}

private var observingTableKey: UInt8 = 0

extension EasyExtension where T: EasyObserving {
    @MainActor
    public var observerBag: EasyObserverBag {
        this.observerBag
    }
    
    @MainActor
    public func cleanObseverBag() {
        this.cleanObseverBag()
    }
}

// MARK: - EasyObserve
public typealias EasyObserve = EasyObserved & EasyObserving
