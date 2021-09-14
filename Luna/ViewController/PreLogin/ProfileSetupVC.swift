//
//  ProfileSetupVC.swift
//  Luna
//
//  Created by Admin on 19/06/21.
//

import UIKit
import SwiftKeychainWrapper
import FirebaseAuth
import Firebase

//MARK : - Message
//================
struct Message{
    //MARK:- Properties
    //===================
    public var messageText : String = ""
    public var senderType : String = ""
    public var cellType : String = ""
    
    //MARK:- Inits
    //=============
    init(_ messageText: String,_ senderType:String,_ cellType: String = "Message") {
        self.messageText = messageText
        self.senderType = senderType
        self.cellType = cellType
    }
}

class ProfileSetupVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var tableViewTopConst: NSLayoutConstraint!
    @IBOutlet weak var sendBtn: AppButton!
    @IBOutlet weak var msgTxtField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var bottomContainerBtmConst: NSLayoutConstraint!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    // MARK: - Variables
    //===========================
    public var messageListing = [Message]()
    public var datePicker = CustomDatePicker()
    var senderName: String = ""
    var senderDob : String = ""
    var senderLastName : String = ""
    var diabetesType  : String = ""
    var topSafeArea: CGFloat = 0.0
    var bottomSafeArea: CGFloat = 0.0

    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTData()
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
        bottomContainerView.addShadowToTopOrBottom(location: .top,color: UIColor.black16)
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        } else {
            topSafeArea = topLayoutGuide.length
            bottomSafeArea = bottomLayoutGuide.length
        }
    }
    
    //MARK: ACTIONS
    //=============
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        _ = touch.location(in: self.view)
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func logoutBtnTapped(_ sender: UIButton) {
        showAlertWithAction(title: LocalizedString.logout.localized, msg: LocalizedString.are_you_sure_want_to_logout.localized, cancelTitle: LocalizedString.no.localized, actionTitle: LocalizedString.yes.localized) {
            FirestoreController.logOut { (isLogout) in
                if !isLogout {
                    self.performCleanUp()
                    DispatchQueue.main.async {
                        AppRouter.goToLoginVC()
                    }
                }
            }
        } cancelcompletion: {}
    }
    
    @IBAction func sendBtnTapped(_ sender: AppButton) {
        sendBtn.isEnabledWithoutBackground = false
        guard let txt = msgTxtField.text,!txt.isEmpty else { return }
        self.msgTxtField.text = ""
        switch self.messageListing.endIndex {
        case 3:
            senderName = txt
            let senderMessage = Message(txt, LocalizedString.sender.localized)
            self.messageListing.append(senderMessage)
            self.messageTableView.reloadData()
            let receiverMessage = Message("Hi \(senderName), what is your last name?", LocalizedString.receiver.localized)
            self.messageListing.append(receiverMessage)
            CommonFunctions.delay(delay: 0.25) {
                self.messageTableView.reloadData()
                self.scrollMsgToBottom()
            }
        case 5:
            self.msgTxtField.inputView = self.datePicker
            self.msgTxtField.placeholder = "mm/dd/yyyy"
            self.msgTxtField.reloadInputViews()
            self.msgTxtField.text = datePicker.selectedDate()?.convertToDefaultString()
            self.sendBtn.isEnabledWithoutBackground = !(msgTxtField.text?.count == 0)
            self.senderLastName = txt
            let senderMessage = Message(txt, LocalizedString.sender.localized)
            self.messageListing.append(senderMessage)
            self.messageTableView.reloadData()
            let receiverMessage = Message(LocalizedString.what_your_date_of_birth.localized + ", \(senderName)?", LocalizedString.receiver.localized)
            self.messageListing.append(receiverMessage)
            CommonFunctions.delay(delay: 0.25) {
                self.messageTableView.reloadData()
                self.scrollMsgToBottom()
            }
        case 7:
            self.view.endEditing(true)
            msgTxtField.inputView = nil
            msgTxtField.placeholder = ""
            self.senderDob = txt
            bottomContainerView.isHidden = true
            self.bottomContainerBtmConst.constant = (-68.0 - bottomSafeArea)
            let senderMessage = Message(txt, LocalizedString.sender.localized)
            self.messageListing.append(senderMessage)
            self.messageTableView.reloadData()
            let receiverMessage = Message("Last question: \nWhat type of diabetes do you have?", LocalizedString.receiver.localized)
            let typeMessage = Message("", LocalizedString.sender.localized,LocalizedString.type.localized)
            self.messageListing.append(receiverMessage)
            self.messageListing.append(typeMessage)
            CommonFunctions.delay(delay: 0.25) {
                self.messageTableView.reloadData()
                self.scrollMsgToBottom()
            }
        default:
            self.messageTableView.reloadData()
        }
    }
    
    
}

// MARK: - Extension For Functions
//===========================
extension ProfileSetupVC {
    
