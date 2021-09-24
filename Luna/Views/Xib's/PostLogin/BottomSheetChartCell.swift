//
//  BottomSheetChartCell.swift
//  Luna
//
//  Created by Admin on 09/07/21.
//
import Foundation
import UIKit
import Charts
import UserNotifications

class BottomSheetChartCell: UITableViewCell,ChartViewDelegate {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var cgmChartView: LineChartView!
    
    // MARK: - Variables
    //===========================
//    var cgmData : [ShareGlucoseData] = SystemInfoModel.shared.cgmData ?? []{
//        didSet{
//            self.cgmData = self.cgmData.reversed()
//            setDataCount(cgmData.endIndex, range: UInt32(cgmData.endIndex))
//            let customXAxisRender = XAxisCustomRenderer(viewPortHandler: self.cgmChartView.viewPortHandler,
//                                                        xAxis: cgmChartView.xAxis,
//                                                        transformer: self.cgmChartView.getTransformer(forAxis: .left),
//                                                        cgmData: self.cgmData)
//            self.cgmChartView.xAxisRenderer = customXAxisRender
//        }
//    }
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
//        newChartSetUp()
    }
    
//    private func newChartSetUp(){
//        cgmChartView.delegate = self
//
//        cgmChartView.chartDescription?.enabled = true
//        cgmChartView.dragEnabled = true
//        cgmChartView.setScaleEnabled(false)
//        cgmChartView.pinchZoomEnabled = false
//
//        let xAxis = cgmChartView.xAxis
//        xAxis.labelPosition = .bottom
//        xAxis.labelTextColor = #colorLiteral(red: 0.4509803922, green: 0.462745098, blue: 0.4862745098, alpha: 1)
//        xAxis.labelFont = AppFonts.SF_Pro_Display_Regular.withSize(.x12)
//        xAxis.granularity = 1
//        xAxis.labelCount = 7
//        xAxis.valueFormatter = XAxisNameFormater()
//
//        let leftAxis = cgmChartView.leftAxis
//        leftAxis.removeAllLimitLines()
//        leftAxis.labelTextColor = #colorLiteral(red: 0.4509803922, green: 0.462745098, blue: 0.4862745098, alpha: 1)
//        leftAxis.labelFont = AppFonts.SF_Pro_Display_Regular.withSize(.x12)
//        leftAxis.axisMaximum = 300
//        leftAxis.granularity = 0.0
//        leftAxis.drawAxisLineEnabled = false
//        leftAxis.axisMinimum = -0
//        leftAxis.drawLimitLinesBehindDataEnabled = false
//
//        let marker = BalloonMarker(color: #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1),
//                                   font: .boldSystemFont(ofSize: 15.0),
//                                   textColor: .white,
//                                   insets: UIEdgeInsets(top: 3.5, left: 5.5, bottom: 16, right: 5.5))
//        marker.chartView = cgmChartView
//        marker.minimumSize = CGSize(width: 50.0, height: 30.0)
//        cgmChartView.marker = marker
//
//        cgmChartView.rightAxis.enabled = false
//        cgmChartView.xAxis.granularity = 0.0
//        cgmChartView.xAxis.drawGridLinesEnabled = false
//        cgmChartView.legend.form = .none
//        setDataCount(cgmData.endIndex, range: UInt32(cgmData.endIndex))
//        cgmChartView.moveViewToX(cgmChartView.data?.yMax ?? 0.0 - 1)
//        cgmChartView.zoom(scaleX: 3.5, scaleY: 0, x: 0, y: 0)
//        cgmChartView.animate(yAxisDuration: 2.5)
//        cgmChartView.noDataText = "No glucose data available."
//        cgmChartView.noDataTextColor = #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1)
//        cgmChartView.noDataFont = AppFonts.SF_Pro_Display_Bold.withSize(.x15)
//        cgmChartView.clear()
//    }
    
//    func setDataCount(_ count: Int, range: UInt32) {
////        let values = cgmData.map { (data) -> ChartDataEntry in
////            return ChartDataEntry(x: Double(data.date), y: Double(data.sgv), icon: #imageLiteral(resourceName: "reservoir7Bars"))
////        }
//        var values = [ChartDataEntry]()
//        for (index, data) in cgmData.enumerated() {
//            let value = BarChartDataEntry(x: Double(index), y: Double(data.sgv), icon: #imageLiteral(resourceName: "reservoir7Bars"))
//            values.append(value)
//        }
//        let set1 = LineChartDataSet(entries: values, label: "")
//        set1.drawIconsEnabled = false
//        setup(set1)
//
//        let gradientColors = [#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 0).cgColor,#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1).cgColor]
//        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
//        set1.fillAlpha = 1.0
//        set1.fill = Fill(linearGradient: gradient!, angle: 90.0)
//        set1.drawFilledEnabled = true
//        set1.drawValuesEnabled = true
//
//        let data = LineChartData(dataSet: set1)
//        cgmChartView.maxVisibleCount = 10
//        cgmChartView.data = data
//    }

