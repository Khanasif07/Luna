//
//  AboutTermsPolicyVC.swift
//  Luna
//
//  Created by Admin on 30/06/21.
//

import UIKit
import WebKit

class AboutTermsPolicyVC: UIViewController {
    
    enum StringType {
        case tnc
        case privacyPolicy
    }
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var textScrollView: UIScrollView!
    
    // MARK: - Variables
    //===========================
    var titleString: String = LocalizedString.privacy.localized
    var stringType: StringType = .tnc
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            if userInterfaceStyle == .dark{
                return .darkContent
            }else{
                return .darkContent
            }
        } else {
            return .lightContent
        }
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
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.descLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x16)
        self.manageWkWebView()
    }
    
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    private func manageWkWebView(){
        switch self.titleString {
        case LocalizedString.app_Version.localized:
            self.titleLbl.text = self.titleString
            self.descLbl.isHidden = false
            self.textLbl.isHidden = true
            self.descLbl.text = "Luna App Version " + UIApplication.version
        default:
            self.descLbl.isHidden = true
            self.textLbl.isHidden = false
            self.titleLbl.text = self.titleString
        }
        webView.isHidden = true
        switch stringType {
        case .tnc:
            textLbl.text = LocalizedString.TnC.localized
        case .privacyPolicy:
            textLbl.text = LocalizedString.privacyPolicyString.localized
        }
        textLbl.textAlignment = .justified
    }
}
