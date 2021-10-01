//
//  ContactUsVC.swift
//  Luna
//
//  Created by Admin on 01/10/21.
//

import UIKit
import Firebase

class ContactUsVC : UIViewController{
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var submitBtn: AppButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contactTableView: UITableView!
    
    // MARK: - Variables
    //===========================
    var descText: String?
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.submitBtn.round(radius: 4.0)
        self.backBtn.round()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.pop()
    }
    
    @IBAction func submitBtnAction(_ sender: Any) {
        if let message = descText {
            if message.isEmpty {
                CommonFunctions.showToastWithMessage("Please enter message here")
                return
            }
            self.postQuery(message)
        }
    }
}

// MARK: - Extension For Functions
//===========================
extension ContactUsVC {
    
    private func initialSetup() {
        self.fontSetup()
        self.contactTableView.delegate = self
        self.contactTableView.dataSource = self
        self.contactTableView.registerCell(with: ContactsUsTableCell.self)
    }
    
    private func fontSetup(){
        self.submitBtn.titleLabel?.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x16)
        self.submitBtn.isEnabled = false
    }
    
    /// Mark:- Fetching the message ID
    private func getMessageId() -> String {
        let messageId = Firestore.firestore().collection(ApiKey.messages).document(UserModel.main.id).collection(ApiKey.contactUs).document().documentID
        return messageId
    }
    
    private func postQuery(_ desc: String){
        FirestoreController.createMessageNode(messageText: desc, messageTime: FieldValue.serverTimestamp(), messageId:  getMessageId(), messageType: "Text", senderId: UserModel.main.id)
        CommonFunctions.showToastWithMessage("You query has been sent to admin successfully.")
        self.pop()
    }
}

// MARK: - Extension For TableView
//===========================
extension ContactUsVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(with: ContactsUsTableCell.self)
        cell.messageTxtView.delegate = self
        cell.nameTxtFld.text = "\(UserModel.main.firstName)" + " \(UserModel.main.lastName)"
        cell.emailTxtFld.text = UserModel.main.email
        return cell
    }
}

// MARK: - Extension For UITextViewDelegate
//===========================
extension ContactUsVC: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        self.descText = text
        self.submitBtn.isEnabled = text.count >= 2
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}
