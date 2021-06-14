//
//  NotificationExtension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation
import Foundation

extension Notification.Name {
    static let NotConnectedToInternet = Notification.Name("NotConnectedToInternet")
    static let SelectedTyreSizeSuccess = Notification.Name("SelectedTyreSizeSuccess")
    static let ServiceRequestSuccess = Notification.Name("ServiceRequestSuccess")
    static let ServiceRequestReceived = Notification.Name("ServiceRequestReceived")
    static let PlaceBidRejectBidSuccess = Notification.Name("PlaceBidRejectBidSuccess")
    static let UserServiceAcceptRejectSuccess = Notification.Name("UserServiceAcceptRejectSuccess")
    static let NewBidSocketSuccess = Notification.Name("NewBidSocketSuccess")
    static let BidAcceptedRejected = Notification.Name("bidAcceptedRejected")
    static let RequestRejected = Notification.Name("RequestRejected")
    static let RequestAccepted = Notification.Name("RequestAccepted")
    static let UpdateServiceStatus = Notification.Name("UpdateServiceStatus")
    static let UpdateServiceStatusUserSide = Notification.Name("UpdateServiceStatusUserSide")
    static let EditedBidAccepted = Notification.Name("EditedBidAccepted")
    static let BidCancelled = Notification.Name("BidCancelled")
    static let NotificationUpdate = Notification.Name("NotificationUpdate")
    static let PaymentSucessfullyDone = Notification.Name("PaymentSucessfullDone")
}
