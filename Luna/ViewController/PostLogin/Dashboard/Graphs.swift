//
//  Graphs.swift
//  Luna
//
//  Created by Admin on 21/09/21.
//

import Foundation
import UIKit
import Charts

let ScaleXMax:Float = 150.0
extension BottomSheetVC :  ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if chartView != cgmChartView {
            cgmChartView.moveViewToX(entry.x)
        }
        if entry.data as? String == "hide"{
            chartView.highlightValue(nil, callDelegate: false)
        }
        
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
//        print("Chart Scaled: \(cgmChartView.scaleX), \(cgmChartView.scaleY)")
        
        // dont store huge values
        var scale: Float = Float(cgmChartView.scaleX)
        if(scale > ScaleXMax ) {
            scale = ScaleXMax
        }
        //MARK:- IMPORTANT
//        UserDefaultsRepository.chartScaleX.value = Float(scale)
    }
    
    func updateBGCheckGraph() {
        var dataIndex = 7
        cgmChartView.lineData?.dataSets[dataIndex].clear()
        
        for i in 0..<bgCheckData.count{
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            formatter.minimumIntegerDigits = 1
            
            // skip if > 24 hours old
            if bgCheckData[i].date < dateTimeUtils.getTimeInterval24HoursAgo() { continue }
            
            let value = ChartDataEntry(x: Double(bgCheckData[i].date), y: Double(bgCheckData[i].sgv), data: formatPillText(line1: bgUnits.toDisplayUnits(String(bgCheckData[i].sgv)), time: bgCheckData[i].date))
            cgmChartView.data?.dataSets[dataIndex].addEntry(value)

        }
        
        cgmChartView.data?.dataSets[dataIndex].notifyDataSetChanged()
        cgmChartView.data?.notifyDataChanged()
        cgmChartView.notifyDataSetChanged()
    }
    
    func createGraph(){
        self.cgmChartView.clear()
        
        // Create the BG Graph Data
        _ = bgData
        let bgChartEntry = [ChartDataEntry]()
        _ = [NSUIColor]()
        let maxBG: Float = UserDefaultsRepository.minBGScale.value
        
        // Setup BG line details
        let lineBG = LineChartDataSet(entries:bgChartEntry, label: "")
//        lineBG.circleRadius = CGFloat(globalVariables.dotBG)
        lineBG.circleColors = [NSUIColor.systemGreen]
        lineBG.drawCircleHoleEnabled = false
        lineBG.axisDependency = YAxis.AxisDependency.right
        lineBG.highlightEnabled = true
        lineBG.drawValuesEnabled = false
        //MARK: - Important
        lineBG.setCircleColor(.clear)
        lineBG.lineWidth = 3
        lineBG.circleRadius = 0
        lineBG.drawCircleHoleEnabled = false
        lineBG.valueFont = .systemFont(ofSize: 9)
        lineBG.formLineWidth = 1
        lineBG.formSize = 15
        lineBG.setDrawHighlightIndicators(false)
//        lineBG.valueFont.withSize(50)
        // Setup the chart data of all lines
        let data = LineChartData()
        data.addDataSet(lineBG) // Dataset 0
      //MARK: - Important
                let gradientColors = [#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 0).cgColor,#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1).cgColor]
                let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        lineBG.fillAlpha = 1.0
        lineBG.fill = Fill(linearGradient: gradient!, angle: 90.0)
        lineBG.drawFilledEnabled = true
        lineBG.drawValuesEnabled = false
        //
        data.setValueFont(UIFont.systemFont(ofSize: 12))

        let marker = BalloonMarker(color: #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1),
                                   font: .boldSystemFont(ofSize: 15.0),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 3.5, left: 5.5, bottom: 16, right: 5.5))
        marker.chartView = cgmChartView
        marker.minimumSize = CGSize(width: 50.0, height: 30.0)
        cgmChartView.marker = marker
        // Clear limit lines so they don't add multiples when changing the settings
        cgmChartView.rightAxis.removeAllLimitLines()
        cgmChartView.leftAxis.removeAllLimitLines()
        //Add lower red line based on low alert value
        let ll = ChartLimitLine()
        ll.limit = Double(UserDefaultsRepository.lowLine.value)
        ll.lineColor = NSUIColor.systemRed.withAlphaComponent(0.5)
        cgmChartView.rightAxis.addLimitLine(ll)
        
        //Add upper yellow line based on low alert value
        let ul = ChartLimitLine()
        ul.limit = Double(UserDefaultsRepository.highLine.value)
        ul.lineColor = NSUIColor.systemYellow.withAlphaComponent(0.5)
        cgmChartView.rightAxis.addLimitLine(ul)
        
        // Add Now Line
        //        startGraphNowTimer()
        
        // Setup the main graph overall details
        cgmChartView.xAxis.valueFormatter = ChartXValueFormatter()
        cgmChartView.xAxis.granularity = 1800
        cgmChartView.xAxis.labelTextColor = NSUIColor.label
        cgmChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        cgmChartView.leftAxis.enabled = true
        cgmChartView.leftAxis.labelPosition = YAxis.LabelPosition.outsideChart
        cgmChartView.leftAxis.axisMinimum = 0
        //MARK: - Important
        cgmChartView.leftAxis.drawGridLinesEnabled = true
        cgmChartView.leftAxis.granularityEnabled = true
        cgmChartView.leftAxis.granularity = 1
        
        cgmChartView.rightAxis.labelTextColor = NSUIColor.label
        cgmChartView.rightAxis.labelPosition = YAxis.LabelPosition.outsideChart
        cgmChartView.rightAxis.axisMinimum = 0.0
        cgmChartView.rightAxis.axisMaximum = Double(maxBG)
        cgmChartView.rightAxis.gridLineDashLengths = [5.0, 5.0]
        cgmChartView.rightAxis.drawGridLinesEnabled = false
        cgmChartView.rightAxis.valueFormatter = ChartYMMOLValueFormatter()
        cgmChartView.rightAxis.granularityEnabled = true
        cgmChartView.rightAxis.granularity = 50
        
        cgmChartView.maxHighlightDistance = 15.0
        cgmChartView.legend.enabled = false
        cgmChartView.scaleYEnabled = false
        cgmChartView.drawGridBackgroundEnabled = true
        cgmChartView.gridBackgroundColor = NSUIColor.clear
        
        cgmChartView.highlightValue(nil, callDelegate: false)
        
        cgmChartView.data = data
        cgmChartView.setExtraOffsets(left: 10, top: 0, right: 10, bottom: 0)
        
    }

    func updateBGGraph() {
        let dataIndex = 0
        let entries = bgData
        if entries.count < 1 { return }
        var mainChart = cgmChartView.lineData!.dataSets[dataIndex] as! LineChartDataSet
        mainChart.clear()
        var maxBGOffset: Float = 50
        
        var colors = [NSUIColor]()
        for i in 0..<entries.count{
            if Float(entries[i].sgv) > topBG - maxBGOffset {
                topBG = Float(entries[i].sgv) + maxBGOffset
            }
            let value = ChartDataEntry(x: Double(entries[i].date), y: Double(entries[i].sgv), data: formatPillText(line1: bgUnits.toDisplayUnits(String(entries[i].sgv)), time: entries[i].date))
            if UserDefaultsRepository.debugLog.value {
                //writeDebugLog(value: "BG: " + value.description)
                
            }
            mainChart.addEntry(value)
            
            if Double(entries[i].sgv) >= Double(UserDefaultsRepository.highLine.value) {
                colors.append(NSUIColor.systemYellow)
            } else if Double(entries[i].sgv) <= Double(UserDefaultsRepository.lowLine.value) {
                colors.append(NSUIColor.systemRed)
            } else {
                colors.append(NSUIColor.systemGreen)
            }
        }
        // Set Colors
        let lineBG = cgmChartView.lineData!.dataSets[dataIndex] as! LineChartDataSet
        lineBG.colors.removeAll()
        lineBG.circleColors.removeAll()
        
        if colors.count > 0 {
            for i in 0..<colors.count{
                mainChart.addColor(colors[i])
                mainChart.circleColors.append(colors[i])
            }
        }
        
        if UserDefaultsRepository.debugLog.value {
            print("Total Colors: " + mainChart.colors.count.description)
            
        }
        
        cgmChartView.rightAxis.axisMaximum = Double(topBG)
        cgmChartView.setVisibleXRangeMinimum(600)
        cgmChartView.data?.dataSets[dataIndex].notifyDataSetChanged()
        cgmChartView.data?.notifyDataChanged()
        cgmChartView.notifyDataSetChanged()
        
        if firstGraphLoad {
            var scaleX = CGFloat(UserDefaultsRepository.chartScaleX.value)
            print("Scale: \(scaleX)")
            if( scaleX > CGFloat(ScaleXMax) ) {
                scaleX = CGFloat(ScaleXMax)
                UserDefaultsRepository.chartScaleX.value = ScaleXMax
            }
            cgmChartView.zoom(scaleX: scaleX, scaleY: 1, x: 1, y: 1)
            firstGraphLoad = false
        }
        
        // Move to current reading everytime new readings load
        cgmChartView.moveViewToAnimated(xValue: dateTimeUtils.getNowTimeIntervalUTC() - (cgmChartView.visibleXRange * 0.7), yValue: 0.0, axis: .right, duration: 1, easingOption: .easeInBack)
    }
    
    func formatPillText(line1: String, time: TimeInterval) -> String {
        let dateFormatter = DateFormatter()
        //let timezoneOffset = TimeZone.current.secondsFromGMT()
        //let epochTimezoneOffset = value + Double(timezoneOffset)
        if dateTimeUtils.is24Hour() {
            dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm")
        } else {
            dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm")
        }
        
        //let date = Date(timeIntervalSince1970: epochTimezoneOffset)
        let date = Date(timeIntervalSince1970: time)
        let formattedDate = dateFormatter.string(from: date)
        
        return line1 + "\r\n" + formattedDate
    }
    
    public func newChartSetUp(){
        cgmChartView.delegate = self
        cgmChartView.chartDescription?.enabled = true
        //MARK: - Important
//        cgmChartView.dragEnabled = true
//        cgmChartView.setScaleEnabled(false)
//        cgmChartView.pinchZoomEnabled = false
        
        let xAxis = cgmChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = #colorLiteral(red: 0.4509803922, green: 0.462745098, blue: 0.4862745098, alpha: 1)
        xAxis.labelFont = AppFonts.SF_Pro_Display_Regular.withSize(.x12)
        xAxis.labelCount = 7
        
        let leftAxis = cgmChartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelTextColor = #colorLiteral(red: 0.4509803922, green: 0.462745098, blue: 0.4862745098, alpha: 1)
        leftAxis.labelFont = AppFonts.SF_Pro_Display_Regular.withSize(.x12)
        leftAxis.axisMaximum = 300
        leftAxis.granularity = 1.0
        //MARK: - Important
        leftAxis.drawAxisLineEnabled = false
        leftAxis.axisMinimum = -0
        leftAxis.drawLimitLinesBehindDataEnabled = false
        cgmChartView.rightAxis.enabled = false
        cgmChartView.xAxis.granularity = 1800
        cgmChartView.xAxis.drawGridLinesEnabled = false
        cgmChartView.legend.form = .none
        cgmChartView.noDataText = "No glucose data available."
        cgmChartView.noDataTextColor = #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1)
        cgmChartView.noDataFont = AppFonts.SF_Pro_Display_Bold.withSize(.x15)
        cgmChartView.clear()
    }
}