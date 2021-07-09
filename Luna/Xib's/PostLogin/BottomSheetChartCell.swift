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
        let data = [
            (x: 0, y: 0.0),
            (x: 3, y: 50.0),
            (x: 4, y: 75.0),
            (x: 5, y: 25.0),
            (x: 7, y: 100.0),
            (x: 8, y: 200.0),
            (x: 9, y: 250.0),(x: 12, y: 130.0),(x: 15, y: 160.0),(x: 18, y: 275.0)
        ]
        let series = ChartSeries(data: data)
        series.area = true
        series.color = #colorLiteral(red: 0.2705882353, green: 0.7843137255, blue: 0.5803921569, alpha: 1)
        chartView.lineWidth = 3.0
        chartView.xLabelsOrientation = .horizontal
        chartView.xLabels = [0, 3, 6, 9, 12, 15, 18]
        chartView.yLabels = [0, 50, 100, 150, 200, 250, 300]
       
        chartView.xLabelsFormatter = { String(Int(roundf(Float($1)))) + " am" }
        chartView.yLabelsFormatter = { String(Int(roundf(Float($1)))) + "" }
        chartView.add(series)
        chartView.reloadInputViews()
    }
    
    // MARK: - IBActions
    //===========================
    
    
}
