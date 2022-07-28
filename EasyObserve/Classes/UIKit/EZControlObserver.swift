//
//  EZControlObserver.swift
//  EasyObserve
//
//  Created by Aiwei on 2022/7/28.
//

import UIKit

public final class EZControlObserver {
    public private(set) weak var control: UIControl?
    
    public let event: UIControl.Event
    
    private var handler: EZActionHandlerType?
    
    public init<T: UIControl>(_ control: T, event: UIControl.Event, actionHandler: @escaping (T) -> Void) {
        self.control = control
        self.event = event
        self.handler = EZActionHandler(actionHandler: actionHandler)
        control.addTarget(self, action: #selector(controlAction(_:)), for: event)
    }
    
    @objc private func controlAction(_ control: UIControl) {
        handler?.sendAction(sender: control)
    }
}

fileprivate protocol EZActionHandlerType {
    func sendAction(sender: UIControl)
}

fileprivate struct EZActionHandler<T>: EZActionHandlerType {
    let actionHandler: (T) -> Void
    
    func sendAction(sender: UIControl) {
        guard let sender = sender as? T else {
            return
        }
        actionHandler(sender)
    }
}

extension EZControlObserver: ObserverType {
    public func invalidate() {
        control?.removeTarget(self, action: #selector(controlAction(_:)), for: event)
        handler = nil
    }
}
