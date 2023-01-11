//
//  AuthViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 12.10.2022.
//

import UIKit

class AuthViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backroundImage: UIImageView!
    
    @IBOutlet weak var constraintRight: NSLayoutConstraint!
    @IBOutlet weak var buttonLogIn: CustomButton!
    @IBOutlet weak var succesLogin: UIImageView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let startApp = Notification.Name("StartApp")
    
    //MARK: - Циклы жзини ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 1.5, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.backroundImage.alpha = 1
        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(animate), name: startApp, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: startApp, object: nil)
        
        buttonLogIn.layer.cornerRadius = 20
        buttonLogIn.titleLabel?.alpha = 1
        constraintRight.constant = 32
        succesLogin.alpha = 0
        buttonLogIn.isUserInteractionEnabled = true
        buttonLogIn.isTouched(true)
        buttonLogIn.layoutIfNeeded()
    }
    
    @objc func animate() {
        print("subscribe succes")
        backroundImage.rotate()
    }
    

    //MARK: - Проверка логина и пароля + unwind segue
    
    @IBAction func unwindToAuth(_ unwindSegue: UIStoryboardSegue) {
    
    }
    
    //MARK: - Анимации загрузки и ошибок
    
    func animationLoading() {

        buttonLogIn.isTouched(false)

        UIView.animate(withDuration: 0.2,delay: 0, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }

            self.buttonLogIn.layer.cornerRadius = 32
            self.constraintRight.constant = 163
            self.buttonLogIn.titleLabel?.alpha = 0
            self.activityLoading.alpha = 1
            self.viewLoading.alpha = 1
            self.buttonLogIn.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.7) { [weak self] in
                guard let self = self else { return }
                self.activityLoading.alpha = 0
                self.succesLogin.alpha = 1
            }
        }
    }
    
    
    
}

extension UIImageView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 60
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}
