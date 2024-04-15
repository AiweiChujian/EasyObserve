//
//  EZControlObserver.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/7/28.
//

import Foundation

@MainActor
public final class EasyControlObserver {
    public private(set) weak var control: UIControl?
    
    public let event: UIControl.Event
    
    private var handler: EasyActionHandlerType?
    
    public init<T: UIControl>(_ control: T, event: UIControl.Event, actionHandler: @escaping (T) -> Void) {
        self.control = control
        self.event = event
        self.handler = EasyActionHandler(actionHandler: actionHandler)
        control.addTarget(self, action: #selector(controlAction(_:)), for: event)
    }
    
    @objc private func controlAction(_ control: UIControl) {
        handler?.sendAction(sender: control)
    }
}

fileprivate protocol EasyActionHandlerType {
    func sendAction(sender: UIControl)
}

fileprivate struct EasyActionHandler<T>: EasyActionHandlerType {
    let actionHandler: (T) -> Void
    
    func sendAction(sender: UIControl) {
        guard let sender = sender as? T else {
            return
        }
        actionHandler(sender)
    }
}

extension EasyControlObserver: EasyObserverType {
    public func invalidate() {
        control?.removeTarget(self, action: #selector(controlAction(_:)), for: event)
        handler = nil
    }
}
