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

class UserModel: EasyObserve {
    @Observable var name: String
    @Observable var gender: UserGender
    @Observable var age: Int
    
    init(name: String, gender: UserGender, age: Int) {
        self.name = name
        self.gender = gender
        self.age = age
    }
    
//    deinit {
//        print("user[\(name)] deinit")
//    }
}

typealias UserModelObserver = DistinctObserver<UserModel>
