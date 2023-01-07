//
//  AuthViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 12.10.2022.
//

import UIKit

class AuthViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var constraintRight: NSLayoutConstraint!
    @IBOutlet weak var buttonLogIn: CustomButton!
    @IBOutlet weak var succesLogin: UIImageView!
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var registrationButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    @IBOutlet weak var alertWrongLog: UIView!
    @IBOutlet weak var alertWrongPass: UIView!
    
    
    //MARK: - Циклы жзини ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(view: viewLogin)
        setupView(view: viewPassword)
        
        setAlertLayer(view: alertWrongLog)
        setAlertLayer(view: alertWrongPass)
        
        login.delegate = self
        password.delegate = self
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
    

    
    //MARK: - Настройка стандартного вида view
    
    public func setAlertLayer(view: UIView) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Gradient")
        imageView.frame = view.bounds
        view.insertSubview(imageView, belowSubview: view.subviews[0])
    }
    
    public func setupView(view: UIView) {
        view.layer.borderColor = UIColor(red: 0.902, green: 0.945, blue: 0.965, alpha: 1).cgColor
        view.layer.borderWidth = 1
    }
    
    
    
    //MARK: - Проверка логина и пароля + unwind segue
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    @IBAction func buttonLogin(_ sender: Any) {
        registrationButton.isUserInteractionEnabled = false
        guard let log = login.text,
              let pass = password.text
        else { return }
        
        self.view.endEditing(true)
        
        if log == user.login && pass == user.password && log != "" && pass != "" {
             animationLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            showLoginError()
        }
        
    }
    
    func showLoginError() {
        guard let alertLog = alertWrongLog.subviews[1] as? UILabel,
              let alertPass = alertWrongPass.subviews[1] as? UILabel else { return }
        
        if login.text == "" {
            alertLog.text = "Введите логин"
        }
        if password.text == "" {
            alertPass.text = "Введите пароль"
        }
        if login.text != "" {
            alertLog.text = "Неверный логин"
        }
        if password.text != "" {
            alertPass.text = "Неверный пароль"
        }
        
        animationDefaultBounds()
    }
    
    @IBAction func unwindToAuth(_ unwindSegue: UIStoryboardSegue) {
        // Временное решение пока не разберусь в ARC и утечки памяти
        login.isUserInteractionEnabled = true
        password.isUserInteractionEnabled = true
        buttonLogIn.layer.cornerRadius = 20
        buttonLogIn.titleLabel?.alpha = 1
        constraintRight.constant = 32
        succesLogin.alpha = 0
        login.textColor = UIColor(red: 0, green: 0.231, blue: 0.333, alpha: 1)
        password.textColor = UIColor(red: 0, green: 0.231, blue: 0.333, alpha: 1)
        setupView(view: viewLogin)
        setupView(view: viewPassword)
        buttonLogIn.isUserInteractionEnabled = true
        login.text = ""
        password.text = ""
        viewLogin.layer.backgroundColor = UIColor.white.cgColor
        viewPassword.layer.backgroundColor = UIColor.white.cgColor
        buttonLogIn.isTouched(true)
        buttonLogIn.layoutIfNeeded()
        registrationButton.isUserInteractionEnabled = true
        
    }
    
    //MARK: - Анимации загрузки и ошибок
    
    func animationDefaultBounds() {
        
        if login.text != user.login {
            viewLogin.layer.borderColor = UIColor(red: 0.988, green: 0.239, blue: 0.282, alpha: 0.5).cgColor
            alertWrongLog.alpha = 1
            UIView.animate(withDuration: 2, delay: 2, options: .allowUserInteraction) { [weak self] in
                guard let self = self else { return }
                
                self.setupView(view: self.viewLogin)
                self.alertWrongLog.alpha = 0
            }
        }
        if password.text != user.password {
            viewPassword.layer.borderColor = UIColor(red: 0.988, green: 0.239, blue: 0.282, alpha: 0.5).cgColor
            alertWrongPass.alpha = 1
            UIView.animate(withDuration: 2, delay: 2, options: .allowUserInteraction) { [weak self] in
                guard let self = self else { return }
                
                self.setupView(view: self.viewPassword)
                self.alertWrongPass.alpha = 0
            }
        }
    }
    
    func animationLoading() {
        
        buttonLogIn.isTouched(false)
        
        let textFieldColor = UIColor(cgColor: CGColor(red: 0.90, green: 0.95, blue: 0.96, alpha: 1.00)).cgColor
        let lableTextFieldColor = UIColor(red: 0, green: 0.231, blue: 0.333, alpha: 1)
        
        login.isUserInteractionEnabled = false
        password.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.2, delay: 0.2) { [weak self] in
            guard let self = self else { return }
            
            self.viewLogin.layer.backgroundColor = textFieldColor
            self.viewPassword.layer.backgroundColor = textFieldColor
            self.login.textColor = lableTextFieldColor
            self.password.textColor = lableTextFieldColor
        } completion: { _ in
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

    //MARK: - Открытие контроллера регистрации
    
    @IBAction func createAccount(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController")
        
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.custom(resolver: { context in
                return 562
            })]
            sheet.preferredCornerRadius = 32
        }
        self.present(viewController, animated: true)
    }
    
    //MARK: - Перемещение по TextField при нажати кнопки return
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if login == textField {
            password.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        return true
    }
    
    deinit {
        print("Delete AuthController")
    }
}


