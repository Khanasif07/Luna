//
//  IobCalculator.swift
//  Luna
//
//  Created by Francis Pascual on 2/15/22.
//

import Foundation

enum IobCalculator {
    static func calculateIob(doses: [Insulin], time: Date) -> Double {
        // TODO: Filter out doses that are way outside the applicable time range.
        let applicableDoses = doses.sorted { $0.time < $1.time }
        
        // Start calculating at the first dose, anything before that is 0.0 IOB.
        // Note that the first reportable IOB occurs at the end of the interval that includes the first dose.
        // E.g., if an insulin dose is recorded at 10:01:35, then the first reported IOB will be at 10:02:00.
        guard let firstDose = applicableDoses.first else { return 0.0 }
        let startTime = firstDose.time.timeBin
        // In order to report out on the IOB for current time, seek towards 1-interval past the time if not on the time bin border
        let endTime =  time.isEvenlyTimeBinDivisible ? time.timeBin : time.timeBin + ITERATION_INTERVAL
        var burndown = Burndown()
        
        var doseIndex = 0
        var nextDose: Insulin? = applicableDoses[doseIndex]
        for currentInterval in stride(from: startTime, through: endTime, by: ITERATION_INTERVAL) {
            var newInsulin = 0.0
            while let evalDose = nextDose {
                // Intervals are a tail-end accumulation of all doses in the past interval period up to the current interval timestamp; exclusive start with inclusive end.
                if(evalDose.time.timeIntervalSince1970 > currentInterval - ITERATION_INTERVAL) {
                    if(evalDose.time.timeIntervalSince1970 <= currentInterval) {
                        newInsulin += evalDose.amount
                        nextDose = getNextDose(&doseIndex, doses: applicableDoses)
                    } else {
                        // Dose is in the future, wait until it is in the current interval
                        break
                    }
                } else {
                    // Dose is in the past, move onto the next one.
                    nextDose = getNextDose(&doseIndex, doses: applicableDoses)
                }
            }
            
            burndown = stepBurndown(burndown, newInsulin: newInsulin)
        }
        
        return burndown.total
    }
    
    private static func getNextDose(_ index: inout Int, doses: [Insulin]) -> Insulin? {
        index += 1
        if(index < doses.count) {
            return doses[index]
        } else {
            return nil
        }
    }
    
    private static func stepBurndown(_ original: Burndown, newInsulin: Double) -> Burndown {
        // Add new insulin into compartment one before applying the formula
        let compartmentOne = original.compartmentOne + newInsulin
        let compartmentTwo = original.compartmentTwo
        let compartmentOnePrime = compartmentOne * ALPHA
        let compartmentTwoPrime = (compartmentTwo + (compartmentOne * (1-ALPHA)))*ALPHA
        return Burndown(
            compartmentOne: compartmentOnePrime,
            compartmentTwo: compartmentTwoPrime
        )
    }
    
    struct Burndown {
        var compartmentOne: Double = 0.0
        var compartmentTwo: Double = 0.0
        
        var total: Double {
            get { compartmentOne + compartmentTwo }
        }
    }
    
}

/// The interval by which IOB is calculated.  All insulin within this period are summed
fileprivate let ITERATION_INTERVAL: TimeInterval = 60.0

/// PK/PD Peak of Insulin
fileprivate let INSULIN_PKPD: TimeInterval = 65.0*ITERATION_INTERVAL
fileprivate let ALPHA: TimeInterval = exp((-ITERATION_INTERVAL) / INSULIN_PKPD)

fileprivate extension Date {
    var timeBin: TimeInterval { ((self.timeIntervalSince1970 / ITERATION_INTERVAL).rounded(.towardZero))*ITERATION_INTERVAL }
    
    var isEvenlyTimeBinDivisible: Bool { self.timeIntervalSince1970.truncatingRemainder(dividingBy: ITERATION_INTERVAL) == 0.0 }
}
