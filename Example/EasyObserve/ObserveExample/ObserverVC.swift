//
//  ViewController.swift
//  EasyObserve_Example
//
//  Created by Aiwei on 2022/4/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import EasyObserve

class ObserverVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var ageSlider: UISlider!
    
    init(editedUser: UserModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        if let editedUser = editedUser {
            self.user = editedUser
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy var user = UserModel(name: "小明", gender: .male, age: 18)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSubviews()
    }
    
    private var nameObserver: Observer?
    private var genderObserver: Observer?
    private var ageObserver: Observer?
    
    
    func bindSubviews() {
        nameObserver = user.$name.observe(subscriber: {[unowned self] value, change, option in
            self.title = value
            self.nameLabel.text = value
            self.nameTextField.text = value
        })
        
        genderObserver = user.$gender.observe(subscriber: {[unowned self] value, change, option in
            self.genderLabel.text = value.showText
            self.genderSegment.selectedSegmentIndex = (value == .male) ? 0: 1
        })
        
        ageObserver = user.$age.observe(subscriber: {[unowned self] value, change, option in
            self.ageLabel.text = String(value)
            self.ageSlider.value = Float(value)
        })
    }
    
    @IBAction func changedName(_ sender: UITextField) {
        user.name = sender.text ?? ""
    }
    
    @IBAction func changedGender(_ sender: UISegmentedControl) {
        user.gender = (sender.selectedSegmentIndex == 0) ? .male: .female
    }
    
    @IBAction func changedAge(_ sender: UISlider) {
        user.age = Int(sender.value)
    }
    
    @IBAction func removeObserve(_ sender: UIButton) {
        
//        nameObserver?.invalidate()
//        genderObserver?.invalidate()
//        ageObserver?.invalidate()
        
        nameObserver = nil
        genderObserver = nil
        ageObserver = nil
    }
}

extension UserGender {
    var showText: String {
        self == .male ? "男": "女"
    }
}
