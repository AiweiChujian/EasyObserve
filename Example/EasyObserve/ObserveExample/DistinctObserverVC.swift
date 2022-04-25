//
//  DistinctObserverVC.swift
//  EasyObserve_Example
//
//  Created by Aiwei on 2022/4/21.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import EasyObserve

class DistinctObserverVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Distinct Observer"
        tableView.register(Cell.self, forCellReuseIdentifier: NSStringFromClass(Cell.self))
    }
    
    let userArray = [UserModel(name: "小红", gender: .female, age: 18),
                     UserModel(name: "小绿", gender: .male, age: 28),
                     UserModel(name: "小蓝", gender: .male, age: 48)]
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return userArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(Cell.self), for: indexPath) as! Cell
        cell.setUser(userArray[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(ObserverVC(editedUser: userArray[indexPath.row]), animated: true, completion: nil)
    }
}

extension DistinctObserverVC {
    
    private class Cell: UITableViewCell {
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        let distinctObserver = UserModelObserver()
        
        func setUser(_ user: UserModel) {
            // DistinctObserver 中一个 keyPath 对应一个观察者, 不用手动移除对上一个 model 的观察
//            distinctObserver.removeAll()
            
            distinctObserver[\.name] = user.$name.observe(subscriber: {[unowned self] value, change, option in
                self.textLabel?.text = value
            })
            
            // DistinctObserver 管理 CombineObserver, 选择其中一个属性的 keyPath 作为下标即可
            distinctObserver[\.gender] = (user.$gender & user.$age).combineObserve(subscriber: { [unowned self] value, _ in
                self.detailTextLabel?.text = "\(value.0.showText) - \(value.1)"
            })
        }
    }
}
