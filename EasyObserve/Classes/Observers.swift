//
//  Observers.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/4/15.
//

import Foundation
import UIKit

//MARK: - Observer
public class Observer {
    var singleObserver: AnyObject?
    
    init(_ singleObserver: AnyObject?) {
        self.singleObserver = singleObserver
    }
}

//MARK: - UnionObserver
public class UnionObserver {
    private var observerList: [Observer]? = []
    
    public var count: Int { observerList?.count ?? 0 }
    
    public func removeObserve(observer: Observer) -> Observer? {
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
    public static func += (left: UnionObserver, right: Observer) {
        left.observerList?.append(right)
    }
}

//MARK: - DistinctObserver
public class DistinctObserver<T> {
    private var observerMap: [PartialKeyPath<T>: Observer]? = [:]
    
    public var count: Int { observerMap?.count ?? 0 }
    
    public func removeObserve<Value>(keyPath: KeyPath<T, Value>) -> Observer? {
        observerMap?.removeValue(forKey: keyPath)
    }
    
    public func removeObserve(observer: Observer) -> Observer? {
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
    public struct KeyPathHandle {
        public static func -= (left: KeyPathHandle, right: Observer) {
            left.observer?.observerMap?[left.keyPath] = right
        }
        
        let keyPath: PartialKeyPath<T>
        
        private(set) weak var observer: DistinctObserver?
    }
    
    public subscript<Value>(keyPath: KeyPath<T, Value>) -> KeyPathHandle {
        KeyPathHandle(keyPath: keyPath, observer: self)
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
