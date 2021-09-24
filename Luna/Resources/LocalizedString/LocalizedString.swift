//
//  LocalizedString.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation

enum LocalizedString : String {
    
    // MARK:- App Title
    //===================
    case appTitle = "TARA"
    case ok = "ok"
    case dot = "\u{2022}"
    case logout
    
    //MARK:- User TabBar Values
    //=========================
    case home
    case setting
    case notification
    case profile
    case notifications
    // MARK: - Alert Values
    //==============================
    case chooseOptions = "chooseOptions"
    case chooseFromGallery = "chooseFromGallery"
    case takePhoto = "takePhoto"
    case cancel = "cancel"
    case gallery
    case camera
    case send
    case removePicture = "removePicture"
    case alert
    case settings
    case submit
    case login
    case sendOtp
    case english
    case arabic
    case continueTitle
    case mobileNo
    
    case tutorialTitle1 = "tutorialTitle1"
    case tutorialTitle2 = "tutorialTitle2"
    case tutorialTitle3 = "tutorialTitle3"
    case login_with_emailId = "login_with_emailId"
    case chooseLanguage = "chooseLanguage"
    
    // MARK: - Login VC Values
    //==============================
    case emailID = "emailId"
    case password = "password"
    case emailIdPlaceHolder = "emailIdPlaceHolder"
    case usePhoneNumber = "usePhoneNumber"
    case forgotPassword = "forgotPassword"
    case addPhoneNumber = "addPhoneNumber"
    case sign_in = "sign_in"
    case sign_in_Cap
    case signupcap = "signupcap"
    case signup = "signup"
    case Login_with_social_accounts = "Login_with_social_accounts"
    case signup_with_social_accounts = "signup_with_social_accounts"
    case sKIP_LOGIN_CONTINUE = "sKIP_LOGIN_CONTINUE"
    case skip_signup_continue = "skip_signup_continue"
    case dont_have_an_account = "dont_have_an_account"
    case alreadyHaveAnAccount = "alreadyHaveAnAccount"
    case imageUploadingFailed
    case accountNumberAreNotSame
    case minTenDigitInAccountNumber
    case enterOldPassWord
    case enterNewPassWord
    case allowFaceId
    case allowTouchId
    case faceID
    case touchID
    case email_verification
    case please_check_your_emai_A_verification_link_has_been_sent_to_your_registered_email_account
    // MARK: - Validation Messages
    //==================================
    case pleaseEnterValidEmail = "pleaseEnterValidEmail"
    case pleaseEnterValidPassword = "pleaseEnterValidPassword"
    case passwordDoesNotMatch = "passwordDoesNotMatch"
    case nameShouldBeAtleastMinCharacters = "nameShouldBeAtleastMinCharacters"
    case phoneNoShouldBeAtleastMinCharacters = "phoneNoShouldBeAtleastMinCharacters"
    case pleaseEnterName = "pleaseEntertName"
    case pleaseEnterMinTwoChar = "pleaseEnterMinTwoChar"
    case enterYourName = "enterYourName"
    case pleaseEnterNickName = "pleaseEnterNickName"
    case pleaseEnterEmail = "pleaseEnterEmail"
    case enterYourEmailId = "enterYourEmailId"
    case pleaseEnterPassword = "pleaseEnterPassword"
    case pleaseEnterValidPhoneNo = "pleaseEnterValidPhoneNo"
    case pleaseEnterPhoneNumber = "pleaseEnterPhoneNumber"
    case pleaseEnterminimumdigitsphonenumber
    case enterYourMobNumber = "enterYourMobNumber"
    case confirmPassword = "confirmPassword"
    case enterPhoneNumber = "enterPhoneNumber"
    case enterNewPassword = "enterNewPassword"
    case newPassword = "newPassword"
    case confirmNewPassword = "confirmNewPassword"
    case pleaseEnterZip = "pleaseEnterZip"
    case pleaseFillAllTheFields = "pleaseFillAllTheFields"
    case pleaseEnterNewPassword = "pleaseEnterNewPassword"
    case pleaseEnterConfirmNewPassword = "pleaseEnterConfirmNewPassword"
    case passwordsDoNotMatch = "passwordsDoNotMatch"
    case pleaseChooseCountryCode = "pleaseChooseCountryCode"
    case enterCorrectPhoneNo = "enterCorrectPhoneNo"
    case pleaseEnterEducation = "pleaseEnterEducation"
    case pleaseEnterExperience = "pleaseEnterExperience"
    case pleaseEnterDob = "pleaseEnterDob"
    case phoneNumber = "phoneNumber"
    case wait_Img_Uploa
    // MARK: - Sign Up VC Values
    //==============================
    case bySigningDec = "bySigningDec"
    case tos = "tos"
    case privacyPolicy = "privacyPolicy"
    case choosePdf

    
    //Updated Localized String
    case createNewAccount
    case pleaseSetNewPassword
    case resetPassword
    case selectCountryCode
    case oneTimePassword
    case login_with_Social_Accounts
    case log_in
    case pair_luna
    case link_cgm
    case insulin_info
    case luna_Device_Paired
    case start
    case edit
    case about_5_minutes_to_complete
    case step
    case per_day
    case change_Long_Acting_Insulin
    case change_CGM
    case change_connected_Luna_Device
    case alerts
    case explainer_what_they_do
    
    case how_to_charge_Luna
    case how_to_pair_Luna
    case how_to_fill_and_apply_your_Insulin
    case how_to_connect_your_CGM
    
    case change_Password
    case face_ID
    case apple_Health
    case luna
    case about
    case delete_Account
    case touch_ID
    case are_you_sure_want_to_delete_account
    case are_you_sure_want_to_logout
    
    case no
    case yes
    
    case first_Name
    case last_Name
    case date_Of_Birth
    case email
    case diabetes_Type
    
    case find_Answers
    case customer_Support
    case app_Version
    case terms_Conditions
    case privacy
    
    case do_not_Allow
    case allow
    case faceID_Touch_ID_may_not_be_available_or_configured
    case what_is_your_first_name
    case hello_and_welcome_to_Luna
    case please_provide_your_details_to_set_up_your_profile
    case what_your_date_of_birth
    
    case old_password_must_contain_at_least_char
    case new_password_must_contain_at_least_char
    case confirm_password_must_contain_at_least_char
    case new_and_confirm_password_doesnt_match
    case type1
    case type2
    
    case dexcomG6
    case dexcomG7
    case freestyle_Libre2
    case freestyle_Libre3
    
    case battery
    case reservoir
    case system


    
    //Updated Localized String
    case type_your_message_here
    case view_All_Offer
    case minutesAgo
    case oneMinuteAgo
    case oneHourAgo
    case hoursAgo
    case daysAgo
    case justNow
    case yesterday
    case lastWeek
    case secondsAgo
    case weeksAgo
    case lastMonth
    case monthsAgo
    case lastYear
    case rejectRequest
    case type_Your_Message_Here
    case search
    
    case old_password
    case new_password
    case confirm_password
    
    case lOGIN_TO_LUNA
    case password_Reset
    case reset_password_link_sent
    case email_Verification
    case please_check_your_email_sent
    case sender
    case receiver
    
    case decision
    case type
    
    case signInWithFaceID = "Sign In with Face ID";
    case signInWithFingerPrint = "Sign In with Fingerprint";
    case invalidBiometrics = "Invalid biometric input";
    case lockedOutBiometric = "Biometric locked out";
    case loginError = "Your biometric is not associated with any account";
    case biometricAuthNotAvailable = "Your device doesn't support biometric authentication";
    case overrideBioMetricMessage = "Your biometric is already associated with one account. Do you want to replace your biometric with this account?";
    case error = "Error!";
    case biometric = "Biometric";
    
