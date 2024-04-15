//
//  EasyObserverMap.swift
//  KXYZKit
//
//  Created by Aiwei on 2024/4/15.
//

import Foundation

@MainActor
public class EasyObserverMap<T> {
    public init() {}
    
    private var map: [PartialKeyPath<T>: EasyObserverType]? = [:]
    
    public var count: Int { map?.count ?? 0 }
    
    public func removeObserve<Value>(keyPath: KeyPath<T, Value>) -> EasyObserverType? {
        map?.removeValue(forKey: keyPath)
    }
    
    public func removeObserve(observer: EasyObserverType) -> EasyObserverType? {
        guard let index = map?.firstIndex(where: {$0.value === observer }) else {
            return nil
        }
        return map?.remove(at: index).value
    }
    
    public func removeAll() {
        map?.removeAll()
    }
    
    public subscript<Value>(keyPath: KeyPath<T, Value>) -> EasyObserverType? {
        get { map?[keyPath]}
        set { map?[keyPath] = newValue }
    }
}

extension EasyObserverMap: EasyObserverType {
    public func invalidate() {
        map?.values.forEach { $0.invalidate() }
        map = nil
    }
}
