
//  HealthKitManager.swift
//  Luna
//
//  Created by Admin on 13/07/21.

import Foundation
import HealthKit

protocol HeartRateDelegate {
    func heartRateUpdated(heartRateSamples: [HKSample])
}

class HealthKitManager: NSObject {
    
    static let sharedInstance = HealthKitManager()
    
    private override init() {}
    
    var isEnabled = false
    
    let healthStore = HKHealthStore()
    
    var anchor: HKQueryAnchor?
    
    var heartRateDelegate: HeartRateDelegate?
    
    // access HealthKit API logic.
    func authorizeHealthKit(_ completion: @escaping ((_ success: Bool, _ error: Error?) -> Void)) {
        
        guard let heartRateType: HKQuantityType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        
        guard let waterType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater) else { return }
        
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
        
        guard  let sex = HKObjectType.characteristicType(forIdentifier: .biologicalSex) else {
            return
        }
        
        guard  let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType) else {
            return
        }
        // Permissions to write and read from HealthKit
        let typesToShare = Set([HKObjectType.workoutType(), heartRateType,waterType])
        let typesToRead = Set([HKObjectType.workoutType(), heartRateType, HKSeriesType.workoutRoute(), restingHeartRate, bodyMass, dateOfBirth ,sex, bloodType ,distanceWalkingRunningType, flightsClimbedType, stepCountType])
        if HKHealthStore.isHealthDataAvailable() {
            healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
                print("Was authorisation successful? \(success)")
                self.isEnabled = success
                completion(success, error)
            }
        }else{isEnabled = false}
    }
    
    func yesterdaySteps(completion: @escaping (Double, NSError?) -> ()){
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        guard let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount) else { return }
    
        // Our search predicate which will fetch data from now until a day ago
        // (Note, 1.day comes from an extension
        // You'll want to change that to your own NSDate
    
        let calendar = NSCalendar.current
        let yesterday = calendar.date(byAdding: .day, value: -25, to: Date())
        //this is probably why my data is wrong
        let predicate = HKQuery.predicateForSamples(withStart: yesterday, end: Date(), options: .strictEndDate)
    
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 0, sortDescriptors: nil) { (query, results, error) in
            var steps: Double = 0
    
            if results?.count ?? 0 > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    steps += result.quantity.doubleValue(for: HKUnit.count())
                }
            }
            completion(steps, error as NSError?)
            print("\(steps) STEPS FROM HEALTH KIT")
        }
        //not 100% on what this does, but I know it is necessary
        healthStore.execute(query)
    }
    
    func getAgeSexAndBloodType() throws -> (age: Int,
                                                  biologicalSex: HKBiologicalSex,
                                                  bloodType: HKBloodType) {
        
      do {

        //1. This method throws an error if these data are not available.
        let birthdayComponents =  try healthStore.dateOfBirthComponents()
        let biologicalSex =       try healthStore.biologicalSex()
        let bloodType =           try healthStore.bloodType()
          
        //2. Use Calendar to calculate age.
        let today = Date()
        let calendar = Calendar.current
        let todayDateComponents = calendar.dateComponents([.year],
                                                            from: today)
        let thisYear = todayDateComponents.year!
        let age = thisYear - birthdayComponents.year!
         
        //3. Unwrap the wrappers to get the underlying enum values.
        let unwrappedBiologicalSex = biologicalSex.biologicalSex
        let unwrappedBloodType = bloodType.bloodType
        print(age)
        print(unwrappedBiologicalSex)
        print(unwrappedBloodType)
        return (age, unwrappedBiologicalSex, unwrappedBloodType)
      }
    }
    
    func addWaterAmountToHealthKit(ounces : Double) {
      // 1
      let quantityType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)
      
      // string value represents US fluid
      // 2
        let quanitytUnit = HKUnit.init(from: "fl_oz_us")
      let quantityAmount = HKQuantity(unit: quanitytUnit, doubleValue: ounces)
      let now = Date()
      // 3
      let sample = HKQuantitySample(type: quantityType!, quantity: quantityAmount, start: now, end: now)
      let correlationType = HKObjectType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.food)
      // 4
      let waterCorrelationForWaterAmount = HKCorrelation(type: correlationType!, start: now, end: now, objects: [sample])
      // Send water intake data to healthStore…aka ‘Health’ app
      // 5
        healthStore.save(waterCorrelationForWaterAmount, withCompletion: { (success, error) in
        if (error != nil) {
            print(error?.localizedDescription)
        }
      })
    }


    
}
