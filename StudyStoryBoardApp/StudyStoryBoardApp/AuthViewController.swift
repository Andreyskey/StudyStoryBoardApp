//
//  AuthViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 12.10.2022.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var buttonShowPass: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
            // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            // Второе — когда она пропадает
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func authSucces(_ sender: Any) {
        let (log, pass) = ("aaa", "123")
        
        if (log, pass) == (login.text, password.text) {
            print("OK")
        } else {
            print("NOT OK")
        }
    }
    
    @IBAction func showPass(_ sender: Any) {
        
        let isHiddenPass = password.isSecureTextEntry
        
        if isHiddenPass {
            buttonShowPass.setImage(UIImage(systemName: "eye.slash", withConfiguration: UIImage.SymbolConfiguration(scale: .small)), for: .normal)
            password.isSecureTextEntry = false
        } else {
            buttonShowPass.setImage(UIImage(systemName: "eye", withConfiguration: UIImage.SymbolConfiguration(scale: .small)), for: .normal)
            password.isSecureTextEntry = true
        }
        
    }
    
    
    //MARK: - Keyboard + Constrains
    
    @objc func keyboardWasShow(notification: Notification) {
        
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) { // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    
}
