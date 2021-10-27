//
//  Chart.swift
//  Luna
//
//  Created by Admin on 21/09/21.
//

import Foundation
import Charts

final class OverrideFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return CGFloat(dataSet.entryForIndex(0)!.y)
        //return 375
    }
}

final class basalFillFormatter: IFillFormatter {
    func getFillLinePosition(dataSet: ILineChartDataSet, dataProvider: LineChartDataProvider) -> CGFloat {
        return 0
    }
}

final class ChartXValueFormatter: IAxisValueFormatter {
    

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
       
        //let timezoneOffset = TimeZone.current.secondsFromGMT()
        //let epochTimezoneOffset = value + Double(timezoneOffset)
//        if dateTimeUtils.is24Hour() {
//            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
//        } else {
//            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm")
//        }
        if let lastCGMValue = SystemInfoModel.shared.cgmData?.last{
//            print(value)
//            let currentCgmValue = value.rounded(.towardZero)
//            print(currentCgmValue)
            if lastCGMValue.date - value <= 300 {
//                print("lastCGMValue \(lastCGMValue.date)")
//                let dateFormatter = DateFormatter()
//                dateFormatter.setLocalizedDateFormatFromTemplate(Date.DateFormat.hour12.rawValue)
//                let date = Date(timeIntervalSince1970: value)
//                let formattedDate = dateFormatter.string(from: date)
//                return formattedDate.lowercased()
                return "now"
            }else {
//                print(value)
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate(Date.DateFormat.cgmDate12.rawValue)
                let date = Date(timeIntervalSince1970: value)
                let formattedDate = dateFormatter.string(from: date)
                return formattedDate.lowercased()
            }
        }
        //let date = Date(timeIntervalSince1970: epochTimezoneOffset)
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: value)
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate.lowercased()
    }
}

final class ChartYDataValueFormatter: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if entry.data != nil {
            return entry.data as? String ?? ""
        } else {
            return ""
        }
    }
}

final class ChartYOverrideValueFormatter: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        if entry.data != nil {
            return entry.data as? String ?? ""
        } else {
            return ""
        }
    }
}

final class ChartYMMOLValueFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return bgUnits.toDisplayUnits(String(value))
    }
}
