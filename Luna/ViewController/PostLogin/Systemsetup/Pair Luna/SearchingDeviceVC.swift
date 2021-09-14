//
//  SearchingDeviceVC.swift
//  Luna
//
//  Created by Admin on 07/07/21.
//
import Pulsator
import UIKit

class SearchingDeviceVC: UIViewController {

    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var animatedView: UIImageView!
    @IBOutlet weak var IntroLbl: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    let pulsator = Pulsator()
    var deviceConnectedNavigation: ((UIButton)->())?
    var deviceNotConnectedNavigation: ((UIButton)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        self.bluetoothSetup()
        self.addPulsator()
        self.addBlurView()
        IntroLbl.textColor =  AppColors.fontPrimaryColor
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
        view.layer.layoutIfNeeded()
        outerView.layer.cornerRadius = 10
        outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        pulsator.position = animatedView.layer.position
    }
    
    private func bluetoothSetup(){
        BleManager.sharedInstance.delegate = self
        if BleManager.sharedInstance.myperipheral?.state == .connected {
            BleManager.sharedInstance.disConnect()
            BleManager.sharedInstance.beginScan()
        }else{
            BleManager.sharedInstance.beginScan()
        }
    }
    
    private func addPulsator(){
        pulsator.radius = 100.0
        pulsator.numPulse = 4
        pulsator.backgroundColor =  UIColor.colorRGB(r: 61, g: 201, b: 147, alpha: 1.0).cgColor
        animatedView.layer.superlayer?.insertSublayer(pulsator, below: animatedView.layer)
        pulsator.start()
    }
    
    private func addBlurView(){
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        blurredView.alpha = 0.75
        blurredView.frame = self.backgroundView.bounds
        backgroundView.addSubview(blurredView)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func dissmissBtnTapped(_ sender: UIButton) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }
}

// MARK: - BleProtocol
//===========================
extension SearchingDeviceVC: BleProtocol{
    func didConnect(name: String) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
        if let handle = self.deviceConnectedNavigation{
            handle(UIButton())
        }
    }
    
    func didDisconnect() {
        CommonFunctions.showToastWithMessage("Not Connected")
    }
    
    func didNotDiscoverPeripheral(){
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
        if let handle = self.deviceNotConnectedNavigation{
            handle(UIButton())
        }
    }
    
}
