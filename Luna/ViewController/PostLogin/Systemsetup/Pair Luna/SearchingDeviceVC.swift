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
    @IBOutlet weak var animatedView: UIImageView!
    @IBOutlet weak var IntroLbl: UILabel!
    @IBOutlet weak var outerView: UIView!
    
    let pulsator = Pulsator()
    var deviceConnectedNavigation: ((UIButton)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pulsator.radius = 100.0
        pulsator.numPulse = 4
        pulsator.backgroundColor =  UIColor.colorRGB(r: 61, g: 201, b: 147, alpha: 1.0).cgColor
        animatedView.layer.superlayer?.insertSublayer(pulsator, below: animatedView.layer)
        pulsator.start()
        IntroLbl.textColor =  AppColors.fontPrimaryColor
        outerView.layer.cornerRadius = 10
        outerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = animatedView.layer.position
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
//        self.dismiss(animated: true) {
//            if let handle = self.deviceConnectedNavigation{
//                handle(sender)
//            }
//        }
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
        if let handle = self.deviceConnectedNavigation{
            handle(sender)
        }
    }
    
    @IBAction func dissmissBtnTapped(_ sender: UIButton) {
//        self.dismiss(animated: false, completion: nil)
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }

}
