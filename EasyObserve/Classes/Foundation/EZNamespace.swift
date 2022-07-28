//
//  EZNamespace.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/7/28.
//

import Foundation

public struct EZExtension<T> {
    public let this: T
    
    fileprivate init(_ this: T) {
        self.this = this
    }
}

public protocol EZNamespace {}

public extension EZNamespace {
    var ez: EZExtension<Self> {
        EZExtension(self)
    }
    
    static var ez: EZExtension<Self>.Type {
        EZExtension<Self>.self
    }
}
