//
//  ProfileSetupVC.swift
//  Luna
//
//  Created by Admin on 19/06/21.
//

import UIKit
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
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var msgTxtField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var bottomContainerBtmConst: NSLayoutConstraint!
    @IBOutlet weak var containerScrollView: UIScrollView!
    
    // MARK: - Variables
    //===========================
    public var messageListing = [Message]()
    var senderName: String = ""
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
    @IBAction func logoutBtnAction(_ sender: Any) {
        FirestoreController.logOut { (successMsg) in
            self.performCleanUp()
            AppRouter.goToSignUpVC()
        }
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        guard let txt = msgTxtField.text,!txt.isEmpty else { return }
        self.msgTxtField.text = ""
        switch self.messageListing.endIndex {
        case 4:
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
        case 6:
            msgTxtField.keyboardType = .numberPad
            msgTxtField.placeholder = "01/01/2000"
            let senderMessage = Message(txt, "Sender")
            self.messageListing.append(senderMessage)
            self.messageTableView.reloadData()
            let receiverMessage = Message("What’s your date of birth, \(senderName) ?", "Receiver")
            self.messageListing.append(receiverMessage)
            CommonFunctions.delay(delay: 0.25) {
                self.messageTableView.reloadData()
                self.scrollMsgToBottom()
            }
        case 8:
            msgTxtField.keyboardType = .default
            msgTxtField.placeholder = ""
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
        bottomContainerBtmConst.constant = (-68.0 - bottomSafeArea)
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
        self.messageListing = [Message("Hello and welcome to Luna !", "Receiver"),Message("Do you have 15 minutes now to set up the system ?", "Receiver"),Message("", "Sender","Decision")]
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
    
    private func performCleanUp() {
        let isTermsAndConditionSelected  = AppUserDefaults.value(forKey: .isTermsAndConditionSelected).boolValue
        let isBiometricSelected  = AppUserDefaults.value(forKey: .isBiometricSelected).boolValue
        AppUserDefaults.removeAllValues()
        AppUserDefaults.save(value: isBiometricSelected, forKey: .isBiometricSelected)
        AppUserDefaults.save(value: isTermsAndConditionSelected, forKey: .isTermsAndConditionSelected)
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
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
                if self.messageListing.endIndex - 1 == indexPath.row &&  self.messageListing.endIndex == 13  {
                    typeCell.type1Btn.isHidden = true
                    typeCell.type2Btn.setTitle("Yes", for: .normal)
                }
                typeCell.type1BtnTapped = {[weak self] in
                    guard let self = `self` else { return }
                    if  self.messageListing.endIndex == 11 {
                        self.bottomContainerBtmConst.constant = (-68.0 - self.bottomSafeArea)
                        typeCell.type1Btn.isSelected = true
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
                    if  self.messageListing.endIndex == 11 {
                        self.bottomContainerBtmConst.constant = (-68.0 - self.bottomSafeArea)
                        typeCell.type2Btn.isSelected = true
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
//        switch self.messageListing.endIndex {
//        case 8:
//            switch txt.count {
//            case 2:
//                msgTxtField.text = txt + "/"
//            case 5:
//                msgTxtField.text = txt + "/"
//            default:
//                msgTxtField.text = txt + "/"
//            }
//        default:
//            msgTxtField.text = txt
//        }
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch self.messageListing.endIndex {
        case 8:
            switch txt.count {
            case 2:
                msgTxtField.text = txt + "/"
            case 5:
                msgTxtField.text = txt + "/"
            default:
                msgTxtField.text = txt
            }
            return (string.checkIfValidCharaters(.name) || string.isEmpty) && newString.length <= 10
        default:
            return (string.checkIfValidCharaters(.name) || string.isEmpty) && newString.length <= 25
        }
    }
    
}
