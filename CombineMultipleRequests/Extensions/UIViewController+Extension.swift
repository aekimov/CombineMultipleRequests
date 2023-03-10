//
//  UIViewController+Extension.swift
//  CombineMultipleRequests
//
//  Created by Artem Ekimov on 3/10/23.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        self.present(alert, animated: true)
    }
}

