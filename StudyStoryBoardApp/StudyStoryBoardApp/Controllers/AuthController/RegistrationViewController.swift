//
//  RegistrationViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 29.10.2022.
//

import UIKit

@IBDesignable class RegistrationViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var constraintRight: NSLayoutConstraint!
    @IBOutlet weak var constraintLeft: NSLayoutConstraint!
    @IBOutlet weak var succesImage: UIImageView!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    @IBOutlet weak var button: CustomButton!
    
    @IBOutlet weak var viewLog: UIView!
    @IBOutlet weak var viewPass: UIView!
    @IBOutlet weak var viewPassRepeat: UIView!
    
    @IBOutlet weak var textFieldLog: UITextField!
    @IBOutlet weak var textFieldNewPass: UITextField!
    @IBOutlet weak var textFieldReapeatPass: UITextField!
    
    @IBOutlet weak var alertViewPass: UIView!
    @IBOutlet weak var alertViewRepeatPass: UIView!
    @IBOutlet weak var alertViewLog: UIView!
    
    @IBOutlet weak var lableViewPass: UILabel!
    @IBOutlet weak var lableViewLog: UILabel!
    @IBOutlet weak var lableVievRepeatPass: UILabel!
    
    let alertBorderColor: UIColor = UIColor(red: 0.988, green: 0.239, blue: 0.282, alpha: 0.5)
    let defaultBorderColor: UIColor = UIColor(red: 0.902, green: 0.945, blue: 0.965, alpha: 1)
    
    //MARK: - Методы жизни ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(view: viewLog)
        setupView(view: viewPass)
        setupView(view: viewPassRepeat)
        setAlertLayer(view: alertViewLog)
        setAlertLayer(view: alertViewPass)
        setAlertLayer(view: alertViewRepeatPass)
        
        button.isTouched(true)
        
        textFieldLog.delegate = self
        textFieldNewPass.delegate = self
        textFieldReapeatPass.delegate = self
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
    
    
    //MARK: - Регистрация
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    @IBAction func succesRegistratin(_ sender: Any) {
        guard let log = textFieldLog.text,
              let pass = textFieldNewPass.text,
              let passRepeat = textFieldReapeatPass.text
        else { return }
        
        self.view.endEditing(true)
        
        if log != "" && pass != "" && passRepeat != "" {
            if pass.description == passRepeat.description {
                user.login = log
                user.password = pass
                animationLoading()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { self.performSegue(withIdentifier: "succesRegistration", sender: nil) }
            } else {
                alertsUser(view: viewPassRepeat, alertViewRepeatPass, lableVievRepeatPass, "Пароли не совпадают")
                alertsUser(view: viewPass, nil, nil, nil)
            }
        }
        if log == "" { alertsUser(view: viewLog, alertViewLog, nil, nil) }
        if pass == "" { alertsUser(view: viewPass, alertViewPass, nil, nil) }
        if passRepeat == "" { alertsUser(view: viewPassRepeat, alertViewRepeatPass, lableVievRepeatPass, "Поле не заполнено") }
    }
    
    
    //MARK: - Анимация загрузки
    
    @objc func animationLoading() {
        
        let textFieldColor = UIColor(cgColor: CGColor(red: 0.902, green: 0.945, blue: 0.965, alpha: 1)).cgColor
        let lableTextFieldColor = UIColor(red: 0, green: 0.231, blue: 0.333, alpha: 1)
        
        textFieldLog.isUserInteractionEnabled = false
        textFieldNewPass.isUserInteractionEnabled = false
        textFieldReapeatPass.isUserInteractionEnabled = false
        button.isTouched(false)
        
        UIView.animate(withDuration: 0.2, delay: 0.2) { [weak self] in
            guard let self = self else { return }
            
            self.button.layer.cornerRadius = 32
            self.viewLog.layer.backgroundColor = textFieldColor
            self.viewPass.layer.backgroundColor = textFieldColor
            self.viewPassRepeat.layer.backgroundColor = textFieldColor
            self.textFieldLog.textColor = lableTextFieldColor
            self.textFieldNewPass.textColor = lableTextFieldColor
            self.textFieldReapeatPass.textColor = lableTextFieldColor
        } completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) { [weak self] in
                guard let self = self else { return }
                self.constraintLeft.constant = 163
                self.constraintRight.constant = 163
                self.button.titleLabel?.alpha = 0
                self.activityLoading.alpha = 1
                self.viewLoading.alpha = 1
                self.button.layoutIfNeeded()
            } completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 1.7) { [weak self] in
                    guard let self = self else { return }
                    
                    self.button.layer.cornerRadius = 32
                    self.activityLoading.alpha = 0
                    self.succesImage.alpha = 1
                }
            }
        }
    }
    
    //MARK: - Ошибки пользователя
    
    func alertsUser(view: UIView, _ subView: UIView?,_ label: UILabel?, _ labelText: String?) {
        
        let alertColor = alertBorderColor.cgColor
        let defaultColor = defaultBorderColor.cgColor
        
        if let subView = subView {
            
            view.layer.borderColor = alertColor
            subView.alpha = 1
            if let label = label, let labelText = labelText { label.text = labelText }
            
            UIView.animate(withDuration: 2, delay: 2, options: .allowUserInteraction) {
                view.layer.borderColor = defaultColor
                subView.alpha = 0
            }
        } else {
            view.layer.borderColor = alertColor
            UIView.animate(withDuration: 2, delay: 2, options: .allowUserInteraction) {
                view.layer.borderColor = defaultColor
            }
        }
    }
    
    //MARK: - Настройка View
    
    public func setAlertLayer(view: UIView) {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Gradient")
        imageView.frame = view.bounds
        view.insertSubview(imageView, belowSubview: view.subviews[0])
    }
    
    public func setupView(view: UIView) {
        view.layer.borderColor = defaultBorderColor.cgColor
        view.layer.borderWidth = 1
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
    
    
    //MARK: - Перемещение по TextField при нажати кнопки return
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textFieldLog == textField {
            textFieldNewPass.becomeFirstResponder()
        } else if textFieldNewPass == textField {
            textFieldReapeatPass.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        return true
    }
    
    deinit {
        print("Delete RegistrationController")
    }
}

