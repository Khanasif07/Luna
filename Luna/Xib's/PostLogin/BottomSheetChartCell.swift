//
//  BottomSheetChartCell.swift
//  Luna
//
//  Created by Admin on 09/07/21.
//

import UIKit
import SwiftChart

class BottomSheetChartCell: UITableViewCell {
    
    // MARK: - IBOutlets
    //===========================
    @IBOutlet weak var chartView: Chart!
    
    // MARK: - Variables
    //===========================
    var xRangeValue = [Double]()
    var data : [(x: Int, y: Double)] = [] {
        didSet{
            let series = ChartSeries(data: data)
            self.xRangeValue = data.map({ (tuple) -> Double in
               return Double(tuple.x)
            })
            series.area = true
//            chartView.xLabels = [20,40,60,80,100,120,140,160,180,200,220,240]
            series.color = #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1)
            chartView.add(series)
            chartView.reloadInputViews()
        }
    }
    
    // MARK: - Lifecycle
    //===========================
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpChartData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setUpChartData(){
        let series = ChartSeries(data: data)
        series.area = true
        series.color = #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1)
        chartView.lineWidth = 3.0
        chartView.xLabelsOrientation = .horizontal
//        chartView.xLabels =  xRangeValue
        chartView.yLabels = [0, 50, 100, 150, 200, 250]
        //
        chartView.showYLabelsAndGrid = true
        chartView.showXLabelsAndGrid = true
        chartView.axesColor = .clear
       //
//        chartView.xLabelsFormatter = { String(Int(roundf(Float($1)))) + " am" }
        chartView.yLabelsFormatter = { String(Int(roundf(Float($1)))) + "" }
        chartView.add(series)
        chartView.reloadInputViews()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}
