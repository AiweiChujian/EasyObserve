//
//  ObserverBagVC.swift
//  EasyObserve_Example
//
//  Created by Aiwei on 2022/4/21.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import EasyObserve

class ObserverBagVC: ObserverVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Observer Bag"
    }
    
    let observerBag = EasyObserverBag()
    override func bindSubviews() {
        observerBag += user.$name.observe(subscriber: {[unowned self] value, change, option in
            self.nameLabel.text = value
            self.nameTextField.text = value
        })
        
        observerBag += user.$gender.observe(subscriber: {[unowned self] value, change, option in
            self.genderLabel.text = value.showText
            self.genderSegment.selectedSegmentIndex = (value == .male) ? 0: 1
        })
        
        observerBag += user.$age.observe(subscriber: {[unowned self] value, change, option in
            self.ageLabel.text = String(value)
            self.ageSlider.value = Float(value)
        })
    }

    
    override func removeObserve(_ sender: UIButton) {
        // 调用 invalidate 之后, 不能再向 observerBag 添加观察者
//        observerBag.invalidate()
        
        observerBag.removeAll()
    }
}
