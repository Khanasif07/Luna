//
//  SessionDescriptionVC.swift
//  Luna
//
//  Created by Admin on 08/07/21.
//

import UIKit

class SessionDescriptionVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var topNavView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var graphTitleLbl: UILabel!
    
    // MARK: - Variables
    //==========================
    let bottomSheetVC = SessionDescBottomVC()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.pop()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self.view)
        if self.bottomSheetVC.view.frame.contains(touchLocation) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            bottomSheetVC.closePullUp()
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            self.addBottomSheetView()
        }
    
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
        bottomSheetVC.view.dropShadow(color: UIColor.black16, opacity: 0.16, offSet: CGSize(width: 0, height: -3), radius: 10, scale: true)
                self.view.layoutIfNeeded()
        }
    
    
    func addBottomSheetView() {
        guard !self.children.contains(bottomSheetVC) else {
            return
        }
        self.addChild(bottomSheetVC)
        self.view.insertSubview(bottomSheetVC.view, belowSubview: self.topNavView)
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        if UIScreen.main.bounds.size.height <= 812 {
            bottomSheetVC.bottomLayoutConstraint.constant = self.view.safeAreaInsets.bottom + (self.tabBarController?.tabBar.height ?? 0)
        }
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: self.tabBarController?.tabBar.frame.height ?? 30, right: 0)
        bottomSheetVC.mainTableView.contentInset = adjustForTabbarInsets
        bottomSheetVC.mainTableView.scrollIndicatorInsets = adjustForTabbarInsets
        let globalPoint = graphTitleLbl.superview?.convert(graphTitleLbl.frame.origin, to: nil)
        bottomSheetVC.textContainerHeight = (globalPoint?.y ?? 0.0)
        self.view.layoutIfNeeded()
    }

}
