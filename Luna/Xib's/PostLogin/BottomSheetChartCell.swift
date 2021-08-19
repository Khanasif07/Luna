//
//  BottomSheetChartCell.swift
//  Luna
//
//  Created by Admin on 09/07/21.
//

import UIKit
//import SwiftChart
import Charts
import Foundation

class BottomSheetChartCell: UITableViewCell,ChartViewDelegate {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var chartView: LineChartView!
    //    @IBOutlet weak var chartView: Chart!
    
    // MARK: - Variables
    //===========================
    var cgmData : [ShareGlucoseData] = []{
        didSet{
            let values = cgmData.map { (data) -> ChartDataEntry in
                return ChartDataEntry(x: Double(data.date), y: Double(data.sgv), icon: #imageLiteral(resourceName: "reservoir7Bars"))
            }
            let set1 = LineChartDataSet(entries: values, label: "")
            set1.drawIconsEnabled = false
            setup(set1)
            let gradientColors = [#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 0).cgColor,#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1).cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            set1.fillAlpha = 1
            set1.mode = .linear
            set1.fill = Fill(linearGradient: gradient, angle: 90.0)
            set1.drawFilledEnabled = true
            let data = LineChartData(dataSet: set1)
            chartView.maxVisibleCount = Int(10.0)
            chartView.data = data
        }
    }
//    var xRangeValue = [Double]()
//    var data : [(x: Int, y: Double)] = [] {
//        didSet{
//            let series = ChartSeries(data: data)
//            self.xRangeValue = data.map({ (tuple) -> Double in
//               return Double(tuple.x)
//            })
//            series.area = true
////            chartView.xLabels = [20,40,60,80,100,120,140,160,180,200,220,240]
//            series.color = #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1)
//            chartView.removeAllSeries()
//            chartView.add(series)
//            chartView.reloadInputViews()
//        }
//    }
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
//        setUpChartData()
        newChartSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func newChartSetUp(){
        chartView.delegate = self

        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = #colorLiteral(red: 0.4509803922, green: 0.462745098, blue: 0.4862745098, alpha: 1)
        xAxis.labelFont = AppFonts.SF_Pro_Display_Regular.withSize(.x12)
        xAxis.granularity = 1
       // xAxis.labelCount = 8
        xAxis.valueFormatter = XAxisNameFormater()

        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelTextColor = #colorLiteral(red: 0.4509803922, green: 0.462745098, blue: 0.4862745098, alpha: 1)
        leftAxis.labelFont = AppFonts.SF_Pro_Display_Regular.withSize(.x12)
        leftAxis.axisMaximum = 300
        leftAxis.granularity = 0.0
        leftAxis.drawAxisLineEnabled = false
        leftAxis.axisMinimum = -0
        leftAxis.drawLimitLinesBehindDataEnabled = false

        chartView.rightAxis.enabled = false
        chartView.xAxis.granularity = 0.0
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.legend.form = .none
        setDataCount(cgmData.endIndex, range: UInt32(cgmData.endIndex))
        chartView.moveViewToX(chartView.data?.yMax ?? 0.0 - 1)
        chartView.zoom(scaleX: 10.0, scaleY: 0, x: 0, y: 0)
        chartView.animate(yAxisDuration: 2.5)
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let values = cgmData.map { (data) -> ChartDataEntry in
            return ChartDataEntry(x: Double(data.date), y: Double(data.sgv), icon: #imageLiteral(resourceName: "reservoir7Bars"))
        }

        let set1 = LineChartDataSet(entries: values, label: "")
        set1.drawIconsEnabled = false
        setup(set1)

        let gradientColors = [#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 0).cgColor,#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        set1.fillAlpha = 1.0
        set1.fill = Fill(linearGradient: gradient!, angle: 90.0)
        set1.drawFilledEnabled = true
        set1.drawValuesEnabled = true

        let data = LineChartData(dataSet: set1)
        chartView.maxVisibleCount = Int(10.0)
        chartView.data = data
    }

    private func setup(_ dataSet: LineChartDataSet) {
            dataSet.setColor(#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
            dataSet.setCircleColor(.clear)
            dataSet.lineWidth = 3
            dataSet.circleRadius = 0
            dataSet.drawCircleHoleEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
    }

    
//    public  func setUpChartData(){
//        let series = ChartSeries(data: data)
//        series.area = true
//        series.color = #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1)
//        chartView.lineWidth = 3.0
//        chartView.xLabelsOrientation = .horizontal
////        chartView.xLabels =  xRangeValue
//        chartView.yLabels = [0, 50, 100, 150, 200, 250]
//        //
//        chartView.showYLabelsAndGrid = true
//        chartView.showXLabelsAndGrid = true
//        chartView.axesColor = .clear
//       //
////        chartView.xLabelsFormatter = { String(Int(roundf(Float($1)))) + " am" }
//        chartView.yLabelsFormatter = { String(Int(roundf(Float($1)))) + "" }
//        chartView.add(series)
//        chartView.reloadInputViews()
//    }
    
    // MARK: - IBActions
    //===========================
    
    
}
