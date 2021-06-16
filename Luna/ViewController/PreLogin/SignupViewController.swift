//
//  SignupViewController.swift
//  Luna
//
//  Created by Admin on 15/06/21.
//

import UIKit
import GoogleSignIn
import GoogleUtilities
import CoreBluetooth
import CryptoKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import LocalAuthentication
import AuthenticationServices

class SignupViewController: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var signupTableView: UITableView!
    
    
    // MARK: - Variables
    //===========================
    var emailTxt = ""
    var passTxt = ""
    var currentNonce : String?
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .lightContent
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension SignupViewController {
    
    private func initialSetup() {
        self.tableViewSetUp()
    }
    
    private func googleSetUp(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func tableViewSetUp(){
        self.signupTableView.delegate = self
        self.signupTableView.dataSource = self
        self.signupTableView.tableHeaderView = headerView
        self.signupTableView.tableHeaderView?.height = 200.0
        self.signupTableView.registerCell(with: LoginSocialTableCell.self)
        self.signupTableView.registerCell(with: SignUpTopTableCell.self)
    }
    
    private func signUpBtnStatus()-> Bool{
        return !self.emailTxt.isEmpty && !self.passTxt.isEmpty
    }
    
    private func gotoLoginVC(){
        let loginVC = LoginViewController.instantiate(fromAppStoryboard: .PreLogin)
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
}

// MARK: - Extension For TableView
//===========================

extension SignupViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueCell(with: SignUpTopTableCell.self, indexPath: indexPath)
            cell.titleLbl.text = LocalizedString.signup.localized
            cell.subTitleLbl.text = LocalizedString.please_create_account_to_get_good_sleep.localized
            cell.signUpBtn.setTitle(LocalizedString.signup.localized, for: .normal)
            [cell.emailIdTxtField,cell.passTxtField].forEach({$0?.delegate = self})
            cell.signUpBtnTapped = { [weak self]  (sender) in
                guard let `self` = self else { return }
                CommonFunctions.showActivityLoader()
                if (Auth.auth().currentUser?.uid == nil) {
                    FirestoreController.createUserNode(userId: "", email: self.emailTxt, password: self.passTxt, name: "", imageURL: "", phoneNo: "", countryCode: "", status: "", completion: {
                        print("Success")
                        CommonFunctions.hideActivityLoader()
                    }) { (error) -> (Void)  in
                        print( error.localizedDescription)
                    }
                }else{
                    CommonFunctions.hideActivityLoader()
                    self.showAlert(msg: "User is already login.")
                }
            }
            return cell
        default:
            let cell = tableView.dequeueCell(with: LoginSocialTableCell.self, indexPath: indexPath)
            cell.signupLoginDescText = LocalizedString.alreadyHaveAnAccount.localized
            cell.signupLoginText = LocalizedString.login.localized
            cell.googleBtnTapped = {[weak self] in
                guard let self = `self` else { return }
                self.googleSetUp()
            }
            cell.appleBtnTapped = { [weak self] in
                guard let self = `self` else { return }
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                
                // Generate nonce for validation after authentication successful
                self.currentNonce = self.randomNonceString()
                // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
                request.nonce = self.sha256(self.currentNonce!)
                
                // Present Apple authorization form
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            }
            cell.loginBtnTapped = { [weak self] in
                guard let self = `self` else { return }
                self.gotoLoginVC()
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



// MARK: - Extension For TextField Delegate
//====================================
extension SignupViewController : UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        let txt = textField.text?.byRemovingLeadingTrailingWhiteSpaces ?? ""
        let cell = signupTableView.cell(forItem: textField) as? SignUpTopTableCell
        switch textField {
        case cell?.emailIdTxtField:
            self.emailTxt = txt
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        case cell?.passTxtField:
            self.passTxt = txt
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        default:
            cell?.signUpBtn.isEnabled = signUpBtnStatus()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let cell = signupTableView.cell(forItem: textField) as? SignUpTopTableCell
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        switch textField {
        case cell?.emailIdTxtField:
            return (string.checkIfValidCharaters(.email) || string.isEmpty) && newString.length <= 50
        case cell?.passTxtField:
            return (string.checkIfValidCharaters(.password) || string.isEmpty) && newString.length <= 25
        default:
            return false
        }
    }
}

// MARK: - Extension For ASAuthorizationControllerDelegate
//====================================
extension SignupViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding{
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Save authorised user ID for future reference
            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = self.currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }
            
            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }
            
            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            
            // Sign in with Firebase
            Auth.auth().signIn(with: firebaseCredential) { (authResult, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                // Mak a request to set user's display name on Firebase
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = appleIDCredential.fullName?.givenName
                changeRequest?.commitChanges(completion: { (error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Updated display name: \(Auth.auth().currentUser!.displayName!)")
                    }
                })
            }
            
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    
}

// MARK: - GIDSignInDelegate
//===========================
extension SignupViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        print("User Email: \(user.profile.email ?? "No EMail")")
        print("User Name: \(user.profile.name ?? "No Name")")
        print("User FaMILYNAME: \(user.profile.familyName ?? "No Name")")
        print("User USERID: \(user.userID ?? "No Name")")
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // Authenticate with Firebase using the credential object
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("Error occurs when authenticate with Firebase: \(error.localizedDescription)")
            }
            print("post notification after user successfully sign in")
            FirestoreController.setFirebaseData(userId: user.userID, email: user.profile.email, password: "", name: user.profile.name, imageURL: "", phoneNo: "", countryCode: "", status: "", completion: {
                print("Success")
            }) { (error) -> (Void) in
                AppUserDefaults.removeValue(forKey: .accesstoken)
                print(error.localizedDescription)
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        print("User has disconnected")
    }
    
    func signIn(_ signIn: GIDSignIn!,
        presentViewController viewController: UIViewController!) {
      self.present(viewController, animated: true, completion: nil)
    }
    
    func signIn(_ signIn: GIDSignIn!,
        dismissViewController viewController: UIViewController!) {
      self.dismiss(animated: true, completion: nil)
    }
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        // myActivityIndicator.stopAnimating()
    }

}
