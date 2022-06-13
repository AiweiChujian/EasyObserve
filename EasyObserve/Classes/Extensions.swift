//
//  Extensions.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/6/13.
//

import Foundation

public struct EZNamespace<T> {
    public let base: T
    
    fileprivate init(_ base: T) {
        self.base = base
    }
}

public protocol EZNamespaceProtocol {}

public extension EZNamespaceProtocol {
    var ez: EZNamespace<Self> {
        EZNamespace(self)
    }
    
    static var ez: EZNamespace<Self>.Type {
        EZNamespace<Self>.self
    }
}

extension NSObject: EZNamespaceProtocol {}

//MARK: - extensions

//MARK: NotificationCenter
fileprivate extension NotificationCenter {
    func easyObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> EasyNotificationObserver {
        EasyNotificationObserver(center: self, handle: addObserver(forName: name, object: obj, queue: queue, using: block))
    }
}

public extension EZNamespace where T == NotificationCenter {
    func addObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> EasyNotificationObserver {
        base.easyObserver(forName: name, object: obj, queue: queue, using: block)
    }
}