//    private func setup(_ dataSet: LineChartDataSet) {
//            dataSet.setColor(#colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1))
//            dataSet.setCircleColor(.clear)
//            dataSet.lineWidth = 3
//            dataSet.circleRadius = 0
//            dataSet.drawCircleHoleEnabled = false
//            dataSet.valueFont = .systemFont(ofSize: 9)
//            dataSet.formLineWidth = 1
//            dataSet.formSize = 15
//    }
    
    // MARK: - IBActions
    //===========================
    
    
}

//public class XAxisCustomRenderer: XAxisRenderer {
//
//    var cgmData : [ShareGlucoseData] = []
//
//    init(viewPortHandler: ViewPortHandler, xAxis: XAxis, transformer: Transformer, cgmData: [ShareGlucoseData]) {
//        self.cgmData = cgmData
//        super.init(viewPortHandler: viewPortHandler, xAxis: xAxis, transformer: transformer)
//    }
//
//    override public func drawLabels(context: CGContext, pos: CGFloat, anchor: CGPoint){
//        guard
//            let xAxis = self.axis as? XAxis,
//            let transformer = self.transformer
//        else { return }
//
//        #if os(OSX)
//        let paraStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
//        #else
//        let paraStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
//        #endif
//        paraStyle.alignment = .center
//
//        let labelAttrs: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: xAxis.labelFont,
//                                                          NSAttributedString.Key.foregroundColor: xAxis.labelTextColor,
//                                                          NSAttributedString.Key.paragraphStyle: paraStyle]
//        let FDEG2RAD = CGFloat(Double.pi / 180.0)
//
//        let labelRotationAngleRadians = xAxis.labelRotationAngle * FDEG2RAD
//
//        let centeringEnabled = xAxis.isCenterAxisLabelsEnabled
//
//        let valueToPixelMatrix = transformer.valueToPixelMatrix
//
//        var position = CGPoint(x: 0.0, y: 0.0)
//
//        var labelMaxSize = CGSize()
//
//        if xAxis.isWordWrapEnabled{
//            labelMaxSize.width = xAxis.wordWrapWidthPercent * valueToPixelMatrix.a
//        }
//
//        let entries = xAxis.entries
//
//        for i in stride(from: 0, to: entries.count, by: 1){
//            if centeringEnabled{
//                position.x = CGFloat(xAxis.centeredEntries[i])
//            }
//            else{
//                position.x = CGFloat(entries[i])
//            }
//
//            position.y = 0.0
//            position = position.applying(valueToPixelMatrix)
//
//            if viewPortHandler.isInBoundsX(position.x){
//                let label = xAxis.valueFormatter?.stringForValue(xAxis.entries[i], axis: xAxis) ?? ""
//
//                let labelns = label as NSString
//
//                if xAxis.isAvoidFirstLastClippingEnabled{
//                    // avoid clipping of the last
//                    if i == xAxis.entryCount - 1 && xAxis.entryCount > 1{
//                        let width = labelns.boundingRect(with: labelMaxSize,
//                                                         options: .usesLineFragmentOrigin,
//                                                         attributes: labelAttrs, context: nil).size.width
//
//                        if width > (viewPortHandler.offsetRight) * 2.0
//                            && position.x + width > viewPortHandler.chartWidth
//                        {
//                            position.x -= width / 2.0
//                        }
//                    }
//                    else if i == 0{ // avoid clipping of the first
//                        let width = labelns.boundingRect(with: labelMaxSize,
//                                                         options: .usesLineFragmentOrigin,
//                                                         attributes: labelAttrs, context: nil).size.width
//                        position.x += width / 2.0
//                    }
//                }
//                //Draw the time labels
//                drawLabel(
//                    context: context,
//                    formattedLabel: label,
//                    x: position.x,
//                    y: position.y,
//                    attributes: labelAttrs,
//                    constrainedToSize: labelMaxSize,
//                    anchor: anchor,
//                    angleRadians: labelRotationAngleRadians)
//
////                let indexData = cgmData[Int(i)]
////                let cgmDate = String(indexData.date)
////                var icon: CGImage?
////                SystemInfoModel.shared.insulinData?.forEach({ (model) in
////                    let labelData = model.date.getDateTimeFromTimeInterval()
////                    if labelData == label {
////                        let rawIcon = #imageLiteral(resourceName: "lineOne")
////                        icon = rawIcon.cgImage!
////                    }
////                })
////                if let myImage = icon{
////                    context.draw(myImage, in: CGRect(x: position.x - 10 , y: position.y - 30, width: CGFloat(15), height: CGFloat(30)))
////                }
//            }
//        }
//    }
//}

