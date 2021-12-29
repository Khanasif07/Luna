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
    
    var xAxisLabelsArray :[String] = []
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
       
        //let timezoneOffset = TimeZone.current.secondsFromGMT()
        //let epochTimezoneOffset = value + Double(timezoneOffset)
//        if dateTimeUtils.is24Hour() {
//            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
//        } else {
//            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm")
//        }
       
        if let lastCGMValue = SystemInfoModel.shared.cgmData?.last{
            if lastCGMValue.date - value <= 300 {
                let dateFormatter = DateFormatter()
                dateFormatter.setLocalizedDateFormatFromTemplate(Date.DateFormat.cgmDate12.rawValue)
                let date = Date(timeIntervalSince1970: value)
                let formattedDate = dateFormatter.string(from: date)
                xAxisLabelsArray.append(formattedDate.lowercased())
                if xAxisLabelsArray.count == 7 {
                    let hasDuplicates = xAxisLabelsArray.count != Set(xAxisLabelsArray).count
                    if (xAxisLabelsArray[5] ==  xAxisLabelsArray[4]) && hasDuplicates{
                        NotificationCenter.default.post(name: Notification.Name.XAxisLabelsDuplicateValue, object: [:])
                    }
                }
                xAxisLabelsArray = []
                return "now"
            }else {
                let dateFormatter = DateFormatter()
                if SystemInfoModel.shared.cgmData?.endIndex ?? 67 >= 67{
                dateFormatter.setLocalizedDateFormatFromTemplate(Date.DateFormat.hour12.rawValue)
                }else{
                    dateFormatter.setLocalizedDateFormatFromTemplate(Date.DateFormat.hour12.rawValue)
                }
                let date = Date(timeIntervalSince1970: value)
                let formattedDate = dateFormatter.string(from: date)
                xAxisLabelsArray.append(formattedDate.lowercased())
                return formattedDate.lowercased()
            }
        }
        //let date = Date(timeIntervalSince1970: epochTimezoneOffset)
        let dateFormatter = DateFormatter()
        if SystemInfoModel.shared.cgmData?.endIndex ?? 67 >= 67{
        dateFormatter.setLocalizedDateFormatFromTemplate(Date.DateFormat.cgmDate12.rawValue)
        }else{
            dateFormatter.setLocalizedDateFormatFromTemplate(Date.DateFormat.hour12.rawValue)
        }
        let date = Date(timeIntervalSince1970: value)
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate.lowercased()
    }
}

final class ChartXValueFormatterSessionInfo: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
//        if SystemInfoModel.shared.cgmData?.endIndex ?? 67 >= 67{
//            dateFormatter.setLocalizedDateFormatFromTemplate(Date.DateFormat.cgmDate12.rawValue)
//        }else{
        dateFormatter.setLocalizedDateFormatFromTemplate(Date.DateFormat.hour12.rawValue)
//        }
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
