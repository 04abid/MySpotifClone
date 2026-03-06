//
//  AlertExtension.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 27.02.26.
//

import UIKit


extension UIViewController {
    func createAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    }
    
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }
}
