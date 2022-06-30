//
//  Noticeboard.swift
//  EasyObserve_Example
//
//  Created by Aiwei on 2022/4/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import EasyObserve

struct Noticeboard {
    private init() {}
    
    /// Notice
    class Notice<UserInfo>: EasyObserve {
        @Observable private(set)  var userInfo: UserInfo?

        func post(_ userInfo: UserInfo) {
            self.userInfo = userInfo
            self.userInfo = nil
        }
        
        func addObserve(_ subscriber: @escaping (UserInfo) -> Void) -> Observer {
            $userInfo.observe(options: .new) { value, change, option in
                guard let userInfo = value else {
                    return
                }
                subscriber(userInfo)
            }
        }
    }
} 
