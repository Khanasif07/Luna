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
    case wait_Img_Upload
    case registerAgain
    case completeProfile
    case yourRegistrationRequestIsStillUnder
    case addFollowingGovtIssuedLicenceOrDocumentsHereForVerification
    case govtIssuedDoc
    case commercialRegister
    case vatCertificate
    case municipalityLicense
    case idOfTheOwner
    case register
    case yourRegRequestHasBeenAccepted
    case byDate
    case byServiceType
    case byStatus
    case tyreServices
    case oilSevices
    case batteryServices
    case offerAccepted
    case offerRejected
    case offerExpired
    case offerReceived
    case noOffers
    case costLowToHigh
    case service
    case lowToHigh
    case highToLow
    case ratingHighToLow
    // MARK: - Sign Up VC Values
    //==============================
    case bySigningDec = "bySigningDec"
    case tos = "tos"
    case privacyPolicy = "privacyPolicy"
    
    // MARK: - Profile VC Values
    //==============================
    case my_vehicle
    case my_Services
    case service_history
    case payments
    case saved_cards
    case added_location
    case change_password
    
    // MARK: - Garage Profile VC Values
    //==============================
    case service_Completed
    case bank_Account
    case my_Subscription
    case installation_price_range
    case location
    case description

    // MARK: - Profile VC Values
      //==============================
    case aboutUs
    case terms_Condition
    case privacy_policy
    case contactUs
    case changeLanguage
    case switchProfileTogarage
    case switchProfileToUser
    case createGarageProfile
    case reportAnIssue
    case faq
    case referFriend
    case name
    case garageRegistration
    case startRegistration
    case requirementToRegister
    case garageLogo
    case authorisedNameOfServiceCenter
    case locationOfYourServiceCenter
    case imagesOfyourServiceCenter
    case govtIssuedlicensesandDocuments
    case reviewAndRatings
    case garageLogoDesc
    case authorisedNameOfServiceCenterDesc
    case locationOfYourServiceCenterDesc
    case imagesOfyourServiceCenterDesc
    case govtIssuedlicensesandDocumentsDesc
    case choosePdf
    case addDetails
    case thisAllAboutMyServiceCenter
    case addFollowingGarageDetails
    case addLogo
    case saveContinue
    case enterServiceCenterName
    case serviceCenterNames
    case saveAndContinueBtn
    case help
    case addAccounts
    case addBankAccountDetails
    case addCreditDebitCardDetails
    case and
    case iAgreeTo
    case add
    case selectYourBank
    case enterAccountNumber
    case confirmAccountNumber
    case selectBank
    case AccountNo
    case confirmAccountNo
    case pleaseEnterYourBankAccountDetails
    case linkedAccount
    case selectServiceCenterFacility
    case serviceCenterFacility
    case serviceCenterImage
    case done
    case clearAll
    case uploadGarageLogo
    case update
    case enterVehicleMake
    case enterVehicleModel
    case enterModelYear
    case enteryYourVehicleDetails
    case wellGetYouExactTyreSize
    case vehicleMake
    case vehicleModel
    case modelYear
    case thePreferredOriginForMytyreWouldBe
    case setYourPreferencesAmongTyreBrandOrCountryOrigin
    case tyreBrand
    case countryOrigin
    case selectTyreBrand
    case selectCountryOrigin
    case brands
    case origin
    case selectBrand
    case brandName
    case selectCountry
    case countryName
    case arabianTyresWantToAccessYourCurrentLocation
    case allowCureentLocationWillHelpYouInGettingGreatOffers
    case allow
    case installationPriceRange
    case chooseOilType
    case theTypeOfOilAreYouLookingFor
    case thePreferredBrandForMyOilWouldBe
    case chooseOilBrand
    case selectType
    case oilType
    case selectTyreSize
    case weHaveFoundSutiableTyreForYourVehicleAsPerTheProvidedDetails
    case pleaseSelectAnyTyreToProceed
    case selectViscosity
    case weHaveFoundSutiableOilViscosity
    case pleaseSelectAnyViscosityToProceed
    case next
    case proceed
    case thePreferredBrandForBatteryWouldBe
    case chooseBatteryBrands
    case enterNumber
    case country
    case countries
    case chooseYourVehicleDetails
    case wellGetYouOilAccordingToTheProvidedDetails
    case numberOfTyre
    case edit
    case submitRequest
    case youAreRequestingForTyreServiceWith
    case sizeOfTyre
    case originOfTyre
    case productYear
    case skipAndSubmit
    case chooseQuantity
    case vehicleDetails
    case batteyRequest
    case batteryBrand
    case numberOfBattery
    case oilBrands
    case numberOfUnit
    case oilRequest
    case oilImage
    case selectNumberOfUnitYouWant
    case viewTutorial
    case viewProposal
    case underDevelopment
    case pleaseSelectServices
    case pleaseSelectServiceCenterImage
    case ongoingServices
    case ongoingService
    case tyreServiceRequest
    case batteryServiceRequest
    case oilServiceRequest
    case regNo
    case serviceStatus
    case requests
    case request_No
    case enterBiddingAmount
    case placeBid
    case biddingAmountOnceSubmittedWillNeverBeChanged
    case sar
    case notNow
    case placeABid
    case weHaveSent
    case otp
    case pleaseVerifyTheSameInOrderToStartServicing
    case to
    case verify
    case filters
    case apply
    case requestCreatedBy
    case requestAcceptedOn
    case paybleAmount
    case serviceDetails
    case tyreSize
    case preferredBrand
    case chat
    case startService
    case userDetails
    case paymentStatus
    case amountPaid
    case serviceRequest
    case distance
    case bidReceived
    case howWasOverAllExp
    case rateOutOfFive
    case describeWhy
    case uploadAnyPictureOfYourExperience
    case rateService
    case typeHere
    case fromDate
    case endDate
    case bidFinalized
    case openForBid
    case bidPlaced
    case bidRejected
    case applyFilters
    case editProfile
    case save
    case PLEASEUNBLOCKUSERTOSENDMESSAGES
    case please_create_account_to_get_good_sleep
    case please_login_to_get_good_sleep
    case PLEASEUNBLOCKUSERTOPERFORMTHISACTION
    case you_can_not_perform_this_action_as_you_are_blocked
    case you_can_not_perform_this_action_as_request_rejected
    case make_Payment_to_get_hassle_free_service
    case block
    case unBlock
    case blockUser
    case are_you_sure_you_want_to_block_this_user = "are_you_sure_you_want_to_block_this_user"
    case are_you_sure_you_want_to_unblock_this_user = "are_you_sure_you_want_to_unblock_this_user"
    case holdThisToRecord
    case serviceOn
    case garageQuestionMark
    case supportChat
    case pleaseUploadAtlestOneImage
    case vehicle
    case regNumber
    case requestedBy
    case noDataFound
    case noNotificationAvailable
    case payableAmount
    case carReceived
    case inGarage
    case readyToBeTaken
    case delivered
    case delete
    case inABid
    case bidFinalised
    case closedForBid
    case expired
    case bidClosed
    case openForBidding
    case resend
    case no
    case yes
    case viewDetails
    case hiUser
    case toContinuePerformingThisAction
    case successfullyRequested
    case yourRequestForTyreServiceHasBeenSubmittedSuccessfully
    case yourRequestForBatteryServiceHasBeenSubmitted
    case yourRequestForOilServiceHasBeenSubmitted
    case hi
    case verifyEmail
    case anOTPWillBeSendToYourPhoneNumber
    case aVerificationLinkWillBeSendToYourEmailAddress
    case verifyPhone
    case unitPriceShouldNotBeEmpty
    case accept
    case reject
    case accepted
    case asPerYourTyreService
    case thisBidIsProposedBy
    case cancelBid
    case imageUploadFailed
    case milesAway
    case hereIsYourOTPForTyreService
    
    // MARK: - Home  VC Values
    //==============================
    case tyre
    case oil
    case battery
    case garageDetails
    case requestNumber
    
    // MARK: - Garage Home Values
    //==============================
    case requestAccepted
    case newRequest
    case service_sheduled_for_today
    case today_Revenue
    case today
    case yesterday
    case allRequests
    case bookedRequests
    case serviceCompleted
    
    // MARK:c - Complete profile 1  VC Values
    //==============================
    case enterServiceCenterDist
    case enterServiceCenterAddress
    case serviceCenterDist
    case serviceCenterAddress
    
    case width
    case rimSize
    case quantity
    case enter_number_of_tyre_you_want
    case no_service_request_available
    case kindly_provide_the_access_to_record_audio
    case please_enter_different_amount_to_edit_bid
    case status
    
    // MARK: - Chat Screen
    //==============================
    case payNow
    case decline
    case paymentPaid
    case paymentDeclined
    case pending
    case pay
    case paid
    case paid_Caps
    case refunded
    case failed
    case you
    case delete_Message
    case do_you_want_to_delete_message
    case offerSmall
    case paymentSmall
    case successful
    case password_has_been_reset_successfully
    case otp_Verified
    case you_have_successfully_verified_your_mobile_no
    case are_you_sure_you_want_to_logout
   
    // MARK: - Updated Screen
    //==============================
    case requestSeen
    case bid_Received
    case lowest_Bid
    case nearest_Bid
    case bid_Amount
    case total_Amount
    case request_Detail
    case unit
    case tyres
    case leave_us_a_message_desc
    case do_you_have_an_issue_with_service
    case mode_Of_Payment
    case offers
    case need_Help
    case download_Invoice
    case what_service_are_you_looking_for
    case allOffers
    case proposalDetails
    case miles
    case quantityShort
    
    //Updated Localized String
    case please_Enter_Your_Mobile_Number_with_Country_Code
    case whatTyreOfTyreAreYouLookingFor
    case searchWithCar
    case chooseTheSizeOfTyre
    case notSureAboutTheSize
    case chatWithExpert
    case createNewAccount
    case pleaseSetNewPassword
    case resetPassword
    case selectCountryCode
    case oneTimePassword
    case pleaseEnter4DigitOtpCode
    case resendOtp
    case welcomeToTara
    case login_with_Social_Accounts
    case log_in
    case addImages
    case addressAndLocation
    case addImagesOfServiceCenter
    case addLocation
    case dragPointerToSetExactLocation
    case searchBankByName
    case make
    case model
    case selectVehicleMake
    case selectVehicleModel
    case justNow
    case weHaveReceivedYourRegistrationRequest
    case yourRegistrationRequestMadeOn
    case hasBeenRejectedDueToFollowingReasons
    case hasBeenAcceptedKindlyCompleteYourProfile
    case selectFacility
    case services
    case on
    case requestedOn
    case productImage
    case address
    case rim
    case vehicleYear
    case suitableFor
    case please_select_vehicle_width
    case please_select_vehicle_profile
    case please_fill_the_options_to_place_bid
    case unitPrice
    case unBlockUser
    case offerPrice
    case paymentRequest
    case photo_Attachment
    case audio_Attachment
    case editBid
    case paybleAmt
    case previousService
    case request_Rejected
    case to_continue_performing_this_action_please_login
    case batteryImage
    case uploadImage
    case your_request_for_battery_service_has_been_submited_successfully
    case your_request_for_oil_service_has_been_submited_successfully
    case allBrands
    case search_Brand_by_name
    case search_Country_by_name
    case ignore
    case view
    case at
    case garage
    case pleaseShowThisCodeToTheGarageToStartYourService
    case reset
    case serviceNo
    case amountRefunded
    case carServiceInProgress
    case carServiceCompleted
    case carReadyToBeTaken
    case review
    case noRating
    case notSatisfying
    case threatsOfVoilance
    case defamation
    case obscenity
    case inappropriateReview
    case reasonOfReport
    case goToChat
    case sendMessage
    case subject
    
     //Updated Localized String
    case type_your_message_here
    case view_All_Offer
    case minutesAgo
    case oneMinuteAgo
    case oneHourAgo
    case hoursAgo
    case daysAgo
    case lastWeek
    case secondsAgo
    case weeksAgo
    case lastMonth
    case monthsAgo
    case lastYear
    case rejectRequest
    case type_Your_Message_Here
    case search
    case myRatings
    case more
    case total_price
    case please_select_one_option_to_proceed
   
    case ongoing
    case _pending
    case completed
    case cancelled
    case serviceStarted
    case readyToPick
    case carReceived_QM
    case ratingAndReview
    case reviewReportedOn
    case reason
    case reportReview
    
    case signInWithFaceID = "Sign In with Face ID";
    case signInWithFingerPrint = "Sign In with Fingerprint";
    case invalidBiometrics = "Invalid biometric input";
    case lockedOutBiometric = "Biometric locked out";
    case loginError = "Your biometric is not associated with any account";
    case biometricAuthNotAvailable = "Your device doesn't support biometric authentication";
    case overrideBioMetricMessage = "Your biometric is already associated with one account. Do you want to replace your biometric with this account?";
    case error = "Error!";
    case biometric = "Biometric";
}



extension LocalizedString {
    
    var localized : String {

        let language = AppUserDefaults.value(forKey: .language).intValue
        return self.rawValue.localizedString(lang: "en")
        }

}
