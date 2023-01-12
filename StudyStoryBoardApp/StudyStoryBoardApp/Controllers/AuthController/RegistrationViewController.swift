//
//  RegistrationViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 29.10.2022.
//

import UIKit
import WebKit

@IBDesignable class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var webKitView: WKWebView!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func updatePage(_ sender: Any) {
    }
}

