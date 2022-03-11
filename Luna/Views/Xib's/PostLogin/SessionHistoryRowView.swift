//
//  SessionHistoryRowView.swift
//  Luna
//
//  Created by Admin on 09/03/22.
//

import SwiftUI

struct SessionHistoryRowView: View {
    
    var model: SessionHistory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 5) {
                Text(model.actualInsulin).font(Font.custom("SF_Pro_Display_Regular", size: 16))
                Text("units delivered").font(Font.custom("SF_Pro_Display_Regular", size: 16))
                Text("|").font(Font.custom("SF_Pro_Display_Regular", size: 16))
                Text("\(Int(model.range))").font(Font.custom("SF_Pro_Display_Regular", size: 16))
                Text("% in range").font(Font.custom("SF_Pro_Display_Regular", size: 16))
            }
            Divider().foregroundColor(Color.white)
        }.padding(.all, 20)
    }
}

struct SessionHistoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        SessionHistoryRowView(model: SessionHistory())
    }
}
