//
//  CustomPickerView.swift
//  Luna
//
//  Created by Admin on 25/06/21.
//

import UIKit

protocol WCCustomPickerViewDelegate : class{
    
    func userDidSelectRow(_ text : String)
}

class WCCustomPickerView: UIView {
    
    lazy var dataArray = [String]()
    var indexPath : IndexPath!
    weak var delegate : WCCustomPickerViewDelegate?
    
    init() {
        
        super.init(frame: UIScreen.main.bounds)
        
        self.backgroundColor = UIColor.white
        
        self.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 4)
        
        createPicker()
        
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createPicker(){
        
        let picker = UIPickerView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 4))
        
        self.addSubview(picker)
        
        picker.delegate = self
        picker.dataSource = self
    }
    
    func getPicker() -> UIPickerView?{
        
        for view in self.subviews{
            
            if (view is UIPickerView){
                
                return view as? UIPickerView
            }
        }
        
        return nil
    }
    
    
    func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        if let picker = getPicker() {
            picker.selectRow(row, inComponent: component, animated: animated)
        }
    }
}

extension WCCustomPickerView : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        delegate?.userDidSelectRow(dataArray[row])
    }
}


class CustomDatePicker: UIView {
    
    var pickerMode: UIDatePicker.Mode = .date {
        didSet {
            datePicker.datePickerMode = self.pickerMode
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }

        }
    }
    
    var datePicker = UIDatePicker()

    init() {
        
        super.init(frame: UIScreen.main.bounds)
        
        self.backgroundColor = UIColor.white
        
        self.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 200.0)
        
        createDatePicker()
        
        return
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createDatePicker(){
        
        if hasTopNotch{
            datePicker = UIDatePicker(frame: CGRect(x: 30.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 200.0))
        }else{
            datePicker = UIDatePicker(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 200.0))
        }
        self.addSubview(datePicker)
        //datePicker.datePickerMode = pickerMode
//        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: +2, to: Date())
        
    }
    
    func setDatePickerDate(_ date : Date?){
        
        guard let tempDate = date else {return}
        
        let dateFormatterPrint = DateFormatter()
        
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        for view in self.subviews{
            
            if view is UIDatePicker{
                
                (view as! UIDatePicker).setDate(tempDate, animated: true)
                
                break
            }
        }
    }
    
    func selectedDate() -> Date?{
        
        for view in self.subviews{
            
            if view is UIDatePicker{
                
                return (view as! UIDatePicker).date
            }
        }
        return nil
    }
    
    func selectedTime() -> TimeZone?{
        
        for view in self.subviews{
            
            if view is UIDatePicker{
                
                return (view as! UIDatePicker).timeZone
            }
        }
        return nil
    }
}

