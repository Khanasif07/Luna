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
        pulsator.radius = 150.0
        pulsator.backgroundColor = UIColor.red.cgColor
        animatedView.layer.superlayer?.insertSublayer(pulsator, above: animatedView.layer)
//        view.layer.addSublayer(pulsator)
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
        self.dismiss(animated: true) {
            if let handle = self.deviceConnectedNavigation{
                handle(sender)
            }
        }
    }
    
    @IBAction func dissmissBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }

}