    private func initialSetup() {
        if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = .light
        }
        setupDatePicker()
        containerScrollView.delegate = self
        setupTableView()
        registerNotification()
    }
    
    private func setupDatePicker(){
        self.datePicker.datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        self.datePicker.datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        self.datePicker.pickerMode = .date
        self.datePicker.datePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker){
        msgTxtField.text = picker.date.convertToDefaultString()
    }
    
    private func setupTableView() {
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.registerCell(with: MessageSenderCell.self)
        messageTableView.registerCell(with: MessageReceiverCell.self)
        messageTableView.registerCell(with: DecisionCell.self)
        messageTableView.registerCell(with: TypeTableCell.self)
       }
       
       private func setupTData() {
        self.bottomContainerView.isHidden = false
        self.bottomContainerBtmConst.constant = 0.0
        self.sendBtn.isEnabledWithoutBackground = false
        msgTxtField.delegate = self
        msgTxtField.autocapitalizationType = .words
        msgTxtField.becomeFirstResponder()
        self.messageListing = [Message(LocalizedString.hello_and_welcome_to_Luna.localized, LocalizedString.receiver.localized),Message(LocalizedString.please_provide_your_details_to_set_up_your_profile.localized, LocalizedString.receiver.localized),Message(LocalizedString.what_is_your_first_name.localized, LocalizedString.receiver.localized)]
        self.messageTableView.reloadWithAnimation()
       }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        containerScrollView.isScrollEnabled = true
        guard let info = sender.userInfo, let keyboardHeight = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height, let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        CommonFunctions.delay(delay: 0.2) {
            self.scrollMsgToBottom()
        }
        self.tableViewTopConst.constant = keyboardHeight
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        guard let info = sender.userInfo, let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        self.tableViewTopConst.constant = 0.0
        CommonFunctions.delay(delay: 0.2) {
            self.scrollMsgToBottom()
        }
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    private func scrollMsgToBottom(animated: Bool = true, duration: Double = 0.1) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            guard self.messageListing.endIndex > 0 else { return }
            self.messageTableView.scrollToRow(at: IndexPath(row: self.messageListing.endIndex - 1, section: 0), at: .bottom, animated: animated)
        }
    }
    
    private func gotoSettingVC(){
        let vc = SettingsVC.instantiate(fromAppStoryboard: .PostLogin)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func performCleanUp(for_logout: Bool = true) {
        let isTermsAndConditionSelected  = AppUserDefaults.value(forKey: .isTermsAndConditionSelected).boolValue
        AppUserDefaults.removeAllValues()
        UserModel.main = UserModel()
        if for_logout {
            AppUserDefaults.save(value: isTermsAndConditionSelected, forKey: .isTermsAndConditionSelected)
        }
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        DispatchQueue.main.async {
            AppRouter.goToSignUpVC()
        }
    }
}


