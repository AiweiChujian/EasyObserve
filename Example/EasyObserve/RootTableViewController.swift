//
//  RootTableViewController.swift
//  EasyObserve_Example
//
//  Created by Aiwei on 2022/4/19.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class RootTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            navigationController?.pushViewController(ObserverVC(), animated: true)
        case (0, 1):
            navigationController?.pushViewController(UnionObserverVC(), animated: true)
        case (0, 2):
            navigationController?.pushViewController(DistinctObserverVC(), animated: true)
        default:
            break
        }
    }
}
