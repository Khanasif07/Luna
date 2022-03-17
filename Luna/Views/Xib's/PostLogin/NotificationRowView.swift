//
//  NotificationRowView.swift
//  Luna
//
//  Created by Admin on 07/03/22.
//

import SwiftUI

struct NotificationRowView: View {
    
    var model: NotificationModel
    
    var body: some View {
        VStack(alignment: .leading,spacing: 5.0) {
            Text(model.description!).font(Font.custom("SF_Pro_Display_Regular", size: 14))
            Text((model.date?.getChatDateTimeFromTimeInterval(Date.DateFormat.hour12.rawValue))!).font(Font.custom("SF_Pro_Display_Regular", size: 12)).foregroundColor(.secondary)
            Divider()
        }.padding(.all, 20)
    }
}

struct NotificationRowView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationRowView(model: NotificationModel(title: "Notification",date: 1677890.0,description: "Hello",notificationId: "23rdytfygh,"))
    }
}
