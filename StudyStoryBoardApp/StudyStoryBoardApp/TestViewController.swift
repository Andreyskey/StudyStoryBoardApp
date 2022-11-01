//
//  TestViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 29.10.2022.
//

import UIKit

@IBDesignable class TestViewController: UIViewController {

    @IBOutlet weak var checkSuccess: UIImageView!
    
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var startAnim: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var lable: UILabel!
    @IBOutlet weak var Button: UIView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var isAnimate = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Button.layer.cornerRadius = 20
        loadingView.layer.cornerRadius = 32
        checkSuccess.alpha = 0
        
        startAnim.addTarget(self, action: #selector(animate), for: .touchUpInside)
    }
        
        //MARK: - Новая реализация анимации
    
    @objc func animate() {
        
        if !isAnimate {
            animationLoading()
            isAnimate = true
        } else {
            defaultState()
            isAnimate = false
        }
    }
    
    func animationLoading() {
        UIView.animate(withDuration: 0.3, delay: 0.2) {
            self.Button.layer.cornerRadius = 32
        }
        self.rightConstraint.constant = 163
        self.leftConstraint.constant = 163
        UIView.animate(withDuration: 0.3,delay: 0.1) {
            self.loadingView.alpha = 1
            self.lable.alpha = 0
            self.Button.layoutIfNeeded()
        }
        completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5) {
                self.loading.alpha = 0
                self.checkSuccess.alpha = 1
            }
        }
    }
    
    func defaultState() {
        self.rightConstraint.constant = 32
        self.leftConstraint.constant = 32
        UIView.animate(withDuration: 0.5) {
            self.loadingView.alpha = 0
            self.lable.alpha = 1
            self.Button.layoutIfNeeded()
            self.Button.layer.cornerRadius = 20
            self.loading.alpha = 1
            self.checkSuccess.alpha = 0
        }
    }
}
