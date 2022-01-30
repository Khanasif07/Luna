//
//  CornerCancelButton.swift
//  Luna
//
//  Created by Francis Pascual on 1/29/22.
//

import SwiftUI

struct CornerCancelButton: View {
    let text : LocalizedStringKey
    let action : () -> Void
    
    init(_ text: LocalizedStringKey, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image("cross", label: Text(text))
        }
    }
}

struct CornerCancelButton_Previews: PreviewProvider {
    static var previews: some View {
        CornerCancelButton("Close") {
            
        }
    }
}
