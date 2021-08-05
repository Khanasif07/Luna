//
//  SessionFilterVC.swift
//  Luna
//
//  Created by Admin on 08/07/21.
//

import UIKit

class SessionFilterVC: UIViewController {
    
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var EndLbl: UILabel!
    @IBOutlet weak var startlTF: UITextField!
    @IBOutlet weak var endTF: UITextField!

    @IBOutlet weak var proceedBtn: AppButton!
    @IBOutlet weak var ResetBtn: UIButton!
    
    
    private lazy var StartTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = .white
        picker.datePickerMode = UIDatePicker.Mode.date
        
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
            picker.sizeToFit()
        } else {
            // Fallback on earlier versions
        }
        return picker
    }()
    
    private lazy var EndTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = .white
        picker.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
            picker.sizeToFit()
        } else {
            // Fallback on earlier versions
        }
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
   
    // MARK: - IBActions
    //===========================
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        self.proceedBtn.isEnabled = true
       
        if startlTF.text == endTF.text {
            showAlert(msg: "End date and Start date can't be same.")
        }
        
        if startlTF.text == ""{
            showAlert(msg: "Please select Start Date.")
        }
        else if endTF.text == ""{
            showAlert(msg: "Please select End Date.")
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.pop()
    }

}


// MARK: - Extension For Functions
//===========================
extension SessionFilterVC {
    
    private func initialSetup() {
       // btmContainerView.setBorder(width: 1.0, color: #colorLiteral(red: 0.9607843137, green: 0.5450980392, blue: 0.262745098, alpha: 1))
      
        
        startLbl.text = "Start Date"
        startLbl.textColor = AppColors.fontPrimaryColor
        startLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        
        EndLbl.text = "End Date"
        EndLbl.textColor = AppColors.fontPrimaryColor
        EndLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        
        
        startlTF.layer.borderWidth = 1
        startlTF.layer.cornerRadius = 10
        startlTF.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        startlTF.layer.borderColor = AppColors.fontPrimaryColor.cgColor

        
        
        endTF.layer.borderWidth = 1
        endTF.layer.cornerRadius = 10
        endTF.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        endTF.layer.borderColor = AppColors.fontPrimaryColor.cgColor
        
        ResetBtn.setTitleColor(AppColors.appGreenColor, for: .normal)
        
        
        self.proceedBtn.layer.cornerRadius = 10
        self.proceedBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
        
        //....for start time
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = UIBarStyle.default
        toolBar2.isTranslucent = true
        toolBar2.tintColor = .white
        toolBar2.barTintColor = .white
        toolBar2.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(DoneStatyPicker))
        doneButton.tintColor = AppColors.appGreenColor
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let selectButton = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action:nil)
        selectButton.tintColor = .black

        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelStartPicker))
        cancelButton.tintColor = .red
        toolBar2.setItems([cancelButton, spaceButton1, selectButton,spaceButton, doneButton], animated: false)
        toolBar2.isUserInteractionEnabled = true
        startlTF.inputView = StartTimePicker
        startlTF.inputAccessoryView = toolBar2
        
        //....for end time
        let toolBar3 = UIToolbar()
        toolBar3.barStyle = UIBarStyle.default
        toolBar3.isTranslucent = true
        toolBar3.tintColor = .white
        toolBar3.barTintColor = .white
        toolBar3.sizeToFit()
        
        let doneButton2 = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(DoneEndPicker))
        doneButton2.tintColor = AppColors.appGreenColor
        
        let spaceButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let selectButton1 = UIBarButtonItem(title: "Select", style: UIBarButtonItem.Style.done, target: self, action:nil)
        selectButton1.tintColor = .black
        
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton2 = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelEndPicker))
        
        cancelButton2.tintColor = .red
        toolBar3.setItems([cancelButton2,spaceButton3, selectButton1,spaceButton2, doneButton2], animated: false)
        toolBar3.isUserInteractionEnabled = true
        endTF.inputView = EndTimePicker
        endTF.inputAccessoryView = toolBar3
    }
    
    // end time action
    @objc func cancelEndPicker(){
        view.endEditing(true)
    }
    
    @objc func DoneEndPicker(){
        let date = EndTimePicker.date
        let today = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        endTF.text = dateFormatter.string(from: today as Date)
        endTF.text = dateFormatter.string(from: today as Date)
        view.endEditing(true)
    }
    
    // start time action
    @objc func cancelStartPicker(){
        view.endEditing(true)
    }
    
    @objc func DoneStatyPicker(){
        print(StartTimePicker.timeZone)
        let date = StartTimePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "MM/dd/yyyy"
        startlTF.text = dateFormatter.string(from: date)
        startlTF.text = dateFormatter.string(from: date)
        view.endEditing(true)
    }
  
}