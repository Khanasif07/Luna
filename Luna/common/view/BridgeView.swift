//
//  BridgeView.swift
//  Luna
//
//  Created by Francis Pascual on 1/27/22.
//

import SwiftUI
import Combine

/// Eases the bridging of UIKit world to SwiftUI.
///
/// When using pure SwiftUI, there would be a top level entry point where environment objects and other such top-level concerns
/// are configured and passed down. This class helps set up those same concerns when hosting a SwiftUI view in UIHostingController.
struct BridgeView<Content>: View where Content : View {
    let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        content()
            .preferredColorScheme(.light)
    }
}
