//
//  InsulinStep2VC.swift
//  Luna
//
//  Created by Admin on 06/07/21.
//

import UIKit

class InsulinStep2VC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    
    // MARK: - Variables
    //===========================
    
    // MARK: - Lifecycle
    //===========================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}

// MARK: - Extension For Functions
//===========================
extension InsulinStep2VC {
    
    private func initialSetup() {
        
    }
}

// MARK: - Extension For TableView
//===========================
extension InsulinStep2VC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
