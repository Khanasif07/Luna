//
//  AlertModal.swift
//  Luna
//
//  Created by Francis Pascual on 1/29/22.
//

import Foundation
import SwiftUI

struct AlertModal: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.black.opacity(0.5)
            
            content
                .padding(16)
                .background(Color.white)
                .cornerRadius(8)
                .padding(8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(BlurredBackground())
        .ignoresSafeArea(edges: .all)
    }
}

extension View {
    func alertModal() -> some View {
        return self.modifier(AlertModal())
    }
}

struct BlurredBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.alpha = 0.5
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
