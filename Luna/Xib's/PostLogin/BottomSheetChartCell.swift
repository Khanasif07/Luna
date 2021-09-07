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
            //            let marker = ChartMarker()
            let marker = BalloonMarker(color: #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1),
                                       font: .boldSystemFont(ofSize: 15.0),
                                       textColor: .white,
                                       insets: UIEdgeInsets(top: 3.5, left: 5.5, bottom: 16, right: 5.5))
            marker.chartView = chartView
            marker.minimumSize = CGSize(width: 50.0, height: 30.0)
            chartView.marker = marker
            
            let customXAxisRender = XAxisCustomRenderer(viewPortHandler: self.chartView.viewPortHandler,
                                                        xAxis: chartView.xAxis,
                                                        transformer: self.chartView.getTransformer(forAxis: .left),
                                                        cgmData: self.cgmData)
            self.chartView.xAxisRenderer = customXAxisRender
            chartView.data = data
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        newChartSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func newChartSetUp(){
        chartView.delegate = self

        chartView.chartDescription?.enabled = true
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = #colorLiteral(red: 0.4509803922, green: 0.462745098, blue: 0.4862745098, alpha: 1)
        xAxis.labelFont = AppFonts.SF_Pro_Display_Regular.withSize(.x12)
        xAxis.granularity = 1
        xAxis.labelCount = 8
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
        chartView.zoom(scaleX: 12.5, scaleY: 0, x: 0, y: 0)
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
    
    // MARK: - IBActions
    //===========================
    
    
}

public class XAxisCustomRenderer: XAxisRenderer {
    
    var cgmData : [ShareGlucoseData] = []
    
    init(viewPortHandler: ViewPortHandler, xAxis: XAxis, transformer: Transformer, cgmData: [ShareGlucoseData]) {
        self.cgmData = cgmData
        super.init(viewPortHandler: viewPortHandler, xAxis: xAxis, transformer: transformer)
    }
    
    override public func drawLabels(context: CGContext, pos: CGFloat, anchor: CGPoint){
        guard
            let xAxis = self.axis as? XAxis,
            let transformer = self.transformer
        else { return }
        
        #if os(OSX)
        let paraStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        #else
        let paraStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        #endif
        paraStyle.alignment = .center
        
        let labelAttrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: xAxis.labelFont,
                                                          NSAttributedString.Key.foregroundColor: xAxis.labelTextColor,
                                                          NSAttributedString.Key.paragraphStyle: paraStyle]
        let FDEG2RAD = CGFloat(Double.pi / 180.0)
        
        let labelRotationAngleRadians = xAxis.labelRotationAngle * FDEG2RAD
        
        let centeringEnabled = xAxis.isCenterAxisLabelsEnabled
        
        let valueToPixelMatrix = transformer.valueToPixelMatrix
        
        var position = CGPoint(x: 0.0, y: 0.0)
        
        var labelMaxSize = CGSize()
        
        if xAxis.isWordWrapEnabled{
            labelMaxSize.width = xAxis.wordWrapWidthPercent * valueToPixelMatrix.a
        }
        
        let entries = xAxis.entries
        
        for i in stride(from: 0, to: entries.count, by: 1){
            if centeringEnabled{
                position.x = CGFloat(xAxis.centeredEntries[i])
            }
            else{
                position.x = CGFloat(entries[i])
            }
            
            position.y = 0.0
            position = position.applying(valueToPixelMatrix)
            
            if viewPortHandler.isInBoundsX(position.x){
                let label = xAxis.valueFormatter?.stringForValue(xAxis.entries[i], axis: xAxis) ?? ""
                
                let labelns = label as NSString
                
                if xAxis.isAvoidFirstLastClippingEnabled{
                    // avoid clipping of the last
                    if i == xAxis.entryCount - 1 && xAxis.entryCount > 1{
                        let width = labelns.boundingRect(with: labelMaxSize,
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: labelAttrs, context: nil).size.width
                        
                        if width > (viewPortHandler.offsetRight) * 2.0
                            && position.x + width > viewPortHandler.chartWidth
                        {
                            position.x -= width / 2.0
                        }
                    }
                    else if i == 0{ // avoid clipping of the first
                        let width = labelns.boundingRect(with: labelMaxSize,
                                                         options: .usesLineFragmentOrigin,
                                                         attributes: labelAttrs, context: nil).size.width
                        position.x += width / 2.0
                    }
                }
                
//                let rawIcon: UIImage = #imageLiteral(resourceName: "reservoir7Bars")
//                let icon: CGImage = rawIcon.cgImage!
                
                
                //Draw the time labels
                drawLabel(
                    context: context,
                    formattedLabel: label,
                    x: position.x,
                    y: position.y,
                    attributes: labelAttrs,
                    constrainedToSize: labelMaxSize,
                    anchor: anchor,
                    angleRadians: labelRotationAngleRadians)
                
//                let indexData = cgmData[Int(i)]
//                let cgmDate = String(indexData.date)
                var icon: CGImage?
                SystemInfoModel.shared.insulinData?.forEach({ (model) in
                    let labelData = model.date.getDateTimeFromTimeInterval()
                    if labelData == label {
                        let rawIcon = #imageLiteral(resourceName: "lineOne")
                        icon = rawIcon.cgImage!
                    }
                })
               
             
//                if label == "08 am" || label == "01 pm"{
//                    let rawIcon = #imageLiteral(resourceName: "lineOne")
//                    icon = rawIcon.cgImage!
//                }else if label == "03 pm"{
//                    let rawIcon = #imageLiteral(resourceName: "lineTwo")
//                    icon = rawIcon.cgImage!
//                }else if label == "11 am"{
//                    let rawIcon = #imageLiteral(resourceName: "lineFour")
//                    icon = rawIcon.cgImage!
//                }
                if let myImage = icon{
                    context.draw(myImage, in: CGRect(x: position.x - 10 , y: position.y - 30, width: CGFloat(15), height: CGFloat(30)))
                }
            }
        }
    }
}
