//
//  InsulinStep1VC.swift
//  Luna
//
//  Created by Admin on 01/07/21.
//

import UIKit

class InsulinStep1VC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var warningImgView: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btmContainerView: UIView!
    @IBOutlet weak var proceedBtn: AppButton!
    
    @IBOutlet weak var importantBox: UIView!
    // MARK: - Variables
    //===========================
    
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
        proceedBtn.layer.cornerRadius = 8.0
        btmContainerView.layer.cornerRadius = 10.0
        importantBox.cornerRadius = 10.0
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        let vc = InsulinStep2VC.instantiate(fromAppStoryboard: .SystemSetup)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
}

// MARK: - Extension For Functions
//===========================
extension InsulinStep1VC {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        btmContainerView.setBorder(width: 1.0, color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
        importantBox.setBorder(width: 1.0, color: #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
        proceedBtn.isEnabled = true
        proceedBtn.setTitle("Next", for: .normal)
        let imageView = UIImageView(image: UIImage(named: "warning"))
        warningImgView.image = imageView.image?.maskWithColor(color: .systemRed)
    }
}
