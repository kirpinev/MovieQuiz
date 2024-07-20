//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Igor Kirpinev on 18.07.2024.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func showAlert(alert: AlertModel) {        
        let alertController = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alert.buttonText, style: .default) {_ in
            alert.completion()
        }
        
        alertController.addAction(action)
        
        delegate?.present(alertController, animated: true, completion: nil)
    }
    
}
