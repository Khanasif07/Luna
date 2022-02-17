//
//  IobCalculatorTest.swift
//  Luna
//
//  Created by Francis Pascual on 2/15/22.
//

import XCTest
@testable import Luna
/// Test IOB calculator results
///
/// Test results are generated from this Google Spreadsheet by filling out insulin amounts in the corresponding Insulin column at the corresponding time
///
/// - See:
/// [Two-Compartment Model](https://docs.google.com/spreadsheets/d/1RJLcY8m6nByZKVjau-LlQCkRBXVdMU1HYTpMSkzt8os)
class IobCalculatorTest: XCTestCase {

    let epoch = Date(timeIntervalSince1970: 1644969600)
    
    func testIobNoDoses() throws {
        let iob = IobCalculator.calculateIob(doses: [], time: epoch)
        XCTAssertEqual(0.0, iob, accuracy: 0.001)
    }

    func testIobSingleDoseWithCurrentTimeOnTimeBoundary() throws {
        struct TestVector {
            let timeAgo: TimeInterval
            let amount: Double
            let expected: Double
        }
        let testVectors = [
            TestVector(timeAgo: 0.minute, amount: 1.0, expected: 0.9997),
            TestVector(timeAgo: 1.minute, amount: 1.0, expected: 0.9993),
            TestVector(timeAgo: 2.minute, amount: 1.0, expected: 0.9986),
            TestVector(timeAgo: 3.minute, amount: 1.0, expected: 0.9977),
            TestVector(timeAgo: 4.minute, amount: 1.0, expected: 0.9966),
            TestVector(timeAgo: 5.minute, amount: 1.0, expected: 0.9953),
            TestVector(timeAgo: 30.minute, amount: 1.0, expected: 0.9144),
            TestVector(timeAgo: 1.hour, amount: 1.0, expected: 0.7555),
            TestVector(timeAgo: 2.hour, amount: 1.0, expected: 0.4425),
            TestVector(timeAgo: 3.hour, amount: 1.0, expected: 0.2323),
            TestVector(timeAgo: 4.hour, amount: 1.0, expected: 0.1148),
            TestVector(timeAgo: 5.hour, amount: 1.0, expected: 0.0545),
            TestVector(timeAgo: 6.hour, amount: 1.0, expected: 0.0252),
            TestVector(timeAgo: 7.hour, amount: 1.0, expected: 0.0114),
            TestVector(timeAgo: 8.hour, amount: 1.0, expected: 0.0050),
            TestVector(timeAgo: 9.hour, amount: 1.0, expected: 0.0022),
            TestVector(timeAgo: 10.hour, amount: 1.0, expected: 0.0009),
            TestVector(timeAgo: 11.hour, amount: 1.0, expected: 0.0004),
            TestVector(timeAgo: 12.hour, amount: 1.0, expected: 0.0001),
            TestVector(timeAgo: 13.hour, amount: 1.0, expected: 0.0000),
            TestVector(timeAgo: 14.hour, amount: 1.0, expected: 0.0000),
            
            TestVector(timeAgo: 0.minute, amount: 5.0, expected: 4.9988),
            TestVector(timeAgo: 1.minute, amount: 5.0, expected: 4.9965),
            TestVector(timeAgo: 2.minute, amount: 5.0, expected: 4.9931),
            TestVector(timeAgo: 3.minute, amount: 5.0, expected: 4.9886),
            TestVector(timeAgo: 4.minute, amount: 5.0, expected: 4.9832),
            TestVector(timeAgo: 5.minute, amount: 5.0, expected: 4.9767),
            TestVector(timeAgo: 30.minute, amount: 5.0, expected: 4.5722),
            TestVector(timeAgo: 1.hour, amount: 5.0, expected: 3.7778),
            TestVector(timeAgo: 2.hour, amount: 5.0, expected: 2.2128),
            TestVector(timeAgo: 3.hour, amount: 5.0, expected: 1.1619),
            TestVector(timeAgo: 4.hour, amount: 5.0, expected: 0.5740),
            TestVector(timeAgo: 5.hour, amount: 5.0, expected: 0.2726),
            TestVector(timeAgo: 6.hour, amount: 5.0, expected: 0.1260),
            TestVector(timeAgo: 7.hour, amount: 5.0, expected: 0.0571),
            TestVector(timeAgo: 8.hour, amount: 5.0, expected: 0.0254),
            TestVector(timeAgo: 9.hour, amount: 5.0, expected: 0.0112),
            TestVector(timeAgo: 10.hour, amount: 5.0, expected: 0.0049),
            TestVector(timeAgo: 11.hour, amount: 5.0, expected: 0.0021),
            TestVector(timeAgo: 12.hour, amount: 5.0, expected: 0.0009),
            TestVector(timeAgo: 13.hour, amount: 5.0, expected: 0.0003),
            TestVector(timeAgo: 14.hour, amount: 5.0, expected: 0.0001),
            
            TestVector(timeAgo: 0.minute, amount: 10.0, expected: 9.9976),
            TestVector(timeAgo: 1.minute, amount: 10.0, expected: 9.9930),
            TestVector(timeAgo: 2.minute, amount: 10.0, expected: 9.9862),
            TestVector(timeAgo: 3.minute, amount: 10.0, expected: 9.9773),
            TestVector(timeAgo: 4.minute, amount: 10.0, expected: 9.9664),
            TestVector(timeAgo: 5.minute, amount: 10.0, expected: 9.9534),
            TestVector(timeAgo: 30.minute, amount: 10.0, expected: 9.1444),
            TestVector(timeAgo: 1.hour, amount: 10.0, expected: 7.5557),
            TestVector(timeAgo: 2.hour, amount: 10.0, expected: 4.4256),
            TestVector(timeAgo: 3.hour, amount: 10.0, expected: 2.3239),
            TestVector(timeAgo: 4.hour, amount: 10.0, expected: 1.1480),
            TestVector(timeAgo: 5.hour, amount: 10.0, expected: 0.5453),
            TestVector(timeAgo: 6.hour, amount: 10.0, expected: 0.2521),
            TestVector(timeAgo: 7.hour, amount: 10.0, expected: 0.1142),
            TestVector(timeAgo: 8.hour, amount: 10.0, expected: 0.0509),
            TestVector(timeAgo: 9.hour, amount: 10.0, expected: 0.0224),
            TestVector(timeAgo: 10.hour, amount: 10.0, expected: 0.0098),
            TestVector(timeAgo: 11.hour, amount: 10.0, expected: 0.0042),
            TestVector(timeAgo: 12.hour, amount: 10.0, expected: 0.0018),
            TestVector(timeAgo: 13.hour, amount: 10.0, expected: 0.0007),
            TestVector(timeAgo: 14.hour, amount: 10.0, expected: 0.0003),
        ]
        
        testVectors.forEach { tv in
            let doses = [Insulin(time: epoch.addingTimeInterval(-tv.timeAgo), amount: tv.amount)]
            let iob = IobCalculator.calculateIob(doses: doses, time: epoch)
            XCTAssertEqual(tv.expected, iob, accuracy: 0.0001, "\(tv)")
        }
    }
    
