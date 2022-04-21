//
//  UnionObserverVC.swift
//  EasyObserve_Example
//
//  Created by Aiwei on 2022/4/21.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import EasyObserve

class UnionObserverVC: ObserverVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Union Observer"
    }
    
    let unionObserver = UnionObserver()
    override func bindSubviews() {
        unionObserver += user.$name.observe(subscriber: {[unowned self] value, change, option in
            self.nameLabel.text = value
            self.nameTextField.text = value
        })
        
        unionObserver += user.$gender.observe(subscriber: {[unowned self] value, change, option in
            self.genderLabel.text = value.showText
            self.genderSegment.selectedSegmentIndex = (value == .male) ? 0: 1
        })
        
        unionObserver += user.$age.observe(subscriber: {[unowned self] value, change, option in
            self.ageLabel.text = String(value)
            self.ageSlider.value = Float(value)
        })
    }

    
    override func removeObserve(_ sender: UIButton) {
        // 调用 invalidate 之后, 不能再向 unionObserver 添加观察者
//        unionObserver.invalidate()
        
        unionObserver.removeAll()
    }
}
