//
//  AxisValueFormatter.swift
//  Luna
//
//  Created by Admin on 18/08/21.
//
import UIKit
import Foundation
import Charts
import CoreGraphics

final class XAxisNameFormater: NSObject, IAxisValueFormatter {
    
    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {

//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "dd.MM"
        let index = Int(value)
        if let lastIndex = SystemInfoModel.shared.cgmData?.endIndex{
            let value =  SystemInfoModel.shared.cgmData?[(lastIndex - index - 1)].date ?? 0.0
            return value.getDateTimeFromTimeInterval(Date.DateFormat.cgmDate12.rawValue)
        }
        print(value.getDateTimeFromTimeInterval(Date.DateFormat.cgmDate12.rawValue))
        return value.getDateTimeFromTimeInterval(Date.DateFormat.cgmDate12.rawValue)
    }
}

final  class XAxisCustomRenderer: XAxisRenderer {

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

            position.y = -5.0
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
                //MARK:- Used to draw vertical line top and bottom
                context.beginPath()
                context.move(to: CGPoint(x: position.x, y: position.y))
                context.addLine(to: CGPoint(x: position.x, y: self.viewPortHandler.contentBottom))
                context.strokePath()
                

//                let indexData = cgmData[Int(i)]
//                let cgmDate = String(indexData.date)
//                print("\(i)"+" \(cgmDate)")
//                var icon: CGImage?
//                if cgmDate == "1635336580" {
//                    let rawIcon = #imageLiteral(resourceName: "lineOne")
//                    icon = rawIcon.cgImage!
//                }else{
//                    let rawIcon = #imageLiteral(resourceName: "lineTwo")
//                    icon = rawIcon.cgImage!
//                }
//                if let myImage = icon{
//                    context.draw(myImage, in: CGRect(x: position.x - 10 , y: position.y - 30, width: CGFloat(15), height: CGFloat(30)))
//                }
            }
        }
    }
}

//MARK:- Balloon Marker
//=====================
open class BalloonMarker: MarkerImage{
    @objc open var color: UIColor
    @objc open var arrowSize = CGSize(width: 12.5, height: 12.5)
    @objc open var font: UIFont
    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()
    
    fileprivate var label: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()
    
    static let formatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.allowedUnits = [.minute, .second]
        f.unitsStyle = .short
        return f
    }()

    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        //
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        _drawAttributes = [.font: font, .paragraphStyle: paragraphStyle, .foregroundColor: textColor, .baselineOffset: NSNumber(value: 0)]
        //
        super.init()
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = self.offset
        var size = self.size

        if size.width == 0.0 && image != nil
        {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image!.size.height
        }
        

        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0

        var origin = point
        origin.x -= width / 2
        origin.y -= height

        if origin.x + offset.x < 0.0
        {
            offset.x = -origin.x + padding
        }
        else if let chart = chartView,
            origin.x + width + offset.x > chart.bounds.size.width
        {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0
        {
            offset.y = height + padding;
        }
        else if let chart = chartView,
            origin.y + height + offset.y > chart.bounds.size.height
        {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }
    
//    open override func draw(context: CGContext, point: CGPoint)
    open override func draw(context: CGContext, point: CGPoint) {
           guard let label = label else { return }
           
           let offset = self.offsetForDrawing(atPoint: point)
           let size = self.size
           
           var rect = CGRect(
               origin: CGPoint(
                   x: point.x + offset.x,
                   y: point.y + offset.y),
               size: size)
           rect.origin.x -= size.width / 2.0
           rect.origin.y -= size.height
           
           context.saveGState()
           
           context.setFillColor(color.cgColor)
           
           if offset.y > 0 {
               
               context.beginPath()
               let rect2 = CGRect(x: rect.origin.x, y: rect.origin.y + arrowSize.height, width: rect.size.width, height: rect.size.height - arrowSize.height)
               let clipPath = UIBezierPath(roundedRect: rect2, cornerRadius: 5.0).cgPath
               context.addPath(clipPath)
               context.closePath()
               context.fillPath()
               
               // arraow vertex
               context.beginPath()
               let p1 = CGPoint(x: rect.origin.x + rect.size.width / 2.0 - arrowSize.width / 2.0, y: rect.origin.y + arrowSize.height + 1)
               context.move(to: p1)
               context.addLine(to: CGPoint(x: p1.x + arrowSize.width, y: p1.y))
               context.addLine(to: CGPoint(x: point.x, y: point.y))
               context.addLine(to: p1)

               context.fillPath()
               
           } else {
               context.beginPath()
               let rect2 = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height - arrowSize.height)
               let clipPath = UIBezierPath(roundedRect: rect2, cornerRadius: 5.0).cgPath
               context.addPath(clipPath)
               context.closePath()
               context.fillPath()

               // arraow vertex
               context.beginPath()
               let p1 = CGPoint(x: rect.origin.x + rect.size.width / 2.0 - arrowSize.width / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height - 1)
               context.move(to: p1)
               context.addLine(to: CGPoint(x: p1.x + arrowSize.width, y: p1.y))
               context.addLine(to: CGPoint(x: point.x, y: point.y))
               context.addLine(to: p1)

               context.fillPath()
           }
           
           if offset.y > 0 {
               rect.origin.y += self.insets.top + arrowSize.height
           } else {
               rect.origin.y += self.insets.top
           }
           
           rect.size.height -= self.insets.top + self.insets.bottom
           
           UIGraphicsPushContext(context)
           
           label.draw(in: rect, withAttributes: _drawAttributes)
           
           UIGraphicsPopContext()
           
           context.restoreGState()
       }


    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        setLabel(entry.data as? String ?? "")
    }

//    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
//        if entry.data != nil {
//            //var multiplier = entry.data as! Double * 100.0
//            //labelText = String(format: "%.0f%%", multiplier)
//            label = entry.data as? String ?? ""
//        } else {
//            label = String(entry.y)
//        }
//    }
    
    @objc open func setLabel(_ newLabel: String) {
         label = newLabel
        _drawAttributes.removeAll()
        _drawAttributes[.font] = self.font
        _drawAttributes[.paragraphStyle] = _paragraphStyle
        _drawAttributes[.foregroundColor] = self.textColor
        
        _labelSize = label?.size(withAttributes: _drawAttributes) ?? CGSize.zero
        
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
    
    private func customString(_ value: Double) -> String {
        let formattedString = BalloonMarker.formatter.string(from: TimeInterval(value))!
        // using this to convert the left axis values formatting, ie 2 min
        return "\(formattedString)"
    }
}
