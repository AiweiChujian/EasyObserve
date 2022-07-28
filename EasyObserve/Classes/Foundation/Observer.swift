//
//  Observer.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/4/15.
//

import Foundation

//MARK: - Observer
public class Observer {
    var singleObserver: AnyObject?
    
    init(_ singleObserver: AnyObject?) {
        self.singleObserver = singleObserver
    }
    
    public static func bind<T: AnyObject, Value>(_ object: T, _ keyPath: WritableKeyPath<T, Value>, _ scheduler: Scheduler<Value>) -> Observer {
        scheduler.observe {[weak object] value, change, option in
            object?[keyPath: keyPath] = value
        }
    }
}

//MARK: - UnionObserver
public class UnionObserver {
    public init() {}
    
    private var observerList: [ObserverType]? = []
    
    public var count: Int { observerList?.count ?? 0 }
    
    public func removeObserve(observer: ObserverType) -> ObserverType? {
        guard let index = observerList?.firstIndex(where: {$0 === observer }) else {
            return nil
        }
        return observerList?.remove(at: index)
    }
    
    public func removeAll() {
        observerList?.removeAll()
    }
}

extension UnionObserver {
    public static func += (left: UnionObserver, right: ObserverType) {
        left.observerList?.append(right)
    }
}

//MARK: - DistinctObserver
public class DistinctObserver<T> {
    public init() {}
    
    private var observerMap: [PartialKeyPath<T>: ObserverType]? = [:]
    
    public var count: Int { observerMap?.count ?? 0 }
    
    public func removeObserve<Value>(keyPath: KeyPath<T, Value>) -> ObserverType? {
        observerMap?.removeValue(forKey: keyPath)
    }
    
    public func removeObserve(observer: ObserverType) -> ObserverType? {
        guard let index = observerMap?.firstIndex(where: {$0.value === observer }) else {
            return nil
        }
        return observerMap?.remove(at: index).value
    }
    
    public func removeAll() {
        observerMap?.removeAll()
    }
}

extension DistinctObserver {
    public subscript<Value>(keyPath: KeyPath<T, Value>) -> ObserverType? {
        get { observerMap?[keyPath]}
        set { observerMap?[keyPath] = newValue }
    }
}

//MARK: - ObserverType
public protocol ObserverType: AnyObject {
    func invalidate()
}

extension Observer: ObserverType {
    public func invalidate() {
        singleObserver = nil
    }
}

extension UnionObserver: ObserverType {
    public func invalidate() {
        observerList?.forEach { $0.invalidate() }
        observerList = nil
    }
}

extension DistinctObserver: ObserverType {
    public func invalidate() {
        observerMap?.values.forEach { $0.invalidate() }
        observerMap = nil
    }
}
