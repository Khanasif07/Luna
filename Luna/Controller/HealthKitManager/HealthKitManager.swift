//
//  HealthKitManager.swift
//  Luna
//
//  Created by Admin on 13/07/21.
//

//import Foundation
//import HealthKit
//
//class HealthKitManager {
//let storage = HKHealthStore()
//
//init()
//{
//    checkAuthorization()
//}
//
//func checkAuthorization() -> Bool
//{
//    // Default to assuming that we're authorized
//    var isEnabled = true
//
//    // Do we have access to HealthKit on this device?
//    if HKHealthStore.isHealthDataAvailable()
//    {
//        // We have to request each data type explicitly
//        let steps = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
//
//        // Now we can request authorization for step count data
//        storage.requestAuthorization(toShare: nil, read: steps as? Set<HKObjectType>) { (success, error) -> Void in
//            isEnabled = success
//        }
//    }
//    else
//    {
//        isEnabled = false
//    }
//
//    return isEnabled
//}

//func yesterdaySteps(completion: (Double, NSError?) -> ())
//{
//    // The type of data we are requesting (this is redundant and could probably be an enumeration
//    let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
//
//    // Our search predicate which will fetch data from now until a day ago
//    // (Note, 1.day comes from an extension
//    // You'll want to change that to your own NSDate
//
//    let calendar = NSCalendar.current
//    let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())
//    //this is probably why my data is wrong
//    let predicate = HKQuery.predicateForSamples(withStart: yesterday, end: Date(), options: .strictEndDate)
//
//    // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
//    let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
//        var steps: Double = 0
//
//        if results?.count ?? 0 > 0
//        {
//            for result in results as! [HKQuantitySample]
//            {
//                steps += result.quantity.doubleValue(for: HKUnit.count())
//            }
//        }
//
//        //I'm unsure if this is correct as well
//        completion(steps, error as NSError?)
//        print("\(steps) STEPS FROM HEALTH KIT")
//        //this adds the steps to my character (is this in the right place)
////        Player.User.Gold.addSteps(Int(steps))
//    }
//    //not 100% on what this does, but I know it is necessary
//    storage.execute(query)
//}
//}
import Foundation
import HealthKit

protocol HeartRateDelegate {
    func heartRateUpdated(heartRateSamples: [HKSample])
}

class HealthKitManager: NSObject {
    
    static let sharedInstance = HealthKitManager()
    
    private override init() {}
    
    let healthStore = HKHealthStore()
    
    var anchor: HKQueryAnchor?
    
    var heartRateDelegate: HeartRateDelegate?
    
    // access HealthKit API logic.
    func authorizeHealthKit(_ completion: @escaping ((_ success: Bool, _ error: Error?) -> Void)) {
        
        guard let heartRateType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        guard let distanceWalkingRunningType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            return
        }
        
        guard let flightsClimbedType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) else {
            return
        }
        
        guard let stepCountType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        guard let restingHeartRate: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else {
            return
        }
        
        guard let bodyMass: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .bodyMass) else {
            return
        }
        
        guard  let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth) else {
            return
        }
        
        // Permissions to write and read from HealthKit
        let typesToShare = Set([HKObjectType.workoutType(), heartRateType])
        let typesToRead = Set([HKObjectType.workoutType(), heartRateType, HKSeriesType.workoutRoute(), restingHeartRate, bodyMass, dateOfBirth, distanceWalkingRunningType, flightsClimbedType, stepCountType])
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            print("Was authorisation successful? \(success)")
            completion(success, error)
        }
    }
    
}
