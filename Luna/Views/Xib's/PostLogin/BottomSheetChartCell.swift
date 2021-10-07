//
//  BottomSheetChartCell.swift
//  Luna
//
//  Created by Admin on 09/07/21.
//
import Foundation
import UIKit
import Charts

class BottomSheetChartCell: UITableViewCell,ChartViewDelegate {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var cgmChartView: LineChartView!
    
    // MARK: - Variables
    //===========================
    var cgmData : [ShareGlucoseData] = SystemInfoModel.shared.cgmData ?? []{
        didSet{
            setDataCount(cgmData.endIndex, range: UInt32(cgmData.endIndex))
            let customXAxisRender = XAxisCustomRenderer(viewPortHandler: self.cgmChartView.viewPortHandler,
                                                        xAxis: cgmChartView.xAxis,
                                                        transformer: self.cgmChartView.getTransformer(forAxis: .left),
                                                        cgmData: self.cgmData)
            self.cgmChartView.xAxisRenderer = customXAxisRender
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        newChartSetUp()
    }
    
    private func newChartSetUp(){
        cgmChartView.delegate = self

        cgmChartView.chartDescription?.enabled = true
        cgmChartView.dragEnabled = true
        cgmChartView.setScaleEnabled(false)
        cgmChartView.pinchZoomEnabled = false

        let xAxis = cgmChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = #colorLiteral(red: 0.4509803922, green: 0.462745098, blue: 0.4862745098, alpha: 1)
        xAxis.labelFont = AppFonts.SF_Pro_Display_Regular.withSize(.x12)
        xAxis.granularity = 1800
        xAxis.labelTextColor = NSUIColor.label
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        xAxis.valueFormatter = ChartXValueFormatter()

        let leftAxis = cgmChartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.labelTextColor = #colorLiteral(red: 0.4509803922, green: 0.462745098, blue: 0.4862745098, alpha: 1)
        leftAxis.labelFont = AppFonts.SF_Pro_Display_Regular.withSize(.x12)
        leftAxis.axisMaximum = 300
        //MARK: - Important
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        leftAxis.granularity = 1
        leftAxis.drawAxisLineEnabled = false
        leftAxis.axisMinimum = -0
        leftAxis.drawLimitLinesBehindDataEnabled = false

        let marker = BalloonMarker(color: #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1),
                                   font: AppFonts.SF_Pro_Display_Bold.withSize(.x15),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 3.5, left: 5.5, bottom: 16, right: 5.5))
        marker.chartView = cgmChartView
        marker.minimumSize = CGSize(width: 50.0, height: 30.0)
        cgmChartView.marker = marker
        
        cgmChartView.xAxis.centerAxisLabelsEnabled = false
        cgmChartView.xAxis.setLabelCount(7, force: true) //enter the number of labels here

        cgmChartView.rightAxis.enabled = false
        cgmChartView.xAxis.drawGridLinesEnabled = false
        cgmChartView.legend.form = .none
        
        cgmChartView.moveViewToX(cgmChartView.data?.yMax ?? 0.0 - 1)
        cgmChartView.zoom(scaleX: 4.0, scaleY: 0, x: 0, y: 0)
        cgmChartView.animate(yAxisDuration: 2.5)
        cgmChartView.noDataText = "No glucose data available."
        cgmChartView.noDataTextColor = #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1)
        cgmChartView.noDataFont = AppFonts.SF_Pro_Display_Bold.withSize(.x15)
        cgmChartView.setExtraOffsets(left: 10, top: 0, right: 20, bottom: 0)
        
        cgmChartView.rightAxis.labelTextColor = NSUIColor.label
        cgmChartView.rightAxis.labelPosition = YAxis.LabelPosition.outsideChart
        cgmChartView.rightAxis.axisMinimum = 0.0
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
        cgmChartView.clear()
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
        set1.drawValuesEnabled = false

        let data = LineChartData(dataSet: set1)
        cgmChartView.data = data
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
}
