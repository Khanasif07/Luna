//
//  BridgeUIHostingController.swift
//  Luna
//
//  Created by Francis Pascual on 1/27/22.
//

import Foundation
import SwiftUI
import Combine

class BridgeUIHostingController<Content, Router> : UIHostingController<Content> where Content : View, Router : Exitable {
    var exitFlowCancellable: AnyCancellable? = nil
    
    public init(router: Router? = nil, rootView: Content) {
        super.init(
            rootView: rootView
        )
        
        exitFlowCancellable = router?.exiting
            .receive(on: RunLoop.main)
            .sink { _ in
                self.pop()
            }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}
