//
//  CGMSelectorVC.swift
//  Luna
//
//  Created by Admin on 06/07/21.
//

import UIKit
import SwiftUI
import Combine

class CGMSelectorVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var introTitleLbl: UILabel!
    @IBOutlet weak var introLbl: UILabel!
    @IBOutlet weak var cgmTypesTV: UITableView!
    @IBOutlet weak var proceedBtn: AppButton!
    
    // MARK: - Variables
    //===========================
    var CGMTypeArray = [
        LocalizedString.dexcomG6.localized,
        LocalizedString.dexcomG7.localized,
        LocalizedString.freestyle_Libre2.localized,
        LocalizedString.freestyle_Libre3.localized,
        LocalizedString.lunaSimulator.localized,
    ]

    var selectedPath = IndexPath(indexes: [0,0])
    var userRepository: UserRepository!
    var cgmRepository: CgmRepository!
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        
        initialSetup()
        
        let appState = AppDelegate.shared.appState
        userRepository = appState.userRepository
        cgmRepository = appState.cgmRepository
        
        Task {
            await viewDidLoadAsync()
        }
    }
    
    @MainActor
    private func viewDidLoadAsync() async {
        do {
            if let connection = try await self.cgmRepository.getCgmConnection() {
                switch(connection) {
                case .dexcomG6(_):
                    if(isDexcomShareCredentialsValid) {
                        setupDexcomG6View()
                    } else {
                        setupCgmSelectionView()
                    }
                case .dexcomG7:
                    setupCgmSelectionView()
                case .freestyleLibre2:
                    setupCgmSelectionView()
                case .freestyleLibre3:
                    setupCgmSelectionView()
                case .lunaSimulator(let deviceId, let deviceName):
                    setupLunaCgmSimulatorView(deviceId: deviceId, deviceName: deviceName)
                }
            } else {
                print("Connection is not available")
                setupCgmSelectionView()
            }
        } catch {
            print("An error occurred")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // As part of visiting UIHostingController screen, the navigation bar is made visible.
        // Whenever this view is about to appear, set the navigation bar hidden again.
        navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        let selectedCgm = CGMTypeArray[selectedPath.row]
        if(selectedCgm == LocalizedString.lunaSimulator.localized) {
            let router = AppDelegate.shared.appState.pairCgmRouter()
            let viewController = BridgeUIHostingController(
                router: router,
                rootView: BridgeView {
                    PairCgmRouterView(router: router)
                }
            )
            
            viewController.overrideUserInterfaceStyle = .light
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            proceedButtonActionForDexcomG6()
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.pop()
    }
    
    private func proceedButtonActionForDexcomG6() {
        if  UserDefaultsRepository.shareUserName.value.isEmpty || UserDefaultsRepository.sharePassword.value.isEmpty{
            SystemInfoModel.shared.cgmType =  CGMTypeArray.first ?? ""
            let vc = CGMLoginVC.instantiate(fromAppStoryboard: .CGPStoryboard)
            navigationController?.pushViewController(vc, animated: true)
        }else {
            showAlertWithAction(title: LocalizedString.logout_From_Dexcom.localized, msg: LocalizedString.are_you_sure_want_to_logout_from_dexcom.localized, cancelTitle: LocalizedString.no.localized, actionTitle: LocalizedString.yes.localized) {
                CommonFunctions.showActivityLoader()
                FirestoreController.updateDexcomCreds(shareUserName: "", sharePassword: "") {
                    NotificationCenter.default.post(name: Notification.Name.cgmRemovedSuccessfully, object: nil)
                    CommonFunctions.hideActivityLoader()
                    self.pop()
                } failure: { (err) -> (Void) in
                    CommonFunctions.hideActivityLoader()
                    CommonFunctions.showToastWithMessage(err.localizedDescription)
                }
            } cancelcompletion: {
                //MARK:- Handle Failure condition
            }
        }
    }

}


// MARK: - Extension For Functions
//===========================
extension CGMSelectorVC {
    
    private func initialSetup() {
        self.proceedBtn.isEnabled = true
        self.proceedBtn.round(radius: 10.0)
        self.proceedBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        self.introLbl.textColor = AppColors.fontPrimaryColor
        cgmTypesTV.registerCell(with: CGMTypeTableViewCell.self)
        cgmTypesTV.delegate = self
        cgmTypesTV.dataSource = self
        cgmTypesTV.reloadData()
    }
    
    private var isDexcomShareCredentialsValid : Bool {
        UserDefaultsRepository.shareUserName.value.isEmpty || UserDefaultsRepository.sharePassword.value.isEmpty
    }
    
    private func setupCgmSelectionView() {
        self.introTitleLbl.text = LocalizedString.connect_cgm.localized
        self.proceedBtn.setTitle(LocalizedString.next.localized, for: .normal)
    }
    
    private func setupDexcomG6View() {
        CGMTypeArray.removeAll()
        self.introTitleLbl.text = LocalizedString.cgm_connected.localized
        self.introLbl.text = ""
        self.proceedBtn.setTitle(LocalizedString.logout_From_Dexcom.localized, for: .normal)
    }
    
    private func setupLunaCgmSimulatorView(deviceId: UUID, deviceName: String?) {
        let router = AppDelegate.shared.appState.pairCgmRouter()
        let viewController = BridgeUIHostingController(
            router: router,
            rootView: BridgeView {
                PairCgmRouterView(router: router)
            }
        )

        viewController.overrideUserInterfaceStyle = .light
        navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - Extension For TableView
//===========================
extension CGMSelectorVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CGMTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: CGMTypeTableViewCell.self)
        cell.subTitlelbl.text = CGMTypeArray[indexPath.row]
        if indexPath == selectedPath {
            cell.selected()
        }
        else {
            cell.unselected()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let previousCell = tableView.cellForRow(at: selectedPath) as? CGMTypeTableViewCell {
            previousCell.unselected()
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? CGMTypeTableViewCell {
            cell.selected()
        }
        
        selectedPath = indexPath
    }
}
