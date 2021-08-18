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
//            let values = cgmData.map { (data) -> ChartDataEntry in
//                return ChartDataEntry(x: Double(data.date), y: Double(data.sgv), icon: #imageLiteral(resourceName: "reservoir7Bars"))
//            }
            let values = (0..<cgmData.endIndex).map { (i) -> ChartDataEntry in
                return ChartDataEntry(x: Double(i), y: Double(cgmData[i].sgv), icon: #imageLiteral(resourceName: "reservoir7Bars"))
            }

            let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
            set1.drawIconsEnabled = false
            setup(set1)

//            let value = ChartDataEntry(x: Double(0), y: 0)
//            set1.addEntryOrdered(value)
            let gradientColors = [#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 0).cgColor,#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1).cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
            set1.fillAlpha = 1
    //        set1.fill = LinearGradientFill.init(gradient: gradient,angle: 90.0)
            set1.drawFilledEnabled = true

            let data = LineChartData(dataSet: set1)
            chartView.maxVisibleCount = Int(10.0)
            chartView.data = data
//            let values = (0..<count).map { (i) -> ChartDataEntry in
//                let val = Double(arc4random_uniform(range) + 0)
//                return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "reservoir7Bars"))
//            }
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
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 7
        xAxis.valueFormatter = DefaultAxisValueFormatter()
//        xAxis.valueFormatter = DayAxisValueFormatter(chart: chartView)

        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMaximum = 302
        leftAxis.axisMinimum = -0
        leftAxis.drawLimitLinesBehindDataEnabled = false

        chartView.rightAxis.enabled = false
        chartView.xAxis.granularity = 1.0
        chartView.legend.form = .line
       // slidersValueChanged(nil)
        setDataCount(cgmData.endIndex, range: UInt32(cgmData.endIndex))
        chartView.moveViewToX(chartView.data?.yMax ?? 0.0 - 1)
        chartView.zoom(scaleX: 5, scaleY: 0, x: 0, y: 0)
        chartView.animate(xAxisDuration: 2.5)
    }
    
//    override func updateChartData() {
//        if self.shouldHideData {
//            chartView.data = nil
//            return
//        }
//
//        self.setDataCount(Int(45), range: UInt32(100))
//    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 0)
            return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "reservoir7Bars"))
        }

        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
        set1.drawIconsEnabled = false
        setup(set1)

//        let value = ChartDataEntry(x: Double(3), y: 3)
//        set1.addEntryOrdered(value)
        let gradientColors = [#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 0).cgColor,#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1).cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        set1.fillAlpha = 1
//        set1.fill = fillColor
//        set1.fill = LinearGradientFill(gradient: gradient!,angle: 90.0)
        set1.drawFilledEnabled = true

        let data = LineChartData(dataSet: set1)
        chartView.maxVisibleCount = Int(10.0)
        chartView.data = data
//        chartView.scaleX = 100.0
//        chartView.moveViewToX(90.0)
    }

    private func setup(_ dataSet: LineChartDataSet) {
//        if dataSet.isDrawLineWithGradientEnabled {
//            dataSet.lineDashLengths = nil
//            dataSet.highlightLineDashLengths = nil
//            dataSet.setColors(.black, .red, .white)
//            dataSet.setCircleColor(.black)
//            dataSet.gradientPositions = [0, 40, 100]
//            dataSet.lineWidth = 1
//            dataSet.circleRadius = 3
//            dataSet.drawCircleHoleEnabled = false
//            dataSet.valueFont = .systemFont(ofSize: 9)
//            dataSet.formLineDashLengths = nil
//            dataSet.formLineWidth = 1
//            dataSet.formSize = 15
//        } else {
//            dataSet.lineDashLengths = [5, 2.5]
//            dataSet.highlightLineDashLengths = [5, 2.5]
            dataSet.setColor(#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
            dataSet.setCircleColor(.clear)
//            dataSet.gradientPositions = nil
            dataSet.lineWidth = 3
            dataSet.circleRadius = 0
            dataSet.drawCircleHoleEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
//            dataSet.formLineDashLengths = [5, 2.5]
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
//        }
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
