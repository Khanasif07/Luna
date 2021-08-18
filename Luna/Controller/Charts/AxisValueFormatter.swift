//
//  AxisValueFormatter.swift
//  Luna
//
//  Created by Admin on 18/08/21.
//

import Charts

final class XAxisNameFormater: NSObject, IAxisValueFormatter {
    
    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {

//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "dd.MM"

        return value.getDateTimeFromTimeInterval()
    }

}