    func testIobSingleDoseWithCurrentTimeOffsetFromTimeBoundary() throws {
        struct TestVector {
            let timeAgo: TimeInterval
            let amount: Double
            let expected: Double
        }
        let testVectors = [
            TestVector(timeAgo: 0.minute + 20.0, amount: 1.0, expected: 0.9997),
            TestVector(timeAgo: 1.minute + 20.0, amount: 1.0, expected: 0.9993),
            TestVector(timeAgo: 2.minute + 20.0, amount: 1.0, expected: 0.9986),
            TestVector(timeAgo: 3.minute + 20.0, amount: 1.0, expected: 0.9977),
            TestVector(timeAgo: 4.minute + 20.0, amount: 1.0, expected: 0.9966),
            TestVector(timeAgo: 5.minute + 20.0, amount: 1.0, expected: 0.9953),
            TestVector(timeAgo: 30.minute + 20.0, amount: 1.0, expected: 0.9144),
            TestVector(timeAgo: 1.hour + 20.0, amount: 1.0, expected: 0.7555),
            TestVector(timeAgo: 2.hour + 20.0, amount: 1.0, expected: 0.4425),
            TestVector(timeAgo: 3.hour + 20.0, amount: 1.0, expected: 0.2323),
            TestVector(timeAgo: 4.hour + 20.0, amount: 1.0, expected: 0.1148),
            TestVector(timeAgo: 5.hour + 20.0, amount: 1.0, expected: 0.0545),
            TestVector(timeAgo: 6.hour + 20.0, amount: 1.0, expected: 0.0252),
            TestVector(timeAgo: 7.hour + 20.0, amount: 1.0, expected: 0.0114),
            TestVector(timeAgo: 8.hour + 20.0, amount: 1.0, expected: 0.0050),
            TestVector(timeAgo: 9.hour + 20.0, amount: 1.0, expected: 0.0022),
            TestVector(timeAgo: 10.hour + 20.0, amount: 1.0, expected: 0.0009),
            TestVector(timeAgo: 11.hour + 20.0, amount: 1.0, expected: 0.0004),
            TestVector(timeAgo: 12.hour + 20.0, amount: 1.0, expected: 0.0001),
            TestVector(timeAgo: 13.hour + 20.0, amount: 1.0, expected: 0.0000),
            TestVector(timeAgo: 14.hour + 20.0, amount: 1.0, expected: 0.0000),
            
            TestVector(timeAgo: 0.minute + 13.0, amount: 5.0, expected: 4.9988),
            TestVector(timeAgo: 1.minute + 13.0, amount: 5.0, expected: 4.9965),
            TestVector(timeAgo: 2.minute + 13.0, amount: 5.0, expected: 4.9931),
            TestVector(timeAgo: 3.minute + 13.0, amount: 5.0, expected: 4.9886),
            TestVector(timeAgo: 4.minute + 13.0, amount: 5.0, expected: 4.9832),
            TestVector(timeAgo: 5.minute + 13.0, amount: 5.0, expected: 4.9767),
            TestVector(timeAgo: 30.minute + 13.0, amount: 5.0, expected: 4.5722),
            TestVector(timeAgo: 1.hour + 13.0, amount: 5.0, expected: 3.7778),
            TestVector(timeAgo: 2.hour + 13.0, amount: 5.0, expected: 2.2128),
            TestVector(timeAgo: 3.hour + 13.0, amount: 5.0, expected: 1.1619),
            TestVector(timeAgo: 4.hour + 13.0, amount: 5.0, expected: 0.5740),
            TestVector(timeAgo: 5.hour + 13.0, amount: 5.0, expected: 0.2726),
            TestVector(timeAgo: 6.hour + 13.0, amount: 5.0, expected: 0.1260),
            TestVector(timeAgo: 7.hour + 13.0, amount: 5.0, expected: 0.0571),
            TestVector(timeAgo: 8.hour + 13.0, amount: 5.0, expected: 0.0254),
            TestVector(timeAgo: 9.hour + 13.0, amount: 5.0, expected: 0.0112),
            TestVector(timeAgo: 10.hour + 13.0, amount: 5.0, expected: 0.0049),
            TestVector(timeAgo: 11.hour + 13.0, amount: 5.0, expected: 0.0021),
            TestVector(timeAgo: 12.hour + 13.0, amount: 5.0, expected: 0.0009),
            TestVector(timeAgo: 13.hour + 13.0, amount: 5.0, expected: 0.0003),
            TestVector(timeAgo: 14.hour + 13.0, amount: 5.0, expected: 0.0001),
            
            TestVector(timeAgo: 0.minute + 59.0, amount: 10.0, expected: 9.9976),
            TestVector(timeAgo: 1.minute + 59.0, amount: 10.0, expected: 9.9930),
            TestVector(timeAgo: 2.minute + 59.0, amount: 10.0, expected: 9.9862),
            TestVector(timeAgo: 3.minute + 59.0, amount: 10.0, expected: 9.9773),
            TestVector(timeAgo: 4.minute + 59.0, amount: 10.0, expected: 9.9664),
            TestVector(timeAgo: 5.minute + 59.0, amount: 10.0, expected: 9.9534),
            TestVector(timeAgo: 30.minute + 59.0, amount: 10.0, expected: 9.1444),
            TestVector(timeAgo: 1.hour + 59.0, amount: 10.0, expected: 7.5557),
            TestVector(timeAgo: 2.hour + 59.0, amount: 10.0, expected: 4.4256),
            TestVector(timeAgo: 3.hour + 59.0, amount: 10.0, expected: 2.3239),
            TestVector(timeAgo: 4.hour + 59.0, amount: 10.0, expected: 1.1480),
            TestVector(timeAgo: 5.hour + 59.0, amount: 10.0, expected: 0.5453),
            TestVector(timeAgo: 6.hour + 59.0, amount: 10.0, expected: 0.2521),
            TestVector(timeAgo: 7.hour + 59.0, amount: 10.0, expected: 0.1142),
            TestVector(timeAgo: 8.hour + 59.0, amount: 10.0, expected: 0.0509),
            TestVector(timeAgo: 9.hour + 59.0, amount: 10.0, expected: 0.0224),
            TestVector(timeAgo: 10.hour + 59.0, amount: 10.0, expected: 0.0098),
            TestVector(timeAgo: 11.hour + 59.0, amount: 10.0, expected: 0.0042),
            TestVector(timeAgo: 12.hour + 59.0, amount: 10.0, expected: 0.0018),
            TestVector(timeAgo: 13.hour + 59.0, amount: 10.0, expected: 0.0007),
            TestVector(timeAgo: 14.hour + 59.0, amount: 10.0, expected: 0.0003),
        ]
        
        testVectors.forEach { tv in
            let doses = [Insulin(time: epoch.addingTimeInterval(-tv.timeAgo), amount: tv.amount)]
            let iob = IobCalculator.calculateIob(doses: doses, time: epoch)
            XCTAssertEqual(tv.expected, iob, accuracy: 0.0001, "\(tv)")
        }
    }
    
