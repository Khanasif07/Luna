//
//  Double+Extension.swift
//  Luna
//
//  Created by Admin on 03/06/21.
//

import Foundation

extension Double {
    var stringValue : String {
        return "\(self)"
    }
    
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
    func nextMultiple(of num: Double)-> Double {
        guard self.remainder(dividingBy: num) != 0 else { return self }
        return num * Double(Int(self/num) + 1)
    }
    
    func previousMultiple(of num: Double)-> Double {
        return self - abs(self.remainder(dividingBy: num))
    }
}

extension Int {
    var stringValue : String {
        return "\(self)"
    }
}