    case TnC = """
    THESE TERMS OF SERVICE OF LUNA HEALTH, INC. ARE EFFECTIVE AS OF August 17, 2021 AND REPLACE ANY PRIOR TERMS OF SERVICE.
    PLEASE NOTE THAT SECTION 8 CONTAINS A REQUIREMENT THAT CERTAIN DISPUTES WILL BE RESOLVED EXCLUSIVELY THROUGH FINAL AND BINDING ARBITRATION AND A CLASS ACTION WAIVER.
    These Terms of Service (“Terms of Service”) are an agreement between Luna Health, Inc., a Delaware corporation (“Luna Health” or the “Company”) and each visitor to the Luna Health website located at https://www.lunadiabetes.com/ (“Website”), including any subpages or microsites of the Company which are connected to the Website, and each user of the software or mobile applications we make available for download or access at our Website, at the Apple® App Store or through any other cell phone service provider locations or other locations we indicate (“Software Apps”), or our data services available through the internet (“Data Services”) to users of our products or Software Apps, or any other product or service of the Company offered from time to time hereafter. We refer to each visitor to our Website or user of a Luna Health Product, our Data Services or Software Apps as (“you” or as a “User”). We refer to our Website and our Data Services as the (“Luna Health Services”). We refer to Luna Health products purchased from Luna Health directly or through a distributor or any other intermediary as the (“Luna Health Products”). Certain Luna Health Products require a prescription, and such Luna Health Products may only be used by the person for whom the prescription was issued (that person is referred to as the (“Prescription Device User”). These Terms of Service set forth the rights and obligations of you and Luna Health regarding your use of and access to the Luna Health Services, Software Apps and Luna Health Products. Please note that Apple is a registered mark of Apple Inc. and the App Store is a service mark of Apple Inc.
    By using any Luna Health Services, Software Apps or Luna Health Products, you agree with these Terms of Service. For your convenience, we have phrased some of the provisions of these Terms of Service in a question and answer format. Regardless of the format, all of the following terms together create a single legal agreement between you and Luna Health, Inc.. If a word or phrase is framed in these Terms of Service by “Quotation Marks” and marked in bold and italicized text, it means that we may use that word or phrase again, and it will have the same meaning as set forth in the sentence which first defines the word or phrase in quotation marks.
    1. Scope of Terms of Service and Agreement
    1.1 What products and services are covered by these Terms of Service? These Terms of Service apply to your use of any Luna Health Services, Software Apps and Luna Health Products. When using Luna Health Services, Software Apps or Luna Health Products, you must comply with these Terms of Service.
    
    1.2 Are there additional terms that apply to your use of Luna Health Services or Luna Health Products? Yes, in addition to the terms set forth in these Terms of Service (including the End User License Agreement applicable to specific Software Apps which is attached as Exhibit A), the following additional documents apply to your use of Luna Health Services and Luna Health Products (and collectively form what we refer to in these Terms of Services as this (“Agreement”):
    a) Any Description located at https://www.lunadiabetes.com.
    b) Documentation provided by Luna Health in the manual or packaging for Luna Health Products, or otherwise provided to you by Luna Health, including any Instructions for Use, Indications for Use, Contraindications and Product Warnings and Safety Statements (“Luna Health Product Labeling”); and
    c) The Luna Health Privacy Policy located at https://www.lunadiabetes.com/privacy-policy/.
    1.3 How do you accept this Agreement? Your use of any Luna Health Services or Luna Health Products or your download or use of any Software App is conditioned on your acceptance of the terms of this Agreement, and by accessing or using Luna Health Services or Luna Health Products, by downloading or using Software Apps, or by agreeing to this Agreement when the option is made available to you, such as by clicking “accept” when downloading a Software App, you are agreeing to the terms of this Agreement.
    1.4 Who can use Luna Health Services and Software Apps? Anyone may visit our Website, but by doing so they are agreeing to be subject to the laws of the State of California and the laws of the United States as described in this Agreement. Except as we may expressly provide otherwise in connection with each, the Luna Health Store, Data Services and Software Apps are provided from the United States and subject to the laws of the United States. We sell Luna Health Products from the United States. If you have purchased a Luna Health Product from a distributor located outside the United States, you should contact your distributor if you have any questions or need any support. Any warranty or other rights that may be provided with your Luna Health Product purchased from a distributor located outside the United States will be provided by that distributor and not by Luna Health. Luna Health is not a party to the agreement between you and your distributor.
    2. Using our Website
    2.1 What is our Website? Our Website describes Luna Health and our products and
    services and is available for public viewing in accordance with the terms of this Agreement.
    2.2 What is required for you to use our Website? Our Website is accessible through the internet by any computer with a compatible browser or phone or other smart device such as a tablet (we refer to each as a “Smart Device”) with a compatible mobile browser. You are responsible for each computer or Smart Device you use to access our Website, including providing and maintaining properly running compatible updated software, a suitable internet connection, an appropriate firewall and virus scanning software.
     
    3. Using Our Data Services and Software Apps
    3.1 What are our Software Apps? Software Apps may be available for download at https://www.lunadiabetes.com/. In addition, mobile applications may be downloaded at the Apple App Store and other download locations. We may provide Software Apps for your use on your computing devices or Smart Devices in connection with your use of Luna Health Products. Software Apps may provide stand-alone functionality or may be used in connection with our Data Services, or both.
    3.2 What are our Data Services? Our Data Services permit an individual to access, display or analyze the data generated by the Prescription Device User’s Luna Health System or other Luna Health device for which the Data Service is compatible (“User Device”) to help the Prescription Device User manage his or her diabetes in accordance with the applicable Luna Health Product Labeling. Use of our Data Services requires an internet-enabled Smart Device. Each Data Service uses a Software App to upload data from User Devices (“User Data”), process User Data applying its proprietary methodologies, and provide data and where applicable, reports, to Prescription Device Users, and may also permit Prescription Device Users to share or direct the Data Service to share Prescription Device User information including processed User Data, reports and other information relating to the Prescription Device User. Prescription Device Users are entitled to provide or direct the Data Service to provide such data and reports to others as they determine, and at their own responsibility.
    3.3 What is required for you to use our Data Services? If registration is required, then you are required to accurately complete the registration process and to provide all required information. You are responsible for accurately providing and maintaining all items required to use each Data Service as they change from time to time, including for each computer or Smart Device you use to access a Data Service, properly running compatible updated software (new versions), a suitable internet connection, an appropriate firewall and virus scanning software, a proper cable to connect your User Device to your computer or to a wireless or cell phone connection, and a properly maintained User Device. Although we may post information about the compatibility of particular Smart Devices with our Data Services on our Website, you are responsible for determining the compatibility for your particular Smart Device and you assume all risks associated with using Smart Devices that are not compatible with our Data Services.
    3.4 How do you use our Data Services? Data Services may directly interface and interoperate with your Luna Health Product, or may require the download of a Software App. Where a Software App is required, the Software App extracts the data from your User Device and sends it via the internet to Luna Health for processing of User Data and optionally returns it to you, and for sending to others if that is a feature of the Data Service, according to the functionality of the particular Data Service. If the Data Service sends User Data or other of your information to third parties, you select those third parties and their email, or other information used by the Data Service to send your information to such third parties, and Luna Health does not verify or validate any information regarding such third parties or the information you have provided regarding them. Once your information has been provided to a third party you designate, Luna Health has no further control or responsibility regarding that User Data or other
    
    information. You are responsible for connecting the computer or Smart Device running the Software App with the internet.
    3.5 Third Party Software Updates. Software Apps run on specific versions of third-party operating system and browser software for your computer or Smart Device (“Platform Software”). When the third-party provider issues an update to Platform Software, we will require additional time to provide a compatible update to the Software App. If you update Platform Software prior to our making available an appropriate update to a Software App, you may no longer be able to use the Software App(s) you have been using, or the Software App may not properly function. We may determine not to provide a compatible update to the Software App, and before you update Platform Software, you should check the applicable download site to determine if we have made available an appropriate update.
    3.6 Registration Process and Consistent Use. The use of certain Luna Health Products, Luna Health Services and Software Apps may require the creation and use of a Luna Health account (“Registration Process“). As part of the Registration Process, you may be required to provide the serial number of the User Device for you or the person on whose behalf you are completing the Registration Process. Certain Luna Health Products, Luna Health Services and Software Apps will archive and store the data generated by the applicable User Device. As a result, such Luna Health Products, Luna Health Services and Software Apps must be used only with the applicable User Device. Failure to do so may, among other matters, (a) cause the applicable Luna Health Product, Luna Health Service or Software App to perform improperly, or not to perform at all, (b) corrupt the User Data, or (c) cause inaccurate User Data to be associated with the User or cause the User Data to be inaccurately displayed or analyzed.
    3.7 What rights do you have to the Luna Health Services and the Software Apps? Upon your acceptance of this Agreement, and so long as you comply with the terms of this Agreement, until either party terminates this Agreement, Luna Health grants you the personal, limited and nonexclusive right to use (a) our Website for your personal noncommercial use, (b) Data Services as they are intended to be used as described at the relevant page of our Website or in materials provided through the Data Services, and (c) Software Apps as they are intended to be used as described at the relevant page of our Website, in the Software App or in materials provided by Luna Health with or for the Software App, all in accordance with the terms of this Agreement. Luna Health and its licensors own all right, title and interest to the Luna Health Services and the Software Apps, and the information, artwork and other content available through or at Luna Health Services and Software Apps and the processes, methodologies, documents and other materials we use to provide the Luna Health Services and Software Apps or that we provide to you in connection with your use of Luna Health Products, Luna Health Services, or Software Apps, and all patent, copyright, trademark, trade secret, and other rights of any nature arising from or relating in any way to Luna Health Products, Luna Health Services, and Software Apps (collectively the “Intellectual Property Rights“). Luna Health Products, Luna Health Services and Software Apps are subject to the patent, copyright and other notices of Intellectual Property Rights provided by Luna Health in connection with each, and you must abide by the requirements in all of such notices. All Intellectual Property Rights are reserved by Luna Health and its licensors, and no Intellectual Property Rights are granted to you except as

    set forth in this Section 3.7. Software Apps may be subject to terms required by third party vendors, and you will be notified of those terms in the applicable End User License Agreement, Description of the Service, through your account or by other notice from Luna Health. Trademarks, servicemarks, trade dress, logos, names and other symbols identifying Luna Health, Luna Health Services, Luna Health Products, and Software Apps, and the goodwill relating thereto, including “Luna Health” and “Luna,” are owned by Luna Health and its licensors. You may not remove or alter any notice provided by Luna Health on or in connection with Luna Health Products, Luna Health Services or Software Apps.
    3.8 What third party requirements do you have to comply with? Luna Health Products, Luna Health Services and Software Apps may include software, data or other items licensed to us by third parties. Your use of such third party items is subject to the provisions of this Agreement, except as required otherwise by the vendor. You will comply with the additional license provisions required by vendors of such third party items posted by us at our Website or otherwise provided to you or made available to you by us, as they are amended by us from time to time, and the most current version of such license provisions are incorporated into and made a part of this Agreement.
    3.9 What age do you have to be to use Luna Health Services or Software Apps? Only an adult or a minor with the legal right to bind himself or herself to contract terms under applicable law can agree to the terms of this Agreement and use Luna Health Services or Software Apps. By agreeing to this Agreement, you are representing that you are an individual at least 18 years old or that you have the legal right to bind yourself to contract terms under applicable law, and you are using the Luna Health Services or Software Apps for yourself, you are the parent or legal guardian of a minor on whose behalf you are using the Luna Health Services or Software Apps, or you have the legal right to act on behalf of another adult on whose behalf you are using the Luna Health Services or Software Apps.
    3.10 What other restrictions apply to your use of Luna Health Services and Software Apps? You will not, and you will not permit anyone under your control to, do or attempt to do any of the following except as expressly permitted by this Agreement:
    a) use Luna Health Services or Software Apps to harm, threaten, or harass any person or organization;
    b) use Luna Health Products, Luna Health Services or Software Apps for commercial purposes or to benefit any third party;
    c) use or attempt to use any unauthorized means to modify, reroute, or gain access to Luna Health Services;
    d) damage, disable, overburden, interfere with or impair Luna Health Services (or any network or device connected to a Luna Health Service);
    e) enable unauthorized third-party applications to access Luna Health Products or Luna Health Services or interface with any Software App;

    f) share your account password or otherwise authorize a third party to access or use Luna Health Services or Software Apps on your behalf unless we provide an approved mechanism;
    g) sublicense or transfer any of your rights under this Agreement;
    h) modify, copy or make derivative works based on any Luna Health Service or Software App;
    i) reverse engineer or derive the source code for any Luna Health Product, Luna Health Service or Software App not provided to you in source code form;
    j) create Internet “links” to or from any Luna Health Service, or “frame” or “mirror” any content which forms part of any Luna Health Service or Software App;
    k) use any automated process or service (such as a bot, a spider, or periodic caching of information) to access or use any Luna Health Service or Software App, or to copy or scrape data from any Luna Health Product, Luna Health Service or Software App;
    l) otherwise use any Luna Health Product, Luna Health Service or Software App in any manner that exceeds the scope of use granted to you in this Agreement or set forth in any Luna Health Product Labeling; or
    m) use unauthorized software or hardware to access any Luna Health Product, Luna Health Service or Software App or modify any Luna Health Product, Luna Health Service, Software App in any unauthorized way (e.g., through unauthorized repairs, unauthorized upgrades, or unauthorized downloads).
    You agree that we have the right, but not the obligation, to send data, applications or other content to any software or hardware that you are using to access a Luna Health Service or use a Software App for the purpose of detecting an unauthorized modification and/or disabling the modified device.
    3.11 What can happen if you misuse your Luna Health Product? Misusing a Luna Health Product, improperly accessing it or the information it processes and transmits, “jailbreaking” your Luna Health Product (improperly accessing the hardware or software comprising the Luna Health Product), and taking other unauthorized actions may put the User at risk, cause the Luna Health Product to malfunction, is not permitted and voids any warranty that may be provided with your Luna Health Product.
    3.12 Can you use third party software or equipment with Luna Health Products, Luna Health Services or Software Apps? Luna Health does not endorse, recommend or validate any third party software or equipment for use with Luna Health Products, Luna Health Services or Software Apps. Any use by you of any such third party software or equipment is at your sole risk. Luna Health has no responsibility or liability arising from your use of such third party software or equipment, such as damage to your Luna Health Products or problems, inaccuracies or malfunctions in Luna Health Products, Luna Health Services or Software Apps arising from such use.

    3.13 Can you use Jailbroken Smart Devices? You are required to use Smart Devices in the condition provided by the manufacturer. “Jailbroken” Smart Devices are those Smart Devices that have been modified in an unauthorized manner to permit the loading of unauthorized software or the unauthorized pulling of data from the Luna Health Product, Software App, Data Service or Smart Device to another Smart Device, software application, data service or other means to store or process such data. Jailbroken Smart Devices create unacceptable security risks, and you agree you will not use a Jailbroken Smart Device in connection with Luna Health Services or Software Apps.
    3.14 What happens if Luna Health Services or Software Apps are unavailable? Luna Health Services and Software Apps may be interrupted or unavailable, and if they are, you must rely upon direct use of the User Device for the Prescription Device User’s health monitoring.
    3.15 What happens if you provide feedback to Luna Health? You are not required to, but you may in your discretion choose to provide written or verbal feedback, suggestions, comments, or input to Luna Health relating to Luna Health Services, Software Apps, User Devices, or other opportunities for Luna Health’s existing or future activities (“Feedback“). By providing Feedback to Luna Health, you grant to Luna Health the worldwide, nonexclusive, unrestricted, perpetual, irrevocable (on any basis whatsoever), royalty free right for Luna Health to use such Feedback in any way it determines, including through third parties, without any obligation to you for compensation, attribution, accounting or otherwise. You will only provide to Luna Health Feedback for which you have the right to grant to Luna Health the rights in the preceding sentence.
    3.16 Luna Health Services are not medical or healthcare services. You understand that Luna Health does not provide medical, health or other professional services or advice, nor does Luna Health perform any verification of the accuracy of User Data. Luna Health Services and Software Apps are not replacements for proper medical care, and you agree that you are solely responsible to obtain proper treatment for your conditions. You are permitted to provide the information and reports received from Data Services to your healthcare providers at your own risk and responsibility, understanding that Data Services are provided without warranty except as required by law, as set forth in this Agreement. By purchasing, registering or using Luna Health Products, Luna Health Services or Software Apps, you are making certain assurances to Luna Health. You represent, warrant and agree that all information you provide to us will be true, accurate, current and complete, and you will only use Data Services and Software Apps for the personal benefit of the Prescription Device User in accordance with this Agreement. Data Services are not a substitute for regular monitoring and medical care, and you will ensure that all appropriate treatment, attention and efforts are made by and for the benefit of the Prescription Device User to maintain his or her health and wellness.
    3.17 Your responsibility for third party actions. You are responsible for any act or omission by any person that accesses or uses any Luna Health Product, Luna Health Service, or Software App under your account, using your password or from your computer or Smart Device.

    3.18 Luna Health is not responsible for third party matters. Without limiting the provisions of this Agreement or expanding the scope of Luna Health’s responsibilities, Luna Health is not responsible for outages or defects in power, telecommunications, computers, Smart Devices, third party software and any other impact outside of Luna Health’s direct control.
    4. Personal Data
    4.1 Who is entitled to use the User Data uploaded from your User Device and the other information you provide to Luna Health through Luna Health Services and Software Apps? By using any Luna Health Services or Software Apps, you hereby grant to us the right to use your User Data and the other information you provide to Luna Health through Luna Health Services and Software Apps (we refer to all of that information as "Personal Data") as set forth in the Luna Health Privacy Policy.
    4.2 What can you do with the User Data received from a Data Service? You can use the User Data received from a Data Service as information to help you better control your diabetes. You are permitted to provide your User Data to any person or entity you determine, and your decision whether and to whom to provide such data is your responsibility and you do so at your own risk.
    5. Suspension and Termination of Luna Health Services
    5.1 Can Luna Health suspend Luna Health Services? Luna Health can suspend Luna
    Health Services from time to time as it determines, for all Users or for any User.
    5.2 Can Luna Health terminate Luna Health Services or your right to use Software Apps? Luna Health may terminate any Luna Health Service or your right to use any Software App at any time, and may discontinue supporting any version of a Luna Health Product, Luna Health Service or Software App when a new version is released. Luna Health has no obligation to support any discontinued Luna Health Product, Luna Health Service or Software App. Luna Health may also terminate your access if you breach the terms of this Agreement.
    5.3 Can you terminate Data Services or your use of Software Apps? You may terminate any Data Service at any time by notice through your account, if you have one, and if not, then by ceasing your use of the Data Service. You may terminate your use of any Software App as you determine, and you may delete it from your Smart Device, and you may remove it from your computer using your operating system removal procedures if you use a Windows® based computer, or by downloading an uninstall program from our Website if you use an Apple® based computer. You are not obligated to continue using any Data Service or Software App whether you terminate or not.
    5.4 What happens if a Luna Health Service is terminated? If a Luna Health Service is terminated for any reason, (a) we will retain all Personal Data and Personal Information (as defined in the Luna Health Privacy Policy) of yours associated with your use of a Luna Health Service for which you are registered, (b) your rights to the Luna Health Service and any associated Software App terminate, and (c) all provisions of this Agreement which by their

    nature continue to apply after termination will survive such termination and continue to apply to the parties. If you later re-activate your account and we then have retained your Personal Data and/or Personal Information, we would reassociate it with your new account if you provide us with appropriate information enabling us to make the proper association and we are then able to do so.
    6. Privacy
    6.1 How does Luna Health protect the privacy of your Information? Luna Health protects your privacy according to the Luna Health Privacy Policy which describes how we may use your Information. If there is an actual or suspected breach of the security of your Information provided to Luna Health in connection with Luna Health Services, or any unpermitted disclosure or use of such personal information, and we are required to provide notice of such actual or suspected breach or unpermitted disclosure or use to you under applicable law, you agree that such notice may be provided by Luna Health by email to your email address registered with us at the time of such notice.
    7. Changes
    7.1 Can Luna Health change the terms of this Agreement? Yes, Luna Health can change the terms of this Agreement by posting an update to the Luna Health site where this document is posted. Your continued use of any Luna Health Product, Luna Health Service or Software App indicates your acceptance of, and your agreement to be bound by, the new terms.
    7.2 Can Luna Health change Luna Health Services or Software Apps? Luna Health Services and Software Apps, and the business, development and activities of Luna Health, are subject to change as determined from time to time by Luna Health in its discretion.
    8. Disputes, Binding Arbitration and Class Action Waiver
    8.1 How are dispute resolved under this Agreement? Disputes regarding the validity or enforcement of Intellectual Property Rights will be resolved exclusively in the courts located in San Diego, California. You and Luna Health each irrevocably consent to the personal and subject matter jurisdiction and venue of the courts located in San Diego, California for any such dispute. Any other dispute will be resolved exclusively by final and binding arbitration as described below.
    8.2 What laws govern this Agreement? You are contracting with Luna Health, Inc., a Delaware corporation headquartered in San Diego, California. Performance of this Agreement will occur in San Diego, California. This Agreement is governed by and will be construed in accordance with the internal laws of the state of California applicable to contracts entered into and performed within California, excluding choice of law or conflict of principles.
    8.3 Notice of Dispute. In the event of a dispute arising under or relating to this Agreement, the disputing party must provide the other party with written notice of the dispute, including the facts giving rise to the dispute and the relief sought by the disputing party. We will provide such

    notice by email to your email address. You will provide such notice to Luna Health by mail or overnight delivery at the contact address listed on our website. For any dispute subject to arbitration, you and Luna Health will attempt to resolve the dispute through negotiation for 60 days from the date such notice is sent. After 60 days, either party may initiate arbitration if the dispute is not resolved.
    8.4 How long does a party have to bring a claim? You and Luna Health each agree that any claim arising under or relating to this Agreement will be brought within one year of when the party first has notice of the facts providing the basis for the claim.
    8.5 Litigation. Any violation of a party’s intellectual or industrial property rights will cause the non violating party irreparable harm for which monetary damages are an inadequate remedy, and the non violating party is entitled to temporary, preliminary and permanent injunctive relief and specific performance without the posting of bond or other security, or if required, the minimum bond or security required.
    8.6 Final and Binding Arbitration. A dispute subject to arbitration that is not informally resolved the parties will be resolved exclusively by final and binding arbitration under the Federal Arbitration Act. You are giving up your right to litigate or participate as a party or class member before a judge or jury for any such dispute. The decision of the arbitrator will be final and binding on the parties except for a limited right of appeal that is available under the Federal Arbitration Act. Any court with jurisdiction may enforce the arbitrator’s award, and the parties agree to the nonexclusive jurisdiction of the state and federal courts in San Diego, California, for such purposes.
    8.7 Class Action Waiver. Any Proceeding To Resolve Or Litigate Any Dispute In Any Forum Will Be Conducted Solely On An Individual Basis. Neither You Nor Luna Health Will Seek To HaveAnyDisputeHeardAsAClassActionOrInAny OtherProceedingInWhichEitherParty Acts Or Proposes To Act In A Representative Capacity. No Arbitration Or Litigation Will Be Combined Or Consolidated With Another Without The Prior Written Consent Of All Parties To All Affected Arbitrations Or Litigations Including The Consent Of Luna Health.
    8.8 Arbitration Procedure. Any arbitration under this Agreement will be conducted by the American Arbitration Association under its Supplementary Procedures for Consumer-Related Disputes. You may commence arbitration in your county of residence within the United States or in San Diego, California. Luna Health will only commence arbitration in your county of residence if you reside within the United States or in San Diego, California if you do not. The arbitrator may award damages to each party individually to the same extent a court could. The arbitrator may award injunctive relief and specific performance only to you or Luna Health individually and only to the extent required to satisfy the individual claim.
    9. No Warranties
    9.1 Except As Required By Applicable Law, Luna Health Services And Software Apps, And Except For Any Limited Warranty Included In Luna Health Product Labeling, Luna Health

    Products, Are Provided “As-is” And On An “As Available” Basis Without Any Warranty Express Or Implied, And You Use Luna Health Products, Luna Health Services And Software Apps At Your Own Risk. Luna Health Disclaims All Implied Warranties, Including Any Implied Warranties Of Merchantability, Fitness For A Specific Purpose Or Use, Quiet Enjoyment, Accuracy, Operation, Compliance With Documentation, Or Non-infringement. Luna Health Disclaims, And This Agreement Does Not Include, The Provisions Of The Uniform Computer Information Transactions Act, The Uniform Commercial Code, And Any Other Provisions Implied Into This Agreement If Not Disclaimed. Luna Health Does Not Warrant That Luna Health Products, Luna Health Services Or Software Apps, Or Any Data Or Reports Provided By Luna Health, Will Meet Your Requirements, Be Retrievable, Uninterrupted, Timely, Secure, Or Error-free Or That All Errors Will Be Corrected. Luna Health Does Not Make Any Warranty As To The Results That May Be Obtained From The Use Of Luna Health Products, Luna Health Services Or Software Apps. Luna Health Does Not Warrant Any Third Party Device, Software, Service Or Data That You May Use In Connection With Any Luna Health Product, Software App Or Luna Health Service, Whether Or Not Such Third Party Item Is Described At, Or Available Or Can Be Connected To Through Any Luna Health Product, Software App Or Luna Health Service. No Information Or Communications, Whether Oral Or Written, Obtained By You From Or Through Luna Health Or Luna Health Products, Luna Health Services Or Software Apps Will Create Any Warranty, Except For Any Limited Warranty Included In Luna Health Product Labeling.
    9.2 Luna Health Does Not Warrant The Accuracy Of Any User Device, And The User Data Uploaded From Any User Device Is Received By Luna Health And Provided To The User “As-is.” Luna Health Does Not Assume Any Obligation To, And Does Not Warrant That It Will, Create Or Include Additional Features Or Functionality For Luna Health Products, Luna Health Services Or Software Apps.
    9.3 Except As Included In Any Luna Health Product Labeling, If You Are Dissatisfied With Any Portion Of Luna Health Products, Luna Health Services, Or Software Apps, Your Sole And Exclusive Remedy Is To Discontinue Their Use.
    10. Liability Limitations and Your Responsibility
    10.1 You Agree That Luna Health Products, Luna Health Services And Software Apps Are Provided By Luna Health, And Only Luna Health Will Have Any Liability Arising From Or Relating To Luna Health Products, Luna Health Services, Software Apps, Or This Agreement. To The Maximum Extent Permitted Under Applicable Law, In No Event Will Luna Health’s Affiliates, Licensors, Suppliers And Other Contract Relationships, And The Officers, Directors, Employees, Consultants, And Agents Of Luna Health And Each Of Those Other Entities Have Any Liability Whatsoever Arising From Or Relating To Luna Health Products, Luna Health Services, Software Apps, Or This Agreement, Whether For Direct Or Any Other Type Of Damages Whatsoever.
    10.2 Neither Luna Health Nor Its Affiliates, Nor Any Officer, Director, Employee, Agent, Supplier Or Other Person Or Entity Associated With Any Of Them Will Be Liable For (A) Any Damages Arising From The Use Of Or Inability To Use Luna Health Products, Luna Health

    Services Or Software Apps, (B) Any Consequential, Indirect, Incidental, Special, Punitive Or Exemplary Damages, Damages Resulting From Loss Of Data Or Business Interruption Or For Total Damages For All Claims Arising From Or Relating To This Agreement, Luna Health Products, Luna Health Services And Software Apps In An Amount Greater Than $500, Or (C) The Actions Or Omissions Of User Or Any Third Party. The Provisions Of This Section Apply Whether The Claim Or Damages Are Based On Warranty, Contract, Tort (Including Negligence), Strict Liability Or Any Other Legal Theory, Even If Luna Health Or Its Affiliates Or A Person Affiliated With Either Of Them Has Been Advised Of The Possibility Of Damages Excluded In This Section And Even If Such Exclusions Cause This Agreement Or Any Remedy To Fail Of Its Essential Purpose.
    10.3 Some Jurisdictions Do Not Allow The Exclusion Of Certain Warranties Or The Limitation Or Exclusion Of Liability For Certain Damages. Accordingly, Some Of The Above Limitations And Disclaimers May Not Apply To You. To The Extent That We May Not, As A Matter Of Applicable Law, Disclaim Any Implied Warranty Or Limit Our Liabilities, The Scope And Duration Of Such Warranty And The Extent Of Our Liability Will Be The Minimum Permitted Under Such Applicable Law, And This Agreement Will Be Deemed Modified To The Minimum Extent Necessary To Comply With Such Applicable Law.
    10.4 Your Responsibility. You agree to indemnify, defend and hold harmless Luna Health, our affiliates, licensors, suppliers and other contract relationships, and the officers, directors, employees, consultants, and agents of each, from and against any and all third-party claims, liabilities, damages, losses, costs, expenses, fees (including reasonable attorneys’ fees and court costs) that such parties may incur as a result of or arising from (a) any information you submit, post or transmit through Luna Health Services or Software Apps, (b) your use of Luna Health Products, Luna Health Services or Software Apps, (c) your violation of this Agreement, or (d) your violation of any rights of any other person or entity.
    11. Notices
    We will provide any notice under this Agreement by email to your email address. You will provide such notice to Luna Health by mail to the address listed on our website.
    12. Severability
    Any provision of this Agreement determined to be void, invalid or unenforceable will be deemed modified to the minimum extent necessary to be effective, valid and enforceable, and the other provisions of this Agreement will remain in full force and effect and enforceable according to their terms.
    13. Assignment
    We may assign this Agreement in whole or in part at any time without any notice to you. You may not assign this Agreement or transfer any rights to use Luna Health Services or Software Apps.

    14. Export Restrictions
    Software Apps are subject to United States export control laws, and you will comply with those laws.
    15. Relationship; No Third Party Beneficiaries
    We are acting as an independent contractor, and nothing in this Agreement creates an agency or partnership. Except for Luna Health’s licensors, there are no third-party beneficiaries to this Agreement.
    16. Complete Agreement
    This Agreement is the complete and final agreement between the parties relating to Luna Health Products, Luna Health Services and Software Apps, supersedes any prior agreements or communications between the parties, and may only be modified by a new version or amendment posted by Luna Health at its website or otherwise provided by Luna Health to you. Failure to exercise or enforce any right or provision of this Agreement will not constitute a waiver of such right or provision. The section titles in this Agreement are for convenience only and
    have no legal or contractual effect.
    17. Copyright Infringement Claims
    The Digital Millennium Copyright Act of 1998 (the “DMCA”) provides recourse for copyright owners who believe that material appearing on the Internet infringes their rights under U.S. copyright law. If you believe in good faith that materials available on the Luna Health Services infringe your copyright, you (or your agent) may send to Luna Health a written notice by mail or by e-mail requesting that Luna Health remove such material or block access to it. If you believe in good faith that someone has wrongly submitted to us a notice of copyright infringement involving content that you made available through any Luna Health Service, the DMCA permits you to send to Luna Health a counter-notice. Notices and counter-notices must meet the then-current statutory requirements imposed by the DMCA. Notices and counter-notices must be sent in writing to Luna Health’s DMCA agent by e-mail to legal@lunadiabetes.com. We suggest that you consult your legal advisor before filing a DMCA notice or counter-notice. You may have equivalent rights under other applicable laws.
    In accordance with the DMCA and other applicable law, Luna Health has adopted a policy of terminating, in appropriate circumstances, Luna Health Service users who are deemed by Luna Health to be repeat infringers. Luna Health may also at its sole discretion limit access to the Luna Health Service and/or terminate the accounts of any Luna Health Service users who infringe any intellectual property rights of others, whether or not such users are deemed to be repeat infringers.
    Exhibit A
    End User License Agreement

    This End User License Agreement (“EULA”) sets forth additional terms applicable to your use of the Luna Health System and any other product or service we provide (we refer to these and the Software Apps we provide for you to use these Data Services collectively as the “Licensed Services”). By downloading or using the Licensed Services in any way, you agree with the terms of this EULA and the “Agreement” (as that term is defined in the Luna Health Terms of Service (“Terms of Service”) posted on the Luna Health website located at (https://www.lunadiabetes.com/), and this
    EULA and the Agreement together form the exclusive and binding contract between you and Luna Health regarding your use of the Licensed Services, and you and Luna Health each agree to comply with all of the provisions of this EULA and the Agreement. This EULA is also posted at www.lunadiabetes.com/terms-of-service. (Exhibit A)
    1. Definitions. Any capitalized terms used in this EULA have the definitions for such terms set forth in the Terms of Service. In addition, we use the following terms in this EULA:
    (a) “Luna Health Data Services” means the transmission of User Data from Luna Health Systems and the provision of notifications through any Luna Health System.
    (b) “Luna Health System” means our Luna Health controller, reservoir, charger, phone app and any accessories approved by Luna Health for use with any of the foregoing and any future versions or enhancements.
    (c) “Documentation” means any paper or electronic documentation (including without limitation, this EULA) included with the Luna Health System or provided, or made available, by Luna Health in connection with the use of the Luna Health System
    (d) “Luna App” means a Software App included in the Licensed Services that is installed on a User’s Smart Device to receive Luna user information and threshold notifications.
    (e) “Marks” means names, logos, designs and other materials displayed in connection with the Luna Health System or Support Services that constitute trademarks, tradenames, service marks, trade dress or logos of Luna Health or other entities.
    (f) “Our Content” means the information, artwork and other content in the Luna Health System or our Website.
    (g) “Our Technology” means the software, code, proprietary methods, technology and systems used to provide the Luna Health System and Support Services, including the Luna App.
    (h) “Service Description” means the most current description of the Luna Health System posted on the Website, and when we post a new description, it replaces the prior version.
    (i) “Support Services” means the technical and customer support services that Luna Health may offer from time to time to assist you with your use of Licensed Services and includes any
     
    information and materials we may provide in connection with these support services or make available in the Documentation.
    (j) “Third Party Items” means software, data or other items licensed to us by third parties. (k) “We”, “our”, and “us” means Luna Health.
    (l) “You” and “your” refers to each User of the Luna Health System.
    2. Luna Health System. The Luna Health System is made available to Users who have validly purchased and use the Luna Health System to monitor their insulin therapy. The Luna Health System administers insulin and the Luna App installed on a User’s Smart Device supports the setup and monitoring of the Luna System. Using the Luna App, each User can receive notifications and configure settings, including notification thresholds. All features of the Luna Health System are subject to the Service Description, and any conflict between this EULA and the Service Description is governed by the Service Description. Use of the Luna Health System is subject to the Documentation. The Documentation is incorporated into and made a part of this EULA, and you agree to comply with the requirements of the Documentation.
    3. Luna Health System Components.
    (a)“Luna Health Software” means the software components set forth below (additional detail may be included in the Service Description) and any other software necessary for the operation of the Luna Health System.
    (b)“Luna Health App” means the Luna Health Software installed on a User’s Smart Device supports the users to setup and monitor the Luna System. In addition the Luna Health app sends those data to the Luna Health Server, and receives information from the Luna Health Server.
    (c)“Luna Health Server” means the Luna Health Software hosted and operated by Luna Health that receives information from the Luna Health App, stores that information for a limited period of time determined by Luna Health and triggers notifications that are sent to the User’s Luna Health App.
    4. Luna Health System User Subscriptions. A Luna Health System User may be asked to subscribe to or register for certain Luna Health Services by submitting required information and accepting the terms of this EULA, all at the relevant portion of the Website or download site for the Luna App. To the extent any services offered as part of the Luna Health System require subscription or payment, use of the Luna Health System by the User is subject to subscription by the User and payment by the User of the required payments. A Luna Health System User may terminate any such subscription by following the instructions in the Luna Health App or at the Website.
    5. Luna Health Support. Luna Health may make available the Support Services, and if offered will be subject to the applicable terms posted by Luna Health at our Website. In connection with

    our provision of Support Services, you may provide us directly or through another person with information or access to information on your Smart Device or otherwise that relates to you, and you hereby authorize Luna Health to use such information and access for the purposes of assisting you to use the Luna Health System, and as otherwise permitted by our Privacy Policy.
    6. Users Not Legally Competent. A Luna Health System User who is not legally competent to make decisions may not directly sign up for the Luna Health System.
    The appropriate parent or legal guardian, conservator or other person with the legal right to act on behalf of such a User must complete all registration or subscription processes for the Luna Health System. The parent or legal guardian, conservator or other person with the legal right to act on behalf of a Luna Health System User not legally competent to make decisions represents, warrants and agrees that he or she (a) has the lawful authority to act on behalf of such Luna Health System User, and (b) will, and will ensure that the Luna Health System User does, comply with the requirements of this EULA and the Agreement.
    7. Website. Use of the Website is subject to the Terms of Service and any other policies posted on the Website, and you agree to comply with the provisions of those Terms of Service and policies.
    8. Limited License.
    (a) We hereby grant to you a limited, non-exclusive, nontransferable access right to use the Luna Health Inen System and the Support Services during the term of your subscription as follows, so long as you comply with the terms of this EULA and the Agreement.
    (b) The Luna Health System User is granted the right to download the Luna Health App onto his or her Smart Device and to use the Luna App solely as described in the Service Description and Documentation in connection with his or her use of the Luna Health System as a User.
    (c) You may use information received from the Luna Health System solely for the purposes of the User’s personal health.
    (d) You may use Support Services solely to support the use of the Luna Health System by you and your associated Users. You agree not to use or disclose Support Services for any other reason.
    9. Exclusions. You agree that you will not, and will not attempt to or permit anyone else to: (a) interfere in any manner with the operation of the Luna Health System, or the communications, network, systems, software and data used to operate and provide the Luna Health System; (b) distribute, sell, lease, rent, sublicense, assign, export, or transfer in any other manner any Luna Health Software or any other portion of the Luna Health System or otherwise use the Luna Health System for the benefit of a third party (other than a Luna Health System User); (c) modify, copy or make derivative works of any part of the Luna Health Software or any other component of the Luna Health System, or reverse engineer, disassemble, decompile, or translate any components of the Luna Health System, or otherwise attempt to derive the source

    code of any components of the Luna Health System; (d) create Internet “links” to or from the Luna Health System, or “frame” or “mirror” any content which forms part of the Luna Health System; or (e) otherwise use any portion of the Luna Health System in any manner that exceeds the scope of the limited license right granted above.
    10. Smart Devices. You are required to use Smart Devices in the condition provided by the manufacturer. “Jailbroken” Smart Devices are those Smart Devices that have been modified in an unauthorized manner to permit the loading of unauthorized software. Jailbroken Smart Devices create unacceptable security risks, and you agree you will not use a Jailbroken Smart Device in connection with the Luna Health System.
    11. Third Party Items. The Luna Health System and Support Services may include Third Party Items. Your use of Third-Party Items is subject to the provisions of this EULA, except as required otherwise by the vendor. You will comply with the additional license provisions required by vendors of Third-Party Items posted at https://www.lunadiabetes.com as they are amended by us from time to time, and the most current version of such license provisions are incorporated into and made a part of this EULA.
    12. Responsibility for Others. You agree to be responsible for any act or omission of any person that accesses any portion of the Luna Health System under your account, using your password or from your computer or Smart Device.
    13. Required Items and Actions. You are required to provide and maintain all items necessary for your proper operation of the Luna Health System. This includes a User’s Smart Device with appropriate access to download the Luna App. You are required to properly set up the Luna Health System and ensure the proper performance of your Smart Device.
    14. Your Assurances. You represent, warrant and agree that all information you provide to us will be true, accurate, current and complete, and you will only use the Luna Health nPen System for the personal benefit of the User in accordance with the Service Description and Documentation (including without limitation, this EULA). You will promptly inform us of any problems with Luna Health that you believe are resulting in inaccurate information or preventing you from using the Luna Health IPen System. The Luna Health System is not a substitute for regular monitoring and medical care, and you will ensure that all appropriate treatment, attention and efforts are made by the User to maintain the health and wellness of the User.
    15. Suggestions. You may in your discretion provide suggestions to us for changes to the Luna Health System or to our other products and services, new products or services, or other ideas for our business (“Suggestions”), and we welcome suggestions. By submitting a suggestion, you hereby grant to us a worldwide, non-exclusive, royalty-free, fully paid-up, unrestricted, sublicensable, transferable and irrevocable (on any basis whatsoever) license to use the suggestion in any way we determine without any compensation, attribution, accounting or other obligation to you.
    
    16. Privacy Policy. You will comply with the Luna Health Privacy Policy located at https://www.lunadiabetes.com/privacy-policy/ as it is amended by us from time to time, and the provisions of the most current version of the Luna Health Privacy Policy are incorporated into and made a part of this EULA.
    17. Luna Health Terms of Service. You will comply with the Terms of Service located at https://www.lunadiabetes.com/terms-of-service, as such terms are amended by us from time to time, and the provisions of the most current Terms of Service are incorporated into and made a part of this EULA.
    18. Changes to this EULA. We may change this EULA from time to time by posting a new version to the Luna Health site where this document is posted. Your continued use of the Luna Health System indicates your acceptance of, and agreement to be bound by, the new EULA terms.
    19. Discontinuation of or Modifications to Luna Health System. We reserve the right to modify or discontinue the Luna Health System and/or Support Services at any time with or without notice to you. If you object to any such change, you can terminate your subscription and your use of the Luna Health System. Continued use of the Luna Health System following notice of any such change will indicate your agreement with such change.
    20. Third Party Offerings. We may provide to you in connection with the Luna Health System the opportunity for you to receive products and services provided by third parties. We are not responsible for any such products and services, and those products and services are subject only to the terms offered by the third-party provider. We provide no services, warranties or support for any such third-party products and services, and you will hold only the provider and not Luna Health or any of our affiliates or any personnel of any of them responsible in connection with such third-party products and services. You should carefully review their privacy statements and other conditions of use.
    21. Links. Our provision of a link to any other website or location is for your convenience and does not signify our endorsement of such other site or location or its contents. We have no control over, do not review, and are not responsible for, these outside websites or their content. Access to any other websites linked to the Luna Health System or our Website is at your own risk. You should carefully review the applicable terms and policies, including privacy and data gathering practices, of any such third-party website. We Will Not Be Liable For Any Information, Software, Or Links Found At Any Other Website, Internet Location, Or Source Of Information, Nor For Your Use Of Such Information, Software Or Links, Nor For The Acts Or Omissions Of Any Such Websites Or Their Respective Operators.
    22. Ownership. Our Content and Technology are (a) copyrighted by Luna Health and/or its licensors under United States and international copyright laws, and all rights are reserved to Luna Health and its licensors, (b) subject to other intellectual property and proprietary rights and laws, and (c) owned by Luna Health or its licensors. Neither Our Content nor Our Technology may be copied, modified, reproduced, republished, posted, transmitted, sold, offered for sale, or
     
    redistributed in any way without our prior written permission and the prior written permission of our applicable licensors. You must abide by all copyright notices, information, or restrictions contained in or attached to any of Our Content or Our Technology and you may not remove or alter any such notice, information or restriction. Your use of our Content and Technology must at all times comply with this EULA.
    23. Suspension and Refunds. We may decline to provide the Luna Health System or Support Services at any time. If your right to use the Luna Health System or Support Services is terminated by us for any reason other than your failure to comply with this EULA, and you have paid for the use of the Luna Health System or Support Services for any period of time after such termination, we will refund amounts you have paid for any period of time after such termination. If you terminate your subscription to the Luna Health System or Support Services, you will not be due a refund of payments made by you prior to termination.
    24. Termination. You May Terminate Your Subscription And End Your Use Of The Luna Health System And/Or Support Services At Any Time. We May Terminate Your Use Of The Luna Health System And/Or Support Services And (If Applicable) Your Subscription At Any Time. Neither Party Needs Any Reason For Its Termination. You Agree That We Will Not Be Liable To You Or Any Other Party For Any Termination Of Your Access To And/Or Subscription To The Luna Health System Or Support Services. After Termination, You Have No Further Right To Use Any Portion Of The Luna Health System Or Support Services, Including The Luna Health App And Luna Health Software.
    25. No Medical Services. The Luna Health System is an information service and not medical services or any other licensed healthcare service. We do not monitor the information received from your Luna Health System or provided to your Smart Devices, and we will not provide you with notice through your Luna Health System. It is up to the Luna Health System User to determine what thresholds to set and how to use the features of the Luna Health System. The Luna Health System is not a replacement for the User’s regular healthcare and health monitoring.
    26. Interruptions. The Luna Health System and Support Services may be interrupted, unavailable, or even terminated, and the User must not rely upon direct use of the Luna Health System for the User’s health monitoring.
    27. No Responsibilities. Without limiting the provisions of this EULA or expanding the scope of the Luna Health System, Luna Health is not responsible for power outages, telecommunications outages or defects, unavailability of the Smart Device service, or any other impact on the Luna Health System outside the direct control of Luna Health.
    28. Disclaimer Of Warranties. Except For The Limited Warranty That Is Included With The Luna Health System, You Agree That Use Of The Luna Health System And Support Services Is At Your Sole Risk And The Luna Health System, Support Services And Website Are Provided On An “As Is” And “As Available” Basis. Luna Health Expressly Disclaims All Warranties Of Any Kind, Whether Express Or Implied, Including, But Not Limited To Any Warranties Of

    Merchantability, Fitness For A Particular Use Or Purpose, Non-infringement, Title, Condition, Quiet Enjoyment, Value, Accuracy Of Data, Compliance With Documentation, Or Operation. Luna Health Makes No Warranty That The Luna Health System Or Support Services Will Meet Your Requirements, Or That The Luna Health System Will Be Uninterrupted, Timely, Secure, Or Error Free; Nor Does Luna Health Make Any Warranty As To The Results That May Be Obtained From The Use Of The Luna Health System, Or That Defects In The Luna Health System Or Support Services Will Be Corrected. You Agree That Any Material Downloaded Or Otherwise Obtained Through Use Of The Luna Health System Or Support Services Is Done At Your Own Discretion And Risk And That You Will Be Solely Responsible For Any Damage Or Loss That Results From Such Material And/Or Information. No Information Or Communications, Whether Oral Or Written, Obtained By You From Or Through The Luna Health System Or Support Services Will Create Any Warranty Not Expressly Made By Luna Health In Writing Stating That It Is Intended To Be A Warranty.
    29. Limitation of Liability. You Agree That The Luna Health System And Support Services Are Provided By Luna Health, And Only Luna Health Will Have Any Liability Arising From Or Relating To The Luna Health System, Support Services, The Website Or The Documentation Including This Eula. To The Maximum Extent Permitted Under Applicable Law, In No Event Will Luna Health’s Affiliates, Licensors, Suppliers And Other Contract Relationships, Or The Officers, Directors, Employees, Consultants, And Agents Of Luna Health And Each Of Those Other Entities Have Any Liability Whatsoever Arising From Or Relating To The Luna Health System, Support Services, Website, Documentation Or This Eula, Whether For Direct Or Any Other Type Of Damages Whatsoever. You Also Agree That To The Maximum Extent Permitted Under Applicable Law, Luna Health Will Not Be Liable For Indirect, Incidental, Special, Consequential Or Exemplary Damages, Including But Not Limited To, Damages For Loss Of Revenues, Profits, Goodwill, Use, Data Or Other Intangible Losses (Even If Such Parties Were Advised Of, Knew Of Or Should Have Known Of The Possibility Of Such Damages, And Notwithstanding The Failure Of Essential Purpose Of Any Limited Remedy), Arising Out Of Or Related To Your Use Of The Luna Health System, Support Services Or The Website, Regardless Of Whether Such Damages Are Based On Contract, Tort (Including Negligence And Strict Liability), Warranty, Statute Or Otherwise. If You Are Dissatisfied With Any Portion Of The Luna Health System Or Support Services, Your Sole And Exclusive Remedy Is To Discontinue Use Of The Luna Health System Or Support Services. The Aggregate Liability Of Luna Health To You For All Claims Arising From Or Related To The Luna Health System, Support Services Or The Website Is Limited To The Lesser Of (I) The Amount Of Fees Actually Paid By You For Use Of The Luna Health System Or (Ii) One Hundred U.S. Dollars. Some Jurisdictions Do Not Allow The Exclusion Of Certain Warranties Or The Limitation Or Exclusion Of Liability For Incidental Or Consequential Damages. Accordingly, Some Of The Above Limitations And Disclaimers May Not Apply To You. To The Extent That We May Not, As A Matter Of Applicable Law, Disclaim Any Implied Warranty Or Limit Its Liabilities, The Scope And Duration Of Such Warranty And The Extent Of Our Liability Will Be The Minimum Permitted Under Such Applicable Law.
    30. Indemnification. You agree to indemnify, defend and hold harmless Luna Health, its affiliates, licensors, suppliers and other contract relationships, and the officers, directors, employees, consultants, and agents of each, from and against any and all third-party claims,

    liabilities, damages, losses, costs, expenses, fees (including reasonable attorneys’ fees and court costs) that such parties may incur as a result of or arising from (a) any information you submit, post or transmit through the Website, the Luna Health System or Support Services, (b) your use of the Website, the Luna Health System or Support Services, (c) your violation of the Documentation, including without limitation, this EULA, or (d) your violation of any rights of any other person or entity.
    31. Trademarks. The Marks owned by Luna Health and other entities used in connection with Luna Health or Support Services are listed or described in the Luna Health Terms of Service, which may be amended from time to time. Ownership of all such Marks and the goodwill associated therewith remains with us or those other entities.
    32. Geographical Restrictions. The Luna Health System and Support Services are not available for use by persons located outside the United States, and you represent that you reside within the United States.
    33. Open-Source Notices. Certain components of the Luna Health Software may be subject to open-source software licenses (“Open-Source Components“), which means any software license approved as open-source licenses by the Open Source Initiative or any substantially similar licenses. The Documentation includes copies of the licenses applicable to Open-Source Components. To the extent there is conflict between the license terms covering Open-Source Components and this EULA or the Agreement, the terms of such licenses will apply in lieu of the terms of this EULA or the Agreement. To the extent the terms of the licenses applicable to Open-Source Components prohibit any of the restrictions in this Agreement with respect to such Open-Source Components, such restrictions will not apply to such Open-Source Components.
    34. Miscellaneous. This EULA and the documents referred to within this EULA constitute the entire and exclusive and final statement of the agreement between you and us with respect to the subject matter hereof, and govern your use of the Luna Health System and Support Services, superseding any prior agreements or negotiations between you and us regarding the Luna Health System and Support Services. The validity, interpretation, construction and performance of this EULA will be governed by the laws of the State of California that apply to contracts entered into within the State of California and to be performed within the State of California, without giving effect to the principles of conflict of laws or choice of laws. Any dispute arising under or relating in any way to this EULA, the Luna Health System or Support Services will be resolved exclusively by final and binding arbitration in San Diego, California under the rules of the American Arbitration Association, except that either party may bring a claim related to intellectual property rights, or seek temporary and preliminary specific performance and injunctive relief, in any court of competent jurisdiction, without the posting of bond or other security. The parties agree to the personal and subject matter jurisdiction and venue of the courts located in San Diego, California, for any action related to this EULA, the Website, the Luna Health System, or the Support Services. Failure to exercise or enforce any right or provision of this EULA will not constitute a waiver of such right or provision. If any provision of this EULA is found by a court of competent jurisdiction to be invalid or unenforceable, it will be deemed modified to the minimum extent necessary to be valid and enforceable, and the

    remaining provisions will remain in full force and effect. You agree that regardless of any statute or law to the contrary, any claim or cause of action arising out of or related to use of the Website, the Luna Health System, the Support Services or this EULA must be filed within one year after such claim or cause of action arose or be forever barred. The section titles in this EULA are for convenience only and have no legal or contractual effect. We are acting as an independent contractor, and nothing in this EULA creates an agency or partnership. You may not assign your rights under this EULA without our prior written consent, and any attempted assignment will be null and void.
    35. Survival. The terms of Sections 1, 9, 12, 14-18, and 20-37 will survive the expiration or earlier termination of this EULA for any reason.
    36. Contact Us. If you have any questions about this EULA, please: (a) send us an email at support@lunadiabetes.com
    36. Version. This EULA is dated August 20, 2021. )

    """
    
