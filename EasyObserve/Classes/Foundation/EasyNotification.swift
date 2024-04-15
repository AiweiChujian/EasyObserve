//
//  EasyNotification.swift
//  KXYZKit
//
//  Created by Aiwei on 2024/4/15.
//

import Foundation

public class EasyNotification<UserInfoType> {
    public private(set) var info: UserInfoType
    
    private var name: NSNotification.Name!
    
    public init(_ value: UserInfoType) {
        self.info = value
        self.name = Notification.Name("\(type(of: self))-\(Unmanaged.passUnretained(self).toOpaque())")
    }
    
    private let userInfoKey =  "com.easyNotification.kUserInfo"
    
    public func post(_ userInfo: UserInfoType, via center: NotificationCenter = .default) {
        info = userInfo
        center.post(name: name, object: self, userInfo: [userInfoKey: userInfo])
    }
    
    public func addObserver(from center: NotificationCenter = .default, queue: OperationQueue?, using block: @escaping (Notification, UserInfoType)-> Void) -> EasyNotificationObserver {
        let userInfoKey = userInfoKey
        let handle = center.addObserver(forName: name, object: self, queue: queue) { notification in
            guard let userInfo = notification.userInfo?[userInfoKey] as? UserInfoType else {
                return
            }
            block(notification, userInfo)
        }
        return EasyNotificationObserver(center: center, handle: handle)
    }
}

public class EasyNotificationObserver {
    private weak var center: NotificationCenter?
    
    private weak var handle: NSObjectProtocol?
    
    init(center: NotificationCenter, handle: NSObjectProtocol) {
        self.center = center
        self.handle = handle
    }
    
    deinit {
        center?.removeObserver(handle as Any)
    }
}

extension EasyNotificationObserver: EasyObserverType {
    public func invalidate() {
        center?.removeObserver(handle as Any)
    }
}

//MARK: - NotificationCenter
extension NotificationCenter: EasyNamespace {}

fileprivate extension NotificationCenter {
    func easyObserver(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping (Notification) -> Void) -> EasyNotificationObserver {
        EasyNotificationObserver(center: self, handle: addObserver(forName: name, object: obj, queue: queue, using: block))
    }
}

public extension EasyExtension where T == NotificationCenter {
    func addObserver(forName name: NSNotification.Name?, queue: OperationQueue?, object obj: Any? = nil, using block: @escaping (Notification) -> Void) -> EasyNotificationObserver {
        this.easyObserver(forName: name, object: obj, queue: queue, using: block)
    }
}
