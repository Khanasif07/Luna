//
//  BackButtonView.swift
//  Luna
//
//  Created by Francis Pascual on 1/27/22.
//

import SwiftUI

struct LunaBackButton : View {
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            Image("back")
                .frame(width: 40, height: 40, alignment: .center)
        }
        .buttonStyle(MyButtonStyle())
    }
}

private struct MyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .colorMultiply(configuration.isPressed ? Color.gray : Color.white)
    }
}

struct LunaBackButton_Previews: PreviewProvider {
    static var previews: some View {
        LunaBackButton()
    }
}