// MARK: - Extension For TableView
//===========================
extension ProfileSetupVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageListing.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.messageListing[indexPath.row].senderType {
        case LocalizedString.receiver.localized:
            switch self.messageListing[indexPath.row].cellType {
            case LocalizedString.decision.localized:
                let receiverDecisionCell = tableView.dequeueCell(with: DecisionCell.self)
                return receiverDecisionCell
            case LocalizedString.type.localized:
                let typeCell = tableView.dequeueCell(with: TypeTableCell.self)
                return typeCell
            default:
                let receiverCell = tableView.dequeueCell(with: MessageReceiverCell.self)
                receiverCell.msgLabel.text = self.messageListing[indexPath.row].messageText
                return receiverCell
            }
        default:
            switch self.messageListing[indexPath.row].cellType {
            case LocalizedString.decision.localized:
                let senderDecisionCell = tableView.dequeueCell(with: DecisionCell.self)
                senderDecisionCell.yesBtn.setImage(#imageLiteral(resourceName: "thumbsUpNotSelected"), for: .normal)
                senderDecisionCell.yesBtn.setImage(#imageLiteral(resourceName: "thumbsupSelected"), for: .selected)
                senderDecisionCell.yesBtnTapped  = {[weak self] in
                    guard let self = `self` else { return }
                    if  self.messageListing.endIndex == 3 {
                        self.bottomContainerView.isHidden = false
                    self.bottomContainerBtmConst.constant = 0.0
                    senderDecisionCell.yesBtn.isSelected = true
                        let message = Message(LocalizedString.what_is_your_first_name.localized, LocalizedString.receiver.localized)
                    self.messageListing.append(message)
                    self.messageTableView.reloadData()
                    self.scrollMsgToBottom()
                    }
                }
                senderDecisionCell.noBtnTapped  = {[weak self] in
                    guard let self = `self` else { return }
                    print(self)
                }
                return senderDecisionCell
            case LocalizedString.type.localized:
                let typeCell = tableView.dequeueCell(with: TypeTableCell.self)
                typeCell.configureCell()
                typeCell.type1BtnTapped = {[weak self] in
                    guard let self = `self` else { return }
                    if  self.messageListing.endIndex == 10 {
                        self.bottomContainerView.isHidden = true
                        self.bottomContainerBtmConst.constant = (-68.0 - self.bottomSafeArea)
                        typeCell.type1Btn.isSelected = true
                        self.diabetesType = typeCell.type1Btn.titleLabel?.text ?? ""
                        let message = Message("Thank you \(self.senderName) for providing this information, now let us get the rest of the Luna system setup. Are you ready?", LocalizedString.receiver.localized)
                        let lastMessage = Message(LocalizedString.yes.localized, LocalizedString.sender.localized,LocalizedString.type.localized)
                    self.messageListing.append(message)
                    self.messageListing.append(lastMessage)
                    self.messageListing.append(lastMessage)
                    self.messageTableView.reloadData()
                    self.scrollMsgToBottom()
                    }
                }
                typeCell.type2BtnTapped = {[weak self] in
                    guard let self = `self` else { return }
                    if  self.messageListing.endIndex - 2 == indexPath.row && self.messageListing.endIndex == 13 {
                        typeCell.type2Btn.isSelected = true
                        self.messageTableView.reloadData()
                        UserModel.main.firstName = self.senderName
                        UserModel.main.lastName = self.senderLastName
                        UserModel.main.dob = self.senderDob
                        UserModel.main.diabetesType = self.diabetesType
                        CommonFunctions.showActivityLoader()
                        FirestoreController.updateUserNode(email: AppUserDefaults.value(forKey: .defaultEmail).stringValue, password: AppUserDefaults.value(forKey: .defaultPassword).stringValue, firstName:  self.senderName, lastName: self.senderLastName, dob: self.senderDob, diabetesType: self.diabetesType, isProfileStepCompleted: true, isSystemSetupCompleted: false,isBiometricOn: AppUserDefaults.value(forKey: .isBiometricSelected).boolValue) {
                            CommonFunctions.hideActivityLoader()
                            AppUserDefaults.save(value: true, forKey: .isProfileStepCompleted)
                            let vc = SystemSetupStep1VC.instantiate(fromAppStoryboard: .SystemSetup)
                            self.navigationController?.pushViewController(vc, animated: true)
                        } failure: { (error) -> (Void) in
                            CommonFunctions.hideActivityLoader()
                            CommonFunctions.showToastWithMessage(error.localizedDescription)
                        }
                    }
                    if  self.messageListing.endIndex == 10 {
                        self.bottomContainerView.isHidden = true
                        self.bottomContainerBtmConst.constant = (-68.0 - self.bottomSafeArea)
                        typeCell.type2Btn.isSelected = true
                        self.diabetesType = typeCell.type2Btn.titleLabel?.text ?? ""
                    let message = Message("Thank you \(self.senderName) for providing this information, now let us get the rest of the Luna system setup. Are you ready?", LocalizedString.receiver.localized)
                    let lastMessage = Message(LocalizedString.yes.localized, LocalizedString.sender.localized,LocalizedString.type.localized)
                    self.messageListing.append(message)
                    self.messageListing.append(lastMessage)
                    self.messageListing.append(lastMessage)
                    self.messageTableView.reloadData()
                    self.scrollMsgToBottom()
                    }
                }
                if self.messageListing.endIndex - 2 == indexPath.row &&  self.messageListing.endIndex == 13  {
                    typeCell.type1Btn.isHidden = true
                    typeCell.type2Btn.isHidden = false
                    typeCell.type2Btn.setTitle(LocalizedString.yes.localized, for: .normal)
                    return typeCell
                } else if self.messageListing.endIndex - 1 == indexPath.row &&  self.messageListing.endIndex == 13  {
                    typeCell.type1Btn.isHidden = true
                    typeCell.type2Btn.isHidden = true
                    return typeCell
                } else {
                    typeCell.type1Btn.isHidden = false
                    typeCell.type2Btn.isHidden = false
                    return typeCell
                }
            default:
                let senderCell = tableView.dequeueCell(with: MessageSenderCell.self)
                senderCell.senderMsgLbl.text = self.messageListing[indexPath.row].messageText
                return senderCell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - Extension For UIScrollViewDelegate
//===========================
extension ProfileSetupVC: UIGestureRecognizerDelegate, UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard scrollView === containerScrollView else { return }
        let vel = scrollView.panGestureRecognizer.velocity(in: scrollView).y
        if vel < 0 {
        } else if vel > 0 {
            scrollView.isScrollEnabled = false
        } else {
        }
    }
}

// MARK: - Extension For UITextFieldDelegate
//===========================
extension ProfileSetupVC: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        switch self.messageListing.endIndex {
        case 7:
            msgTxtField.text = datePicker.selectedDate()?.convertToDefaultString()
            sendBtn.isEnabledWithoutBackground = !(msgTxtField.text?.count == 0)
        default:
            sendBtn.isEnabledWithoutBackground = !(txt.count == 0)
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        switch self.messageListing.endIndex {
        case 7:
            msgTxtField.text = datePicker.selectedDate()?.convertToDefaultString()
            sendBtn.isEnabledWithoutBackground = !(msgTxtField.text?.count == 0)
        default:
            sendBtn.isEnabledWithoutBackground = !(txt.count == 0)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch self.messageListing.endIndex {
        case 7:
            sendBtn.isEnabledWithoutBackground = true
            return (string.checkIfValidCharaters(.name) || string.isEmpty) && newString.length <= 10
        default:
            sendBtn.isEnabledWithoutBackground = !(txt.count == 0)
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 25
        }
    }
}
