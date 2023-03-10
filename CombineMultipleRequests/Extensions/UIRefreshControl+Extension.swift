//
//  UIRefreshControl+Extension.swift
//  CombineMultipleRequests
//
//  Created by Artem Ekimov on 3/10/23.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
