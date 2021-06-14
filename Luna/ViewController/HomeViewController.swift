//
//  HomeViewController.swift
//  Luna
//
//  Created by Admin on 04/06/21.
//

import UIKit
import GoogleSignIn
import CoreBluetooth
import CryptoKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import LocalAuthentication
import AuthenticationServices

class HomeViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding {
   
   
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var appleView: UIButton!
    @IBOutlet weak var googleSignInBtn: GIDSignInButton!
    @IBOutlet weak var passTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    
    var currentNonce : String?
    // Firebase services
    var database: Database!
    var storage: Storage!
    private let biometricIDAuth = BiometricIDAuth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Database.database()
        storage = Storage.storage()
        self.reloadUser { (reloadMsg) in
            print(reloadMsg?.localizedDescription ?? "")
        }
        
        // Google SIGN In
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            print(GIDSignIn.sharedInstance()?.currentUser.profile.email ?? "")
        } else{
            GIDSignIn.sharedInstance()?.presentingViewController = self
        }
       
    }
    
    @IBAction func uploadIngToFurebase(_ sender: UIButton) {
//        FirestoreController.uploadMedia(croppedImage: self.profileImgView.image!, progressEsc: { (progress) in
//            print(progress)
//        }) { (successMsg) in
//            print(successMsg?.localized ?? "")
//        }
       downloadingStorage()
    }
    
    @IBAction func logoutBtnAction(_ sender: UIButton) {
        FirestoreController.logOut { (successMsg) in
            print(successMsg)
        }
    }
    
    @IBAction func appleBtnAction(_ sender: UIButton) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        // Generate nonce for validation after authentication successful
        self.currentNonce = randomNonceString()
        // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
        request.nonce = sha256(currentNonce!)
        
        // Present Apple authorization form
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction func signUpBtnAction(_ sender: UIButton) {
        if (Auth.auth().currentUser?.uid == nil) {
            FirestoreController.createUserNode(userId: "", email: self.emailTxtField.text!, password: self.passTxtField.text!, name: "Asif Khan", imageURL: "", phoneNo: "8896880327", countryCode: "+91", status: "Active", completion: {
                print("Success")
            }) { (error) -> (Void)  in
                print( error.localizedDescription)
            }
        }else{
            showAlert(msg: "User is already login.")
        }
    }
    
    @IBAction func forgetPasswordBtnAction(_ sender: Any) {
        if (Auth.auth().currentUser?.uid != nil) {
            FirestoreController.forgetPassword(email:  self.emailTxtField.text!, completion: {
                print("SENT=================")
            }) { (error) -> (Void) in
                print(error.localizedDescription)
            }
        }else{
            showAlert(msg: "Please sign up First.")
        }
    }
    
    @IBAction func signInBtnAction(_ sender: UIButton) {
        if   (Auth.auth().currentUser?.isEmailVerified ?? false)  ||  (Auth.auth().currentUser?.uid == nil) {
            FirestoreController.login(userId: "123456@654321", withEmail: self.emailTxtField.text!, with: self.passTxtField.text!, success: {
                FirestoreController.setFirebaseData(userId: "123456@654321", email: self.emailTxtField.text!, password: self.passTxtField.text!, name:"Mohd Asif Khan", imageURL: "", phoneNo: "8896880327", countryCode: "+91", status: "", completion: {
                    print("Success")
                }) { (error) -> (Void) in
                    AppUserDefaults.removeValue(forKey: .accesstoken)
                    print(error.localizedDescription)
                }
            }) { (message, code) in
                if code == 17011 {
                    FirestoreController.createUserNode(userId: "", email: self.emailTxtField.text!, password: self.passTxtField.text!, name: "Asif Khan", imageURL: "", phoneNo: "8896880327", countryCode: "+91", status: "Active", completion: {
                        print("Success")
                    })  { (error) -> (Void)  in
                        print( error.localizedDescription)
                    }
                }
            }
        } else {
            FirestoreController.sendEmailVerification { (errors) -> (Void) in
                print(errors.localizedDescription)
                print("sendEmailVerificationfailed=================")
            }
        }
    }
    @IBAction func biometricBtnAction(_ sender: UIButton) {
        self.bioMetricSignin()
    }
    
    @IBAction func userImageAction(_ sender: UIButton) {
        self.captureImage(delegate: self,removedImagePicture: true )
    }
    
    
    private func bioMetricSignin() {
        var error: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            biometricIDAuth.canEvaluate { (canEvaluate, _, canEvaluateError) in
                guard canEvaluate else {
                    // Face ID/Touch ID may not be available or configured
                    return
                }
                biometricIDAuth.evaluate { [weak self] (success, error) in
                    guard let `self` = self else { return }
                    guard success else {
                        // Face ID/Touch ID may not be configured
                        print("=============You are successfully verified=============")
                        return
                    }
                    print("=============You are successfully verified=============")
                }
            }
        }else {
            guard let error = error else { return }
            showAlert(title: LocalizedString.biometricAuthNotAvailable.localized, msg: error.localizedDescription)
        }
    }
    
    func downloadingStorage(){
        let storageReference = storage.reference().child("images")
        storageReference.listAll { (result, error) in
            if let error = error {
                 print("image  downloading failed\(error)")
            }
            for prefix in result.prefixes {
                 print("image  downloading\(prefix)")
                // The prefixes under storageReference.
                // You may call listAll(completion:) recursively on them.
            }
            for item in result.items {
                 print("image  downloaded \(result.items)")
            }
        }
    }
    
    func reloadUser(_ callback: ((Error?) -> ())? = nil){
        Auth.auth().currentUser?.reload(completion: { (error) in
            callback?(error)
        })
    }
    
   // Add user to Firestore
    private func addUser(user: String, message: String) {
        FirestoreController.login(userId: "", withEmail: self.emailTxtField.text!, with: self.passTxtField.text!, success: {
            FirestoreController.setFirebaseData(userId: "123456@654321", email: "asif@yopmail.com", password: "Asif@123", name:"Mohd Asif Khan", imageURL: "", phoneNo: "8896880327", countryCode: "+91", status: "", completion: {
                print("Success")
            }) { (error) -> (Void) in
                AppUserDefaults.removeValue(forKey: .accesstoken)
                print(error.localizedDescription)
            }
        }) { (message, code) in
            if code == 17011 {
                FirestoreController.createUserNode(userId: "", email: self.emailTxtField.text!, password: self.passTxtField.text!, name: "Asif Khan", imageURL: "", phoneNo: "8896880327", countryCode: "+91", status: "Active", completion: {
                    print("Success")
                }) { (error) -> (Void) in
                    print( error.localizedDescription)
                }
            }
        }
    }
    
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
    
}


extension HomeViewController: ASAuthorizationControllerDelegate{
    
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


// MARK: - UIImagePickerControllerDelegate
//===========================
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate , RemovePictureDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as? UIImage
        profileImgView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func removepicture() {
        profileImgView.image = #imageLiteral(resourceName: "Car")
    }
    
}

// MARK: - GIDSignInDelegate
//===========================
extension HomeViewController: GIDSignInDelegate {
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
            FirestoreController.setFirebaseData(userId: user.userID, email: user.profile.email, password: "Asif@123", name: user.profile.name, imageURL: "", phoneNo: "", countryCode: "+91", status: "", completion: {
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
}
