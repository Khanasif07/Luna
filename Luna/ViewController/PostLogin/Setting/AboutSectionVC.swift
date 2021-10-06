//
//  AboutSectionVC.swift
//  Luna
//
//  Created by Admin on 24/06/21.
//

import UIKit
import MessageUI

class AboutSectionVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var aboutTableView: UITableView!
    @IBOutlet weak var backView: UIView!
    
    // MARK: - Variables
    //===========================

    var sections: [(UIImage,String)] = [(#imageLiteral(resourceName: "customerSupport"),LocalizedString.customer_Support.localized),(#imageLiteral(resourceName: "appVersion"),LocalizedString.app_Version.localized),(#imageLiteral(resourceName: "termsConditions"),LocalizedString.terms_Conditions.localized),(#imageLiteral(resourceName: "privacy"),LocalizedString.privacy.localized)]
    
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
    @IBAction func backBtnAction(_ sender: Any) {
        self.pop()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension AboutSectionVC {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.tableViewSetup()
    }
    
    private func tableViewSetup(){
        self.aboutTableView.delegate = self
        self.aboutTableView.dataSource = self
        self.aboutTableView.registerCell(with: SettingTableCell.self)
    }
}

// MARK: - Extension For TableView
//===========================
extension AboutSectionVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: SettingTableCell.self)
        cell.titleLbl.text = sections[indexPath.row].1
        cell.logoImgView.image = sections[indexPath.row].0
        cell.nextBtn.isHidden = false
        cell.switchView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch sections[indexPath.row].1 {
//        case LocalizedString.find_Answers.localized:
//            let vc = SettingManualVC.instantiate(fromAppStoryboard: .PostLogin)
//            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.customer_Support.localized:
            let vc = ContactUsVC.instantiate(fromAppStoryboard: .PostLogin)
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.privacy.localized:
            let vc = AboutTermsPolicyVC.instantiate(fromAppStoryboard: .PostLogin)
            vc.titleString =  sections[indexPath.row].1
            vc.stringType = .privacyPolicy
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.app_Version.localized:
            let vc = AboutTermsPolicyVC.instantiate(fromAppStoryboard: .PostLogin)
            vc.titleString =  sections[indexPath.row].1
            self.navigationController?.pushViewController(vc, animated: true)
        case LocalizedString.terms_Conditions.localized:
            let vc = AboutTermsPolicyVC.instantiate(fromAppStoryboard: .PostLogin)
            vc.titleString =  sections[indexPath.row].1
            vc.stringType = .tnc
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            CommonFunctions.showToastWithMessage("Under Development")
        }
    }
}

// MARK: - Extension For MFMailComposeViewControllerDelegate
//==========================================================
extension AboutSectionVC: MFMailComposeViewControllerDelegate{
    
    func openMail() {
        if MFMailComposeViewController.canSendMail() {
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            UINavigationBar.appearance().barTintColor = UIColor.white
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            composeVC.setToRecipients(["support@lunadiabetes.com"])
            composeVC.setSubject("Luna iOS App Feedback")
            composeVC.setMessageBody("""
            ------------------------------
            Device Information
            ------------------------------
            iOS Version = \(DeviceDetail.os_version)
            Luna App Version = \(appVersion ?? "1.0")
            Phone = \(DeviceDetail.device_model)
            Thank you!
            """, isHTML: false)
            self.present(composeVC, animated: true, completion: nil)
        } else{
            showAlert(msg: "Mail not configured")            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        UINavigationBar.appearance().barTintColor = UIColor.black
        controller.dismiss(animated: true)
    }
}
