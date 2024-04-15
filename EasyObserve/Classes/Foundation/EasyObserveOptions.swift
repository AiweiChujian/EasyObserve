//
//  EasyObserveOptions.swift
//  KXYZKit
//
//  Created by Aiwei on 2024/4/15.
//

import Foundation

public struct EasyObserveOptions: OptionSet {
    public static let initial = EasyObserveOptions(rawValue: 1 << 0)
    
    public static let prior = EasyObserveOptions(rawValue: 1 << 1)
    
    public static let new = EasyObserveOptions(rawValue: 1 << 2)
    
    public static let `defer` = EasyObserveOptions(rawValue: 1 << 3)
        
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public var isVaild: Bool {
        self.intersection([.initial, .prior, .new, .defer]) != EasyObserveOptions([])
    }
    
    public var isCombineVaild: Bool {
        // 合并观察时仅支持 .initial 和 .new
        let validOptions: EasyObserveOptions = [.initial, .new]
        return (self.intersection(validOptions) != EasyObserveOptions([])) && (self.symmetricDifference(validOptions) == EasyObserveOptions([]))
    }
}
