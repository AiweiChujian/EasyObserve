//
//  UserModel.swift
//  EasyObserve_Example
//
//  Created by Aiwei on 2022/4/15.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import EasyObserve

enum UserGender: Equatable {
    case male, female
}

class UserModel: EasyObserved {
    @EasyObservable var name: String
    @EasyObservable var gender: UserGender
    @EasyObservable var age: Int
        
    init(name: String, gender: UserGender, age: Int) {
        self.name = name
        self.gender = gender
        self.age = age
    }
}

typealias UserModelObserver = EasyObserverMap<UserModel>
