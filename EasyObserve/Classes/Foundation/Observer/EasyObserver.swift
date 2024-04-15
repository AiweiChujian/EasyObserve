//
//  EasyObserver.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/4/15.
//

import Foundation

public protocol EasyObserverType: AnyObject {
    func invalidate()
}

// MARK: EasyObserver
@MainActor
public final class EasyObserver {
    var observer: AnyObject?
    
    init(_ realObserver: AnyObject?) {
        self.observer = realObserver
    }
    
    public static func bind<T: AnyObject, Value>(_ object: T, _ keyPath: WritableKeyPath<T, Value>, _ scheduler: EasyScheduler<Value>) -> EasyObserver {
        scheduler.observe {[weak object] value, change, option in
            object?[keyPath: keyPath] = value
        }
    }
}

extension EasyObserver: EasyObserverType {
    public func invalidate() {
        observer = nil
    }
}
