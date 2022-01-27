//
//  CustomLineChartView.swift
//  Luna
//
//  Created by Admin on 13/10/21.
//
import Charts
import Foundation
import CoreGraphics
import UIKit

class TappableLineChartView: LineChartView {

    public override init(frame: CGRect)
    {
        super.init(frame: frame)
        addTapRecognizer()
    }

    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        addTapRecognizer()
    }

    func addTapRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(chartTapped))
//        tapRecognizer.minimumPressDuration = 0.1
        self.addGestureRecognizer(tapRecognizer)
    }

    @objc func chartTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            // show
            let position = sender.location(in: self)
            let highlight = self.getHighlightByTouchPoint(position)
            _ = self.getDataSetByTouchPoint(point: position)
//            dataSet?.drawValuesEnabled = true
            highlightValue(highlight)
        } else {
            // hide
            let position = sender.location(in: self)
            let highlight = self.getHighlightByTouchPoint(position)
            _ = self.getDataSetByTouchPoint(point: position)
//            dataSet?.drawValuesEnabled = true
            highlightValue(highlight)
//            data?.dataSets.forEach{ $0.drawValuesEnabled = true }
//            highlightValue(nil)
        }
    }
}
