//
//  EasyObserve.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/7/28.
//

import Foundation

public typealias EasyObserve = EasyObserved & EasyObserving

//MARK: - Observed
public protocol EasyObserved: AnyObject {
    typealias Observable<Value>  = ObservableWrapper<Self, Value>
    
    typealias Weak<Value: AnyObject>  = WeakWrapper<Self, Value>
}

//MARK: - Observing
public protocol EasyObserving: EZNamespace, AnyObject {}

extension EasyObserving {
    fileprivate var observingTable: UnionObserver {
        if let table = objc_getAssociatedObject(self, &unionObserverKey) as? UnionObserver {
            return table
        } else {
            let table = UnionObserver()
            objc_setAssociatedObject(self, &unionObserverKey, table, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return table
        }
    }
    
    fileprivate func cleanObservingTable() {
        observingTable.removeAll()
    }
}

private var unionObserverKey: UInt8 = 0

extension EZExtension where T: EasyObserving {
    public var observingTable: UnionObserver {
        this.observingTable
    }
    
    public func cleanObservingTable() {
        this.cleanObservingTable()
    }
}

extension ObserverType {
    public func held(by table: UnionObserver) {
        table += self
    }
}
