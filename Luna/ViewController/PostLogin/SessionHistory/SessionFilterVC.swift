//
//  SessionFilterVC.swift
//  Luna
//
//  Created by Admin on 08/07/21.
//

import UIKit

protocol SessionFilterVCDelegate: class {
    func filterApplied(startDate: Date?,endDate: Date?)
    func resetFilter()
}

class SessionFilterVC: UIViewController {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var EndLbl: UILabel!
    @IBOutlet weak var startlTF: AppTextField!
    @IBOutlet weak var endTF: AppTextField!
    @IBOutlet weak var proceedBtn: AppButton!
    @IBOutlet weak var ResetBtn: UIButton!
    
    // MARK: - Variables
    //===========================
    var startdate: Date?
    var enddate: Date?
    private lazy var startTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.backgroundColor = .white
        var minDateComponent = Calendar.current.dateComponents([.day,.month,.year], from: Date())
        minDateComponent.day = 01
        minDateComponent.month = 01
        minDateComponent.year = 2020

        let minDate = Calendar.current.date(from: minDateComponent)
        print(" min date : \(String(describing: minDate))")
        picker.datePickerMode = UIDatePicker.Mode.date
        picker.minimumDate = minDate
        picker.maximumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
            picker.sizeToFit()
        } else {
            // Fallback on earlier versions
        }
        return picker
    }()
    
    private lazy var endTimePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.maximumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
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
    weak var delegate: SessionFilterVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [startlTF,endTF].forEach { (txtflds) in
            txtflds?.setBorder(width: 1, color: AppColors.fontPrimaryColor)
            txtflds?.round(radius: 10.0)
            txtflds?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }
        self.proceedBtn.round(radius: 10.0)
        self.proceedBtn.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner,.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    // MARK: - IBActions
    //===========================
    @IBAction func resetBtnAction(_ sender: UIButton) {
        startlTF.text = nil
        endTF.text = nil
    }
    
    @IBAction func proceedBtnAction(_ sender: UIButton) {
        if startlTF.text == "" && endTF.text == ""{
            self.delegate?.resetFilter()
            self.pop()
            return
        }
        self.delegate?.filterApplied(startDate:  startdate, endDate:  enddate)
        self.pop()
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.pop()
    }
}

// MARK: - Extension For Functions
//===========================
extension SessionFilterVC {
    private func initialSetup() {
        proceedBtn.isEnabled = true
        self.setupFontsAndColor()
    }
    
    // end time action
    @objc func cancelEndPicker(){
        view.endEditing(true)
    }
    
    private func setupFontsAndColor(){
        self.startLbl.text = LocalizedString.start_date.localized
        self.startLbl.textColor = AppColors.fontPrimaryColor
        self.startLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        self.EndLbl.text = LocalizedString.end_date.localized
        self.EndLbl.textColor = AppColors.fontPrimaryColor
        self.EndLbl.font = AppFonts.SF_Pro_Display_Semibold.withSize(.x14)
        self.ResetBtn.setTitleColor(AppColors.appGreenColor, for: .normal)
        //....for start time
        let toolBar2 = UIToolbar()
        toolBar2.barStyle = UIBarStyle.default
        toolBar2.isTranslucent = true
        toolBar2.tintColor = .white
        toolBar2.barTintColor = .white
        toolBar2.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: LocalizedString.done.localized, style: UIBarButtonItem.Style.done, target: self, action: #selector(DoneStatyPicker))
        doneButton.tintColor = AppColors.appGreenColor
        
        let spaceButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let selectButton = UIBarButtonItem(title: LocalizedString.select.localized, style: UIBarButtonItem.Style.done, target: self, action:nil)
        selectButton.tintColor = .black
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: LocalizedString.cancel.localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelStartPicker))
        cancelButton.tintColor = .red
        toolBar2.setItems([cancelButton, spaceButton1, selectButton,spaceButton, doneButton], animated: false)
        toolBar2.isUserInteractionEnabled = true
        self.startlTF.inputView = startTimePicker
        self.startlTF.inputAccessoryView = toolBar2
        
        //....for end time
        let toolBar3 = UIToolbar()
        toolBar3.barStyle = UIBarStyle.default
        toolBar3.isTranslucent = true
        toolBar3.tintColor = .white
        toolBar3.barTintColor = .white
        toolBar3.sizeToFit()
        
        let doneButton2 = UIBarButtonItem(title: LocalizedString.done.localized, style: UIBarButtonItem.Style.done, target: self, action: #selector(DoneEndPicker))
        doneButton2.tintColor = AppColors.appGreenColor
        
        let spaceButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let selectButton1 = UIBarButtonItem(title: LocalizedString.select.localized, style: UIBarButtonItem.Style.done, target: self, action:nil)
        selectButton1.tintColor = .black
        
        let spaceButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton2 = UIBarButtonItem(title: LocalizedString.cancel.localized, style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelEndPicker))
        
        cancelButton2.tintColor = .red
        toolBar3.setItems([cancelButton2,spaceButton3, selectButton1,spaceButton2, doneButton2], animated: false)
        toolBar3.isUserInteractionEnabled = true
        endTF.inputView = endTimePicker
        endTF.inputAccessoryView = toolBar3
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.DateFormat.mmddyyyy.rawValue
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        if let startDate = startdate {
            self.startlTF.text = dateFormatter.string(from: startDate as Date)
        }
        if let endDate = enddate {
            self.endTF.text = dateFormatter.string(from: endDate as Date)
        }
    }
    
    @objc func DoneEndPicker(){
        let date = endTimePicker.date
        self.enddate = date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = Date.DateFormat.mmddyyyy.rawValue
        self.endTF.text = dateFormatter.string(from: date)
        view.endEditing(true)
        self.proceedBtn.isEnabled = (self.startdate != nil && self.enddate != nil)
    }
    
    // start time action
    @objc func cancelStartPicker(){
        view.endEditing(true)
    }
    
    @objc func DoneStatyPicker(){
        let date = startTimePicker.date
        self.startdate = date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = Date.DateFormat.mmddyyyy.rawValue
        self.startlTF.text = dateFormatter.string(from: date)
        view.endEditing(true)
        self.endTF.text = ""
        self.enddate = nil
        endTimePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 0, to: startTimePicker.date)
        self.proceedBtn.isEnabled = (self.startdate != nil && self.enddate != nil)
    }
    
}
