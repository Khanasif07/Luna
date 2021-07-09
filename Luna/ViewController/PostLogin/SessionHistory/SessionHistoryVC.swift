//
//  SessionHistoryVC.swift
//  Luna
//
//  Created by Admin on 08/07/21.
//

import UIKit

class SessionHistoryVC: UIViewController {
    
    @IBOutlet weak var SessionHistoryTV: UITableView!
    
    var sectionHeader = ["July","June"]

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func filterBtnTapped(_ sender: AppButton) {
            let vc = SessionFilterVC.instantiate(fromAppStoryboard: .CGPStoryboard)
             navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func crossBtnTapped(_ sender: AppButton) {
        self.dismiss(animated: false, completion: nil)

    }
   

}

// MARK: - Extension For Functions
//===========================
extension SessionHistoryVC {
    
    private func initialSetup() {
    
        SessionHistoryTV.isHidden = false
       
        
        SessionHistoryTV.register(UINib(nibName: "SessionHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "SessionHistoryTableViewCell")
        
        SessionHistoryTV.delegate = self
        SessionHistoryTV.dataSource = self
        
     
        SessionHistoryTV.reloadData()
        
       // self.CGMTypesTV.registerCell(with: CGMTypeTableViewCell.self)
        
    }
    
}


// MARK: - Extension For TableView
//===========================
extension SessionHistoryVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SessionHistoryTableViewCell = SessionHistoryTV.dequeueReusableCell(withIdentifier: "SessionHistoryTableViewCell", for: indexPath) as! SessionHistoryTableViewCell
              
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        let sectionHeaderView = Bundle.main.loadNibNamed("SessionHistoryHeader", owner: self, options: nil)?.first as! SessionHistoryHeader
      
        if section == 0{
            sectionHeaderView.haedingLbl.text = "July"
            
        }
        else{
            sectionHeaderView.haedingLbl.text = "June"
        }
      
        return sectionHeaderView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
  
    
}
