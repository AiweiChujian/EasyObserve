//
//  EasyNameSapce.swift
//  KXYZKit
//
//  Created by Aiwei on 2024/4/15.
//

import Foundation

public struct EasyExtension<T> {
    public let this: T
    
    fileprivate init(_ this: T) {
        self.this = this
    }
}

public protocol EasyNamespace {}

public extension EasyNamespace {
    var ez: EasyExtension<Self> {
        EasyExtension(self)
    }
    
    static var ez: EasyExtension<Self>.Type {
        EasyExtension<Self>.self
    }
}
