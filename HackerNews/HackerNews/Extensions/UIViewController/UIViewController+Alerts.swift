//
//  UIViewController+Alerts.swift
//  HackerNews
//
//  Created by Alexander Nazarov on 11/4/18.
//  Copyright © 2018 nazavrik. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "", message: String = "", completion: (()->Void)? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel) { action in
            completion?()
        }
        controller.addAction(okAction)
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
//    func showErrorAlert(_ message: String, completion: (() -> Void)? = nil) {
//        showAlert(title: "Error", message: message, completion: completion)
//    }
//    
//    func showAlert(for error: ServerError?, completion: (() -> Void)? = nil) {
//        let message = error?.description ?? ServerError.Constants.defaultError
//        
//        showAlert(title: "Error", message: message, completion: completion)
//    }
}
