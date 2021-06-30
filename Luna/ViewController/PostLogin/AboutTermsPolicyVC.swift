//
//  AboutTermsPolicyVC.swift
//  Luna
//
//  Created by Admin on 30/06/21.
//

import UIKit
import WebKit
class AboutTermsPolicyVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Variables
    //===========================
    var titleString: String = "Privacy"
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backView.round()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension AboutTermsPolicyVC {
    
    private func initialSetup() {
        self.titleLbl.text = self.titleString
        self.load("https://www.apple.com")
    }
    
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
