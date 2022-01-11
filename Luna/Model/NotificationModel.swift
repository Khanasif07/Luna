//
//  NotificationModel.swift
//  Luna
//
//  Created by Admin on 11/01/22.
//

import Foundation

public struct NotificationModel: Codable {
    var date: TimeInterval?
    var notificationId: String?
    var title: String?
    var description: String?

    init(_ dict: [String:Any]){
        self.date = dict[ApiKey.date] as? TimeInterval ?? 0.0
        notificationId = dict[ApiKey.notificationId] as? String ?? ""
        title = dict[ApiKey.title] as? String ?? ""
        description = dict[ApiKey.description] as? String ?? ""
    }

    public init(title:String,date: TimeInterval,description: String,notificationId: String){
        self.title = title
        self.date = date
        self.notificationId = notificationId
        self.description = description
    }
}