    case privacyPolicyString = """

    PLEASE READ THIS PRIVACY STATEMENT CAREFULLY. LUNA HEALTH, INC. PRIVACY STATEMENT INTRODUCTION
    Privacy is very important to us. We also understand that privacy is very important to you. This Privacy Statement tells you how Luna Health and our affiliates, protect and use information that we gather through this Luna Health website (the “website”) as well as our Luna Health medical product and the software or mobile application (the “application”) that support it (“Luna Health Services,” and, together with the website, our “Services”). This Privacy Statement does not apply to Luna Health websites that do not expressly link to it. You should review the privacy statement posted on other Luna Health websites when you visit them. This website, the application and this Privacy Statement are intended for a U.S. audience.
    By using the Services, you agree to the terms of the most recent version of this Privacy Statement. Please also read our Terms of Use to understand the general rules about your use of our Services. Except as written in any other disclaimers, policies, terms of use, or other notices on this website or application, this Privacy Statement and the Terms of Use are the complete agreement between you and Luna Health with respect to your use of the Services.
    Please note that this Privacy Statement does not cover Protected Health Information (“PHI”) under HIPAA. For our policies regarding your health information, please see our Notice of Privacy Practices.
    When we use the term “Personal Information” in this Privacy Statement, we mean information relating to an identified or identifiable individual.
    WHAT PERSONAL INFORMATION DO WE COLLECT?
    Information We Collect on Our Website
    When you visit our website or contact us through a method provided on our website, you may provide us with personal information, including your name, birth date, address and other contact information, your doctor’s name, and pharmacy benefits information We use this information to contact you, respond to your questions, and to provide our Services. In some places on this website you have the opportunity to send us personal information about yourself, to elect to receive particular information, or to participate in an activity. For example, you may fill out a registration form, a survey, or an e-mail form and you may elect to receive educational material about our products and therapies.
    You also may choose to allow us to personalize your visits to the website, in which case we will ask you for certain personal information to make your visits to our website more helpful to you. When this information is combined with the information that we collect through cookies and
    
    online information (described below), we will be able to tell that you have visited our website before and can personalize your access to our website, for example, by telling you about new features that may be of interest to you.
    Information We Collect Through the Luna Health Services
    We collect the following Personal Information through the Luna Health Services:
    ● Demographic information, such as your name, date of birth, gender, height, weight and photo/avatar
    ● Contact information, such as your e-mail address, phone number and mailing address
    ● Information about your diabetes care, such as your diabetes type, year of diagnosis,
    glucose values, insulin temperature, carbs/meals and insulin type, doses, prior insulin
    delivery method, therapy settings and recommendations
    ● Information about your use of the Luna Health Services and mobile device, such as app
    usage data and date of first use
    ● Information related to your use of any linked products or services, such as a continuous
    glucose monitor
    ● Information about your health care provider, such as your health care provider’s name
    and contact information
    ● Information about your health insurance, such as the name and contact information for
    your health insurance and pharmacy benefit manager
    HOW DOES LUNA HEALTH KEEP AND USE PERSONAL INFORMATION?
    We may keep and use personal information we collect from you through our Services to provide you with access to our website and application, to facilitate the creation of your account and to otherwise provide you with, and support your use of, the Luna Health Services. In addition, we may keep and use your personal information:
    ● to respond to your requests
    ● to contact you regarding your use of the Luna Health Services
    ● to personalize your access to our website or application, for example, by telling you
    about new features that may be of interest to you
    ● to develop records, including records of your personal information
    ● to contact you with information that might be of interest to you, including, to the extent
    permitted by law, information about clinical trials and educational and marketing
    communications about products and services of ours and of others
    ● for analytical purposes and to research, develop and improve programs, products,
    services and content
    ● for U.S. healthcare providers, to link your name, National Provider Identifier (NPI), state
    license number, and/or your IP address to web pages you visit, for compliance, marketing, and sales activities

    ● to remove your personal identifiers (your name, e-mail address, social security number, etc.). In this case, you would no longer be identified as a single unique individual. Once we have de-identified information, it is non-personal information and we may treat it like other non-personal information
    ● to enforce this Privacy Statement and other rules about your use of this website
    ● to protect someone’s health, safety or welfare
    ● to protect our rights or property
    ● to comply with a law or regulation, court order or other legal process
    DOES LUNA HEALTH EVER SHARE PERSONAL INFORMATION WITH THIRD PARTIES?
    Luna Health will not share your personal information collected through the Services with an unrelated third party without your permission, except as otherwise provided in this Privacy Statement.
    We may disclose personal information collected through the Luna Health Services to healthcare providers, family members or other individuals involved in your care or support that you choose to register using the Luna Health Services to receive such information. We may also share personal information collected through the Luna Health Services with partners as permitted by applicable law and subject to safeguards, and with other persons, apps and devices that you choose to link to the Luna Health Services.
    In the ordinary course of business, we will share some personal information with companies that we hire to perform services or functions on our behalf. For example, we may use different vendors or suppliers to ship you products that you order on our website. In these cases, we provide the vendor with information to process your order such as your name and mailing address. In cases in which we share your personal information with a third-party vendor, we will not authorize them to keep, disclose or use your information with others except for the purpose of providing the services we asked them to provide.
    We may be legally compelled to release your personal information in response to a court order, subpoena, search warrant, law or regulation. We may cooperate with law enforcement authorities in investigating and prosecuting website visitors who violate our rules or engage in behavior which is harmful to other visitors (or illegal).
    We may disclose your personal information to third parties if we feel that the disclosure is necessary to:
    ● enforce this Privacy Statement and the other rules about your use of this website
    ● protect our rights or property
    ● protect someone’s health, safety or welfare
    ● fulfill obligations relating to a corporate sale, merger, dissolution, or acquisition
    ● comply with a law or regulation, court order or other legal process

    COLLECTING ONLINE INFORMATION
    If you visit our website to read or download information, such as information about a health condition or about one of our products, or if you use our application or other software as part of the Luna Health Services, we may collect certain information about you from your computer or mobile device. This information may include:
    ● The name of the domain from which you access the Internet
    ● The Internet Protocol address (“IP Address”) of the device you are using
    ● The type of browser and operating system you are using
    ● The date and time you access our website or application
    ● The internet address of the site from which you linked directly to our website
    ● Which pages you have visited on our website
    ● The search terms you use
    ● The links on which you click
    We also may collect this information through cookies, pixels, web beacons, and similar technologies (“cookies”) that work through placing a small file (like a text file or graphic) in your browser files when you visit. Cookies are used to collect information for business purposes, such as enabling essential website functions and improving the user experience. You are free to decline our cookies if your browser permits, but some parts of our website may not work properly for you if you do so.
    Luna Health may use third-party tracking, analytics and advertising providers, such as Google Analytic or Hubspot to act on our behalf to track and analyze your usage of our sites. Luna Health may also use third-party providers to enable certain functions, such as third-party login. For more information regarding how Google collects, uses, and shares your information please visit http://www.google.com/policies/privacy/partners/. To prevent Google Analytics from using your information for analytics, you may install the Google Analytics Opt-out Browser Add-on by visiting https://tools.google.com/dlpage/gaoptout. These third parties may collect, and share with us, as we may request, information sent by your browser or mobile device, including website usage information about visits to our sites and other usage information, measure and research the effectiveness of our advertisements, and track page usage and paths followed during visits through our sites. Also, these third-party providers may place our Internet banner advertisements on other sites that you visit, and track use of our Internet banner advertisements and other links from our marketing partners’ sites to our sites.
    Please refer to your browser Help instructions to learn more about managing cookies. And see below for an explanation of our use of cookies as well as how to opt out of our use of cookies.
    CHOICES ABOUT COOKIES AND OPT-OUT OPTIONS
    For more information on third-party advertising-related cookies and how to opt out of some cookies as you choose, see the descriptions and links below.
    
    Click here to visit the Network Advertising Initiative site to set preferences and opt out of third-party targeting cookies.
    WHAT DOES LUNA HEALTH DO WITH NON-PERSONAL INFORMATION?
    Non-personal information is information that cannot identify you or be tied to you. We are always looking for ways to better serve you and improve our website, the Luna Health Services and the other services and products we offer. We will use non-personal information from you to help us make our website, the Luna Health Services and the other services and products we offer more useful. We also will use non-personal information for other business purposes. For example, we may use non-personal information or aggregate non-personal information to:
    ● create reports for internal use to develop programs, products, services or content
    ● customize the information or services that are of interest to you
    ● share it with or sell it to third parties
    ● provide aggregated information on how visitors use our site, such as ‘traffic statistics’
    and ‘response rates,’ to third parties
    WHAT HAPPENS IF THE PRIVACY STATEMENT CHANGES?
    If we decide to make a significant change to our Privacy Statement, we will post a notice on the homepage of our website for a period of time after the change is made and, in some cases, will notify you of the change via email. Any changes will become effective when we post the updated Privacy Statement on our website, and your use of the Luna Health Services following these changes means that you accept the updated Privacy Statement.
    This Privacy Statement was last revised on August 20, 2021. WHAT ABOUT PRIVACY ON OTHER WEBSITES?
    This website may contain links to other websites. Some of those websites may be operated by Luna Health, and some may be operated by third parties. We provide the links for your convenience, but we do not review, control, or monitor the privacy practices of web sites operated by others. This Privacy Policy does not apply to any other website, even the other Luna Health web sites. We are not responsible for the performance of websites operated by third parties or for your business dealings with them. Therefore, whenever you leave this website, we recommend that you review each website’s privacy practices and make your own conclusions regarding the adequacy of these practices.
    DOES LUNA HEALTH EVER COMMUNICATE DIRECTLY WITH VISITORS TO THIS WEBSITE?
    We may contact you periodically by email, mail, telephone or text if you agree to that contact to provide information regarding programs, products, services and content that may be of interest

    to you. In addition, some of the features on this website allow you to communicate with us using an online form. If your communication requests a response from us, we will send you a response via email. The e-mail response or confirmation may include your personal information, including personal information about your health, your name, address, etc.
    ARE THERE SPECIAL RULES ABOUT CHILDREN’S PRIVACY?
    We will not intentionally collect on our website any personal information (such as a child’s name or e-mail address) from children under the age of 13. If you think that we have collected personal information from a child under the age of 13, please contact us.
    WHAT ABOUT SECURITY?
    Security is very important to us. We also understand that security is important to you. We have implemented security measures to protect your personal information from loss, misuse, and unauthorized access, disclosure, alteration, or destruction. While we have implemented security measures, please keep in mind that “perfect security” does not exist on the internet or elsewhere and no transmission of information is guaranteed to be completely secure. In particular, e-mail sent to or from this site may not be secure, and you should therefore take special care in deciding what information you send to us via email.
    HOW TO CONTACT Luna Health
    If you have questions or comments about this Privacy Statement, please contact us via email, support@lunadiabetes.com.
    )

    """
}

extension LocalizedString {
    var localized : String {
        return self.rawValue.localizedString(lang: "en")
    }
    
}