    func testIobMultipleDosesArrivingOverTime() throws {
        let doses = [
            Insulin(time: epoch.addingTimeInterval(1.minute), amount: 1.2),
            Insulin(time: epoch.addingTimeInterval(4.minute + 13.seconds), amount: 0.8),
            Insulin(time: epoch.addingTimeInterval(1.hour + 1.minute + 30.seconds), amount: 0.8),
            Insulin(time: epoch.addingTimeInterval(2.hour + 47.minute + 01.seconds), amount: 0.5),
            Insulin(time: epoch.addingTimeInterval(2.hour + 47.minute + 59.seconds), amount: 0.5),
            Insulin(time: epoch.addingTimeInterval(2.hour + 48.minute + 59.seconds), amount: 0.5),
            Insulin(time: epoch.addingTimeInterval(2.hour + 55.minute + 43.seconds), amount: 1.0),
            Insulin(time: epoch.addingTimeInterval(3.hour + 01.seconds), amount: 1.0),
        ]
        
        struct TestVector {
            let currentTime: TimeInterval
            let expected: Double
        }
        
        let testVectors = [
            TestVector(currentTime: 0.minute, expected: 0),
            TestVector(currentTime: 1.minute, expected: 1.1997),
            TestVector(currentTime: 2.minute, expected: 1.1991),
            TestVector(currentTime: 3.minute, expected: 1.1983),
            TestVector(currentTime: 4.minute, expected: 1.1972),
            TestVector(currentTime: 5.minute, expected: 1.9957),
            TestVector(currentTime: 30.minute, expected: 1.8519),
            TestVector(currentTime: 1.hour, expected: 1.5404),
            TestVector(currentTime: 2.hour, expected: 1.5220),
            TestVector(currentTime: 3.hour, expected: 3.3096),
            TestVector(currentTime: 4.hour, expected: 2.9558),
            TestVector(currentTime: 5.hour, expected: 1.6684),
            TestVector(currentTime: 6.hour, expected: 0.8591),
            TestVector(currentTime: 7.hour, expected: 0.4193),
            TestVector(currentTime: 8.hour, expected: 0.1975),
            TestVector(currentTime: 9.hour, expected: 0.0908),
            TestVector(currentTime: 10.hour, expected: 0.0409),
            TestVector(currentTime: 11.hour, expected: 0.0182),
            TestVector(currentTime: 12.hour, expected: 0.0080),
            TestVector(currentTime: 13.hour, expected: 0.0034),
            TestVector(currentTime: 14.hour, expected: 0.0015),
        ]
        
        testVectors.forEach { tv in
            // This test also demonstrates that doses in the future are not considered part of the IOB unless
            // they exist within the time interval of the current time or before.
            let iob = IobCalculator.calculateIob(doses: doses, time: epoch.addingTimeInterval(tv.currentTime))
            XCTAssertEqual(tv.expected, iob, accuracy: 0.0001, "\(tv)")
        }
    }
}

fileprivate extension Int {
    var seconds: TimeInterval { Double(self) }
    var minute: TimeInterval { Double(self) * 60.0 }
    var hour: TimeInterval { self.minute * 60.0 }
}
