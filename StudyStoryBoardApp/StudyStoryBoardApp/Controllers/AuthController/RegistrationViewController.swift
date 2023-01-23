//
//  RegistrationViewController.swift
//  StudyStoryBoardApp
//
//  Created by Андрей Волков on 29.10.2022.
//

import UIKit
import WebKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var webKitView: WKWebView!
    @IBOutlet weak var updateButton: UIBarButtonItem!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateButton.isHidden = true
        loadingIndicator.startAnimating()
        
        webKitView.navigationDelegate = self
        authUrl()
    }
    
    @IBAction func updatePage(_ sender: Any) {
        webKitView.reloadFromOrigin()
        authUrl()
    }
    
    func authUrl() {
        var url = URLComponents()
        url.scheme = "https"
        url.host = "oauth.vk.com"
        url.path = "/authorize"
        url.queryItems = [
            URLQueryItem(name: "client_id", value: "8025529"),
            URLQueryItem(name: "redirect_url", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "revoke", value: "1"),
            URLQueryItem(name: "scope", value: "140488159")
        ]
        
        let req = URLRequest(url: url.url!)
        webKitView.load(req)
    }
}

extension RegistrationViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)  {
        
        guard let url = navigationResponse.response.url,
              url.path() == "/blank.html",
              let fragment = url.fragment
        else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment.components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { partialResult, param in
                
                var dict = partialResult
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
            }
        Session.share.token = params["access_token"]!
        Session.share.userId = params["user_id"]!
        
        print(Session.share.token)
        
        decisionHandler(.allow)
        
        if Session.share.token != "" {
            performSegue(withIdentifier: "succesAuth", sender: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            let notifyName = Notification.Name("succes")
            NotificationCenter.default.post(Notification(name: notifyName))
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateButton.isHidden = false
        loadingIndicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        updateButton.isHidden = true
        loadingIndicator.isHidden = false
    }
}
