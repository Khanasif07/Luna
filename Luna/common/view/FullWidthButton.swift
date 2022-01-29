//
//  FullWidthButton.swift
//  Luna
//
//  Created by Francis Pascual on 1/29/22.
//

import SwiftUI

extension View {
    func fullWidthButton() -> some View {
        return self.buttonStyle(RoundedRectangleButtonStyle())
    }
}

struct RoundedRectangleButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
        
      Spacer()
      configuration.label
            .font(.system(size: 16, weight: .semibold, design: .default))
            .foregroundColor(configuration.isPressed ? Color.white.opacity(0.7) : Color.white)
      Spacer()
    }
    .padding()
    .background(Color("PrimaryButton").cornerRadius(8))
  }
}

struct FullWidthButton_Previews: PreviewProvider {
    static var previews: some View {
        Button("Test") {
            
        }
        .fullWidthButton()
    }
}
