//
//  AuthViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 12.10.2022.
//

import UIKit
import Alamofire
import RealmSwift

class AuthViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var group6backround: UIImageView!
    @IBOutlet weak var group5backround: UIImageView!
    @IBOutlet weak var group4backround: UIImageView!
    @IBOutlet weak var group3backround: UIImageView!
    @IBOutlet weak var backroundImage: UIImageView!
    @IBOutlet weak var secondImageBackround: UIImageView!
    
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
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
            self.group3backround.alpha = 1
            self.group4backround.alpha = 1
            self.group5backround.alpha = 1
            self.group6backround.alpha = 1
            self.backroundImage.alpha = 0.5
            self.secondImageBackround.alpha = 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(animate), name: startApp, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goToApp), name: Notification.Name("succes"), object: nil)
        NotificationCenter.default.post(Notification(name: startApp))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
        buttonLogIn.layer.cornerRadius = 20
        buttonLogIn.titleLabel?.alpha = 1
        constraintRight.constant = 32
        succesLogin.alpha = 0
        buttonLogIn.isUserInteractionEnabled = true
        buttonLogIn.isTouched(true)
        buttonLogIn.layoutIfNeeded()
    }
    
    // Анимация backroundImage
    @objc func animate() {
        print("subscribe succes")
        backroundImage.rotate(duration: 100, route: .left)
        secondImageBackround.rotate(duration: 120, route: .left)
        group3backround.rotate(duration: 80, route: .left)
        group4backround.rotate(duration: 60, route: .left)
        group5backround.rotate(duration: 40, route: .left)
        group6backround.rotate(duration: 20, route: .left)
    }
    
    @objc func goToApp() {
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    //MARK: - Анимации загрузки
    
    @IBAction func unwindToAuth(_ unwindSegue: UIStoryboardSegue) {
        guard let identifier = unwindSegue.identifier else { return }
        if identifier == "succesAuth" {
            UserDefaults().set(true, forKey: "isLogin")
            ServiseAPI().loadUserData()
            animationLoading()
        } else if identifier == "logoutApp" {
            UserDefaults().setValue(false, forKey: "isLogin")
            UserDefaults().removeObject(forKey: "token")
            UserDefaults().removeObject(forKey: "userID")
            try! Realm().write{
                try! Realm().deleteAll()
            }
        }
    }
    
    func animationLoading() {
        
        buttonLogIn.isTouched(false)
        
        UIView.animate(withDuration: 0.2, delay: 0.5, options: .curveEaseOut) { [weak self] in
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

//MARK: - Дополнения к контроллеру

extension UIImageView{
    func rotate(duration: Double, route: RouteRotate) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        if route == .left { rotation.toValue = NSNumber(value: Double.pi * 2) }
        else if route == .right { rotation.toValue = NSNumber(value: -Double.pi * 2) }
        rotation.duration = duration
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}

enum RouteRotate {
    case left
    case right
}
