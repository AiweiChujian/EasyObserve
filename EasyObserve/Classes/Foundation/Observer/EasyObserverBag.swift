//
//  EasyObserverBag.swift
//  KXYZKit
//
//  Created by Aiwei on 2024/4/15.
//

import Foundation

@MainActor
public class EasyObserverBag {
    public init() {}
    
    private var list: [EasyObserverType]? = []
    
    public var count: Int { list?.count ?? 0 }
    
    public func removeObserve(observer: EasyObserverType) -> EasyObserverType? {
        guard let index = list?.firstIndex(where: {$0 === observer }) else {
            return nil
        }
        return list?.remove(at: index)
    }
    
    public func removeAll() {
        list?.removeAll()
    }
    
    public static func += (left: EasyObserverBag, right: EasyObserverType) {
        left.list?.append(right)
    }
}

extension EasyObserverBag: EasyObserverType {
    public func invalidate() {
        list?.forEach { $0.invalidate() }
        list = nil
    }
}

extension EasyObserverType {
    @MainActor
    public func held(by bag: EasyObserverBag) {
        bag += self
    }
}
