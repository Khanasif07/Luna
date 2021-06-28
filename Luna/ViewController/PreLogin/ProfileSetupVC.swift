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
    @IBOutlet weak var sendBtn: AppButton!
    @IBOutlet weak var msgTxtField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var bottomContainerBtmConst: NSLayoutConstraint!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    // MARK: - Variables
    //===========================
    public var messageListing = [Message]()
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
    
    @IBAction func sendBtnTapped(_ sender: AppButton) {
        self.view.endEditing(true)
        sendBtn.isEnabledWithoutBackground = false
        guard let txt = msgTxtField.text,!txt.isEmpty else { return }
        self.msgTxtField.text = ""
        switch self.messageListing.endIndex {
        case 3:
            senderName = txt
            let senderMessage = Message(txt, "Sender")
            self.messageListing.append(senderMessage)
            self.messageTableView.reloadData()
            let receiverMessage = Message("Hi \(senderName), what is your last name ?", "Receiver")
            self.messageListing.append(receiverMessage)
            CommonFunctions.delay(delay: 0.25) {
                self.messageTableView.reloadData()
                self.scrollMsgToBottom()
            }
        case 5:
            msgTxtField.keyboardType = .numberPad
            msgTxtField.placeholder = "01/01/2000"
            self.senderLastName = txt
            let senderMessage = Message(txt, "Sender")
            self.messageListing.append(senderMessage)
            self.messageTableView.reloadData()
            let receiverMessage = Message("What’s your date of birth, \(senderName) ?", "Receiver")
            self.messageListing.append(receiverMessage)
            CommonFunctions.delay(delay: 0.25) {
                self.messageTableView.reloadData()
                self.scrollMsgToBottom()
            }
        case 7:
            msgTxtField.keyboardType = .default
            msgTxtField.placeholder = ""
            self.senderDob = txt
            self.bottomContainerBtmConst.constant = (-68.0 - bottomSafeArea)
            let senderMessage = Message(txt, "Sender")
            self.messageListing.append(senderMessage)
            self.messageTableView.reloadData()
            let receiverMessage = Message("Last question : \nWhat type of diabetes do you have ?", "Receiver")
            let typeMessage = Message("", "Sender","Type")
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
        self.bottomContainerBtmConst.constant = 0.0
        sendBtn.isEnabledWithoutBackground = false
        msgTxtField.delegate = self
        containerScrollView.delegate = self
        setupTableView()
        registerNotification()
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
        self.messageListing = [Message("Hello and welcome to Luna !", "Receiver"),Message("Please provide your details to set up your profile", "Receiver"),Message("What is your first name ?", "Receiver")]
        self.messageTableView.reloadWithAnimation()
       }
    
    private func registerNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        containerScrollView.isScrollEnabled = true
        guard let info = sender.userInfo, let _ = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height, let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        CommonFunctions.delay(delay: 0.25) {
            self.scrollMsgToBottom()
        }
        UIView.animate(withDuration: duration) { self.view.layoutIfNeeded() }
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        guard let info = sender.userInfo, let duration: TimeInterval = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        CommonFunctions.delay(delay: 0.25) {
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
}


// MARK: - Extension For TableView
//===========================
extension ProfileSetupVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageListing.endIndex
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.messageListing[indexPath.row].senderType {
        case "Receiver":
            switch self.messageListing[indexPath.row].cellType {
            case "Decision":
                let receiverDecisionCell = tableView.dequeueCell(with: DecisionCell.self)
                return receiverDecisionCell
            case "Type":
                let typeCell = tableView.dequeueCell(with: TypeTableCell.self)
                return typeCell
            default:
                let receiverCell = tableView.dequeueCell(with: MessageReceiverCell.self)
                receiverCell.msgLabel.text = self.messageListing[indexPath.row].messageText
                return receiverCell
            }
        default:
            switch self.messageListing[indexPath.row].cellType {
            case "Decision":
                let senderDecisionCell = tableView.dequeueCell(with: DecisionCell.self)
                senderDecisionCell.yesBtn.setImage(#imageLiteral(resourceName: "thumbsUpNotSelected"), for: .normal)
                senderDecisionCell.yesBtn.setImage(#imageLiteral(resourceName: "thumbsupSelected"), for: .selected)
                senderDecisionCell.yesBtnTapped  = {[weak self] in
                    guard let self = `self` else { return }
                    if  self.messageListing.endIndex == 3 {
                    self.bottomContainerBtmConst.constant = 0.0
                    senderDecisionCell.yesBtn.isSelected = true
                    let message = Message("What is your first name?", "Receiver")
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
            case "Type":
                let typeCell = tableView.dequeueCell(with: TypeTableCell.self)
                typeCell.configureCell()
                if self.messageListing.endIndex - 1 == indexPath.row &&  self.messageListing.endIndex == 12  {
                    typeCell.type1Btn.isHidden = true
                    typeCell.type2Btn.setTitle("Yes", for: .normal)
                }
                typeCell.type1BtnTapped = {[weak self] in
                    guard let self = `self` else { return }
                    if  self.messageListing.endIndex == 10 {
                        self.bottomContainerBtmConst.constant = (-68.0 - self.bottomSafeArea)
                        typeCell.type1Btn.isSelected = true
                        self.diabetesType = typeCell.type1Btn.titleLabel?.text ?? ""
                        let message = Message("Thank you \(self.senderName) for providing this information, now let us get the rest of the Luna system setup. Are you ready?", "Receiver")
                    let lastMessage = Message("Yes", "Sender","Type")
                    self.messageListing.append(message)
                    self.messageListing.append(lastMessage)
                    self.messageTableView.reloadData()
                    self.scrollMsgToBottom()
                    }
                }
                typeCell.type2BtnTapped = {[weak self] in
                    guard let self = `self` else { return }
                    if  self.messageListing.endIndex - 1 == indexPath.row && self.messageListing.endIndex == 12 {
                        AppUserDefaults.save(value: true, forKey: .isProfileStepCompleted)
                        UserModel.main.firstName = self.senderName
                        UserModel.main.lastName = self.senderLastName
                        UserModel.main.dob = self.senderDob
                        UserModel.main.diabetesType = self.diabetesType
                        AppRouter.gotoHomeVC()
                    }
                    if  self.messageListing.endIndex == 10 {
                        self.bottomContainerBtmConst.constant = (-68.0 - self.bottomSafeArea)
                        typeCell.type2Btn.isSelected = true
                        self.diabetesType = typeCell.type2Btn.titleLabel?.text ?? ""
                    let message = Message("Thank you \(self.senderName) for providing this information, now let us get the rest of the Luna system setup. Are you ready?", "Receiver")
                    let lastMessage = Message("Yes", "Sender","Type")
                    self.messageListing.append(message)
                    self.messageListing.append(lastMessage)
                    self.messageTableView.reloadData()
                    self.scrollMsgToBottom()
                    }
                }
                return typeCell
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
            sendBtn.isEnabledWithoutBackground = !(txt.count != 10)
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
            switch txt.count {
            case 2,5:
                if newString.length < currentString.length {msgTxtField.text = txt } else {
                    msgTxtField.text = txt + "/" }
            default:
                msgTxtField.text = txt
            }
            sendBtn.isEnabledWithoutBackground = !(newString.length != 10)
            return (string.checkIfValidCharaters(.name) || string.isEmpty) && newString.length <= 10
        default:
            sendBtn.isEnabledWithoutBackground = !(txt.count == 0)
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 25
        }
    }
}
