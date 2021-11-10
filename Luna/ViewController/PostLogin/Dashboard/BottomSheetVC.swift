//
//  BottomSheetVC.swift
//  Luna
//
//  Created by Admin on 22/09/21.
//


import Foundation
import UIKit
import Charts
import UserNotifications
import Photos

class BottomSheetVC:  UIViewController,UNUserNotificationCenterDelegate {
    
    //MARK:- OUTLETS
    //==============
    @IBOutlet weak var cgmChartView: TappableLineChartView!
    @IBOutlet weak var mainCotainerView: UIView!
    @IBOutlet weak var bottomLayoutConstraint : NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var timeAgoLbl: UILabel!
    @IBOutlet weak var cgmDirectionlbl: UILabel!
    @IBOutlet weak var cgmValueLbl: UILabel!
    
    //MARK:- VARIABLE
    //================
    // Variables for BG Charts
    let ScaleXMax:Float = 150.0
    public var numPoints: Int = 13
    var firstGraphLoad: Bool = true
    var minAgoBG: Double = 0.0
    var currentOverride = 1.0
    // Vars for NS Pull
    var graphHours:Int=24
    var mmol = false as Bool
    var lastUpdatedCGMDate = AppUserDefaults.value(forKey: .lastUpdatedCGMDate).doubleValue
    var urlUser = UserDefaultsRepository.url.value as String
    var token = UserDefaultsRepository.token.value as String
//    var defaults : UserDefaults?
//    let consoleLogging = true
//    var timeofLastBGUpdate = 0 as TimeInterval
//    var nsVerifiedAlerted = false
    
    var backgroundTask = BackgroundTask()
    
    // Refresh NS Data
//    var timer = Timer()
    // check every 30 Seconds whether new bgvalues should be retrieved
    let timeInterval: TimeInterval = 30.0
    
    // Min Ago Timer
    var minAgoTimer = Timer()
    var minAgoTimeInterval: TimeInterval = 10.0
    
    // Check Alarms Timer
    // Don't check within 1 minute of alarm triggering to give the snoozer time to save data
//    var checkAlarmTimer = Timer()
    
    var bgTimer = Timer()
//    var deviceStatusTimer = Timer()
//    var alarmTimer = Timer()
//    var profileTimer = Timer()
    
    // Info Table Setup
    var bgCheckData: [ShareGlucoseData] = []
    
    var bgData: [ShareGlucoseData] = [Luna.ShareGlucoseData(sgv: 185, date: 1636356883.0, direction: ("FortyFiveDown"), insulin:  "0"), Luna.ShareGlucoseData(sgv: 177, date: 1636357183.0, direction: ("FortyFiveDown"), insulin:  "0"), Luna.ShareGlucoseData(sgv: 170, date: 1636357483.0, direction:  ("FortyFiveDown"), insulin:  "0"), Luna.ShareGlucoseData(sgv: 165, date: 1636357783.0, direction: ("FortyFiveDown"), insulin:  "0"), Luna.ShareGlucoseData(sgv: 163, date: 1636358083.0, direction: ("FortyFiveDown"), insulin:  "0"), Luna.ShareGlucoseData(sgv: 160, date: 1636358383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 156, date: 1636358683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 152, date: 1636358983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 150, date: 1636359283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 151, date: 1636359583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 148, date: 1636359882.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 146, date: 1636360183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 146, date: 1636360483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 147, date: 1636360783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 148, date: 1636361083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 148, date: 1636361383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 146, date: 1636361683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 146, date: 1636361983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 144, date: 1636362282.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 140, date: 1636362583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 136, date: 1636362883.0, direction: "Flat" , insulin: "0"), Luna.ShareGlucoseData(sgv: 133, date: 1636363183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 128, date: 1636363483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 125, date: 1636363783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 123, date: 1636364083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 121, date: 1636364383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 119, date: 1636364683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 116, date: 1636364983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 115, date: 1636365282.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 111, date: 1636365582.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 110, date: 1636365883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 109, date: 1636366183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 109, date: 1636366483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 108, date: 1636366783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 107, date: 1636367083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 105, date: 1636367383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 104, date: 1636367683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 104, date: 1636367983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 104, date: 1636368283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 104, date: 1636368583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 103, date: 1636368883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 104, date: 1636369183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 104, date: 1636369483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 103, date: 1636369783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 102, date: 1636370083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 100, date: 1636370382.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 99, date: 1636370683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 97, date: 1636370983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 96, date: 1636371283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 95, date: 1636371583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 95, date: 1636371883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 94, date: 1636372182.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 94, date: 1636372483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 94, date: 1636372782.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 94, date: 1636373083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 94, date: 1636373383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 91, date: 1636373683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 91, date: 1636373983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 94, date: 1636374283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 96, date: 1636374583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 101, date: 1636374883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 104, date: 1636375182.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 103, date: 1636375483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 103, date: 1636375783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 105, date: 1636376083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 107, date: 1636376383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 109, date: 1636376683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 106, date: 1636376982.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 105, date: 1636377283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 113, date: 1636377583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 115, date: 1636377882.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 114, date: 1636378183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 112, date: 1636378483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 110, date: 1636378783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 110, date: 1636379083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 108, date: 1636379383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 108, date: 1636379683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 107, date: 1636379983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 107, date: 1636380283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 107, date: 1636380583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 101, date: 1636380883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 97, date: 1636381183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 94, date: 1636381483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 107, date: 1636381782.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 110, date: 1636382083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 112, date: 1636382383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 111, date: 1636382682.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 109, date: 1636382982.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 109, date: 1636383282.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 109, date: 1636383582.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 110, date: 1636383883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 111, date: 1636384183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 109, date: 1636384483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 109, date: 1636384783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 110, date: 1636385083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 108, date: 1636385383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 108, date: 1636385683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 107, date: 1636385983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 107, date: 1636386283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 106, date: 1636386583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 103, date: 1636386883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 101, date: 1636387183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 96, date: 1636387483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 92, date: 1636387783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 94, date: 1636388082.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 97, date: 1636388382.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 102, date: 1636388683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 110, date: 1636388983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 116, date: 1636389283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 120, date: 1636389583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 125, date: 1636389883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 127, date: 1636390183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 129, date: 1636390483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 129, date: 1636390783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 127, date: 1636391083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 125, date: 1636391383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 122, date: 1636391683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 122, date: 1636391983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 120, date: 1636392283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 124, date: 1636392583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 121, date: 1636392883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 120, date: 1636393183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 116, date: 1636393483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 114, date: 1636393783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 116, date: 1636394083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 119, date: 1636394383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 125, date: 1636394683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 129, date: 1636394983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 133, date: 1636395283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 133, date: 1636395583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 131, date: 1636395883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 126, date: 1636396183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 124, date: 1636396483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 123, date: 1636396783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 114, date: 1636397083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 111, date: 1636397383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 110, date: 1636397683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 113, date: 1636397983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 119, date: 1636398283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 123, date: 1636398583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 126, date: 1636398883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 124, date: 1636399183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 125, date: 1636399483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 123, date: 1636399783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 124, date: 1636400083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 128, date: 1636400383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 128, date: 1636400683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 129, date: 1636400983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 129, date: 1636401283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 123, date: 1636401583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 118, date: 1636401883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 123, date: 1636402183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 122, date: 1636402483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 118, date: 1636402783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 119, date: 1636403083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 118, date: 1636403383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 114, date: 1636403683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 112, date: 1636403983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 113, date: 1636404283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 112, date: 1636404583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 112, date: 1636404883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 116, date: 1636405183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 123, date: 1636405483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 128, date: 1636405782.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 131, date: 1636406083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 131, date: 1636406383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 138, date: 1636406682.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 140, date: 1636406983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 145, date: 1636407283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 150, date: 1636407583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 153, date: 1636407883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 153, date: 1636408183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 156, date: 1636408482.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 158, date: 1636408783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 159, date: 1636409083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 159, date: 1636409383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 158, date: 1636409682.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 159, date: 1636409983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 163, date: 1636410283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 161, date: 1636410582.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 159, date: 1636410883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 157, date: 1636411182.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 154, date: 1636411483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 157, date: 1636411783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 153, date: 1636412083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 152, date: 1636412383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 153, date: 1636412683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 151, date: 1636412983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 143, date: 1636413283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 151, date: 1636413583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 159, date: 1636413883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 158, date: 1636414183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 158, date: 1636414483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 156, date: 1636414783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 156, date: 1636415082.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 156, date: 1636415383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 156, date: 1636415683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 157, date: 1636415983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 158, date: 1636416283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 161, date: 1636416583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 162, date: 1636416883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 163, date: 1636417183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 164, date: 1636417483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 163, date: 1636417783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 164, date: 1636418083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 167, date: 1636418383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 167, date: 1636418683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 164, date: 1636418983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 163, date: 1636419283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 162, date: 1636419582.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 164, date: 1636419883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 163, date: 1636420183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 161, date: 1636420483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 162, date: 1636420783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 161, date: 1636421083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 158, date: 1636421383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 155, date: 1636421683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 152, date: 1636421983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 149, date: 1636422283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 147, date: 1636422583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 146, date: 1636422883.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 142, date: 1636423182.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 139, date: 1636423483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 139, date: 1636423783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 144, date: 1636424083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 144, date: 1636424383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 142, date: 1636424683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 138, date: 1636424983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 126, date: 1636425283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 116, date: 1636425583.0, direction:  "FortyFiveDown", insulin:  "0"), Luna.ShareGlucoseData(sgv: 111, date: 1636425883.0, direction:  "FortyFiveDown", insulin:  "0"), Luna.ShareGlucoseData(sgv: 104, date: 1636426183.0, direction:  "FortyFiveDown", insulin:  "0"), Luna.ShareGlucoseData(sgv: 108, date: 1636426483.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 108, date: 1636426783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 107, date: 1636427083.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 106, date: 1636427383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 105, date: 1636427683.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 105, date: 1636427983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 109, date: 1636428283.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 123, date: 1636428583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 134, date: 1636428883.0, direction:  "FortyFiveUp", insulin:  "0"), Luna.ShareGlucoseData(sgv: 144, date: 1636429183.0, direction:  "FortyFiveUp", insulin:  "0"), Luna.ShareGlucoseData(sgv: 153, date: 1636429483.0, direction:  "FortyFiveUp", insulin:  "0"), Luna.ShareGlucoseData(sgv: 159, date: 1636429783.0, direction:  "FortyFiveUp", insulin:  "0"), Luna.ShareGlucoseData(sgv: 154, date: 1636430083.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 156, date: 1636430383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 156, date: 1636430683.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 158, date: 1636430983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 159, date: 1636431282.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 160, date: 1636431582.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 159, date: 1636431882.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 153, date: 1636432183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 150, date: 1636432483.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 148, date: 1636432783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 147, date: 1636433083.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 146, date: 1636433383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 146, date: 1636433683.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 147, date: 1636433983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 149, date: 1636434283.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 150, date: 1636434583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 155, date: 1636434883.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 158, date: 1636435183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 161, date: 1636435483.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 163, date: 1636435783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 168, date: 1636436083.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 175, date: 1636436383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 177, date: 1636436683.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 174, date: 1636436983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 171, date: 1636437283.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 169, date: 1636437583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 166, date: 1636437883.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 163, date: 1636438183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 159, date: 1636438483.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 158, date: 1636438783.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 157, date: 1636439083.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 151, date: 1636439383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 146, date: 1636439683.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 139, date: 1636439983.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 137, date: 1636440283.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 135, date: 1636440583.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 131, date: 1636440883.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 128, date: 1636441183.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 124, date: 1636441483.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 121, date: 1636441782.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 119, date: 1636442083.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 118, date: 1636442383.0, direction:  "Flat", insulin:  "0"), Luna.ShareGlucoseData(sgv: 118, date: 1636442683.0, direction: "Flat" , insulin:  "0"), Luna.ShareGlucoseData(sgv: 119, date: 1636442983.0, direction: "Flat", insulin: "0")]
    
    var newBGPulled = false
    var lastCalDate: Double = 0
    var latestDirectionString = ""
    var latestMinAgoString = ""
    var latestDeltaString = ""
    var topBG: Float = UserDefaultsRepository.minBGScale.value
    // share
    var bgDataShare: [ShareGlucoseData] = []
    var dexShare: ShareClient?;
    var dexVerifiedAlerted = false
    
    //
    var topSafeArea: CGFloat = 0.0
    var bottomSafeArea: CGFloat = 0.0
    lazy var swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(closePullUp))
    var fullView: CGFloat {
        return UIApplication.shared.statusBarHeight + 51.0
    }
    var partialView: CGFloat {
        return (textContainerHeight ?? 0.0) + UIApplication.shared.statusBarHeight + (110.5)
    }
    var textContainerHeight : CGFloat? {
        didSet{
            self.mainTableView.reloadData()
        }
    }
   
    //MARK:- VIEW LIFE CYCLE
    //======================
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.isMovingToParent else { return }
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainCotainerView.roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: 15)
        mainCotainerView.addShadowToTopOrBottom(location: .top, color: UIColor.black.withAlphaComponent(0.15))
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
            bottomSafeArea = view.safeAreaInsets.bottom
        }
    }
    
    private func cgmSetUp(){
        UserDefaultsRepository.infoNames.value.removeAll()
        // TODO: need non-us server ?
        let shareUserName = UserDefaultsRepository.shareUserName.value
        let sharePassword = UserDefaultsRepository.sharePassword.value
        let shareServer = UserDefaultsRepository.shareServer.value == "US" ?KnownShareServers.US.rawValue : KnownShareServers.NON_US.rawValue
        dexShare = ShareClient(username: shareUserName, password: sharePassword, shareServer: shareServer )
        self.newChartSetUp()
        // Trigger foreground and background functions
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        // Setup the Graph
        if firstGraphLoad {
            self.createGraph()
        }
        // Load Startup Data
        restartAllTimers()
    }
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    self.mainTableView.isScrollEnabled = false
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                    self.mainTableView.isScrollEnabled = true
                }
                
            }) { (completion) in
            }
        }
    }
    
    @objc func cgmDataReceivedSuccessfully(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
            if let bgData = dict[ApiKey.cgmData] as? [ShareGlucoseData]{
                self.bgData = bgData
                SystemInfoModel.shared.cgmData = bgData
                let shareUserName = UserDefaultsRepository.shareUserName.value
                let sharePassword = UserDefaultsRepository.sharePassword.value
                let shareServer = UserDefaultsRepository.shareServer.value == "US" ?KnownShareServers.US.rawValue : KnownShareServers.NON_US.rawValue
                dexShare = ShareClient(username: shareUserName, password: sharePassword, shareServer: shareServer )
                self.restartAllTimers()
            }
        }
    }
}

//MARK:- Private functions
//========================
extension BottomSheetVC {
    
    private func initialSetup() {
        setupTableView()
        addObserver()
        setupSwipeGesture()
        cgmSetUp()
    }
    
    private func setupTableView() {
        self.mainTableView.isScrollEnabled = true
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.registerCell(with: BottomSheetInsulinCell.self)
        self.mainTableView.registerCell(with: BottomSheetBottomCell.self)
        setupfooterView()
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(xAxisLabelsDuplicateValue), name: .XAxisLabelsDuplicateValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bleDidUpdateValue), name: .BleDidUpdateValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryUpdateValue), name: .BatteryUpdateValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reservoirUpdateValue), name: .ReservoirUpdateValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(statusUpdateValue), name: .StatusUpdateValue, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cgmDataReceivedSuccessfully), name: .cgmConnectedSuccessfully, object: nil)
    }
    
    @objc func xAxisLabelsDuplicateValue(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
                print(dict)
        }
        if let lastData = bgData.last{
            if lastData.date < dateTimeUtils.getNowTimeIntervalUTC() {
                bgData.removeFirst()
                bgData.append(ShareGlucoseData(sgv: lastData.sgv, date: lastData.date + 300.0, direction: lastData.direction ?? "", insulin: lastData.insulin ?? ""))
                self.updateBGGraph()
            }
        }
    }
    
    @objc func bleDidUpdateValue(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
                print(dict)
        }
        self.mainTableView.reloadData()
    }
    
    @objc func batteryUpdateValue(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
                print(dict)
        }
        self.mainTableView.reloadData()
        if BleManager.sharedInstance.reservoirLevelData != "-1" && Int(BleManager.sharedInstance.batteryData) ?? 0 < 75 && UserModel.main.isAlertsOn{
            var bodyText  = "Your Luna device is only "
            bodyText += BleManager.sharedInstance.batteryData
            bodyText += " % charged and may not last the entire session."
        self.persistentNotification(body: bodyText)
            return
        }
    }
    
    @objc func reservoirUpdateValue(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
                print(dict)
        }
        self.mainTableView.reloadData()
        if BleManager.sharedInstance.reservoirLevelData == "-1" && BleManager.sharedInstance.iobData >= 0.0  && UserModel.main.isAlertsOn{
            var bodyText  = "Your session has been completed and you have "
            bodyText += "\(BleManager.sharedInstance.iobData)"
            bodyText += " units of active Insulin On Board. Make sure to consider this before making any diabetes related decisions for the next 6 hours."
        self.persistentNotification(body: bodyText)
            return
        }
        
        if BleManager.sharedInstance.reservoirLevelData != "-1" && BleManager.sharedInstance.systemStatusData == "4"  && UserModel.main.isAlertsOn{
        self.persistentNotification(body: "Luna is not receiving CGM data. Check to see if your CGM is working and paired with Luna properly.")
            return
        }
        
        if BleManager.sharedInstance.reservoirLevelData != "-1" && Int(BleManager.sharedInstance.batteryData) ?? 0 <= 75  && UserModel.main.isAlertsOn{
            var bodyText  = "Your Luna device is only "
            bodyText += BleManager.sharedInstance.batteryData
            bodyText += " % charged and may not last the entire session."
            self.persistentNotification(body: bodyText)
            return
        }
        
        if BleManager.sharedInstance.reservoirLevelData == "0"  && UserModel.main.isAlertsOn {
        self.persistentNotification(body: "Luna has detected that there is no insulin in the Reservoir. Please discard this Reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
            return
        }
        
        if BleManager.sharedInstance.reservoirLevelData  != "-1" && BleManager.sharedInstance.systemStatusData == "1" && UserModel.main.isAlertsOn {
        self.persistentNotification(body: "Luna has detected an occlusion in the system. Please discard this reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
            return
        }
        
        if BleManager.sharedInstance.reservoirLevelData  != "-1" && BleManager.sharedInstance.systemStatusData != "1"  && BleManager.sharedInstance.systemStatusData != "0"  && BleManager.sharedInstance.systemStatusData != "4"  && UserModel.main.isAlertsOn{
        self.persistentNotification(body: "Luna has detected a failure in the system. Please check the dashboard on the App for more information. If the problem can’t be resolved, discard this Reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
            return
        }
    }
    
    @objc func statusUpdateValue(notification : NSNotification){
        if let dict = notification.object as? NSDictionary {
                print(dict)
        }
        self.mainTableView.reloadData()
        if BleManager.sharedInstance.reservoirLevelData != "-1" && BleManager.sharedInstance.systemStatusData == "4"  && UserModel.main.isAlertsOn{
        self.persistentNotification(body: "Luna is not receiving CGM data. Check to see if your CGM is working and paired with Luna properly.")
            return
        }
        
        if BleManager.sharedInstance.reservoirLevelData  != "-1" && BleManager.sharedInstance.systemStatusData == "1"   && UserModel.main.isAlertsOn {
        self.persistentNotification(body: "Luna has detected an occlusion in the system. Please discard this reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
            return
        }
        
        if BleManager.sharedInstance.reservoirLevelData  != "-1" && BleManager.sharedInstance.systemStatusData != "1"  && BleManager.sharedInstance.systemStatusData != "0"  && BleManager.sharedInstance.systemStatusData != "4"  && UserModel.main.isAlertsOn{
        self.persistentNotification(body: "Luna has detected a failure in the system. Please check the dashboard on the App for more information. If the problem can’t be resolved, discard this Reservoir and place the Luna Controller back on the Charger for 60 seconds to reset the device.")
            return
        }
    }
    
    private func setupfooterView(){
        let view = UIView.init(frame: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: self.view.frame.width, height: 100.0)))
        self.mainTableView.tableFooterView = view
    }
    
    private func setupSwipeGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(BottomSheetVC.panGesture))
        view.addGestureRecognizer(gesture)
        swipeDown.direction = .down
        swipeDown.delegate = self
        mainTableView.addGestureRecognizer(swipeDown)
    }
    
    @objc func closePullUp() {
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
        })
    }
    
    func rotateLeft(dropdownView: UIView,left: CGFloat = -1) {
        UIView.animate(withDuration: 1.0, animations: {
            dropdownView.transform = CGAffineTransform(rotationAngle: ((180.0 * CGFloat(Double.pi)) / 180.0) * CGFloat(left))
            self.view.layoutIfNeeded()
        })
    }
          
}

//MARK:- UITableViewDelegate
//========================
extension BottomSheetVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? (SystemInfoModel.shared.insulinData.endIndex) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueCell(with: BottomSheetInsulinCell.self, indexPath: indexPath)
            cell.populateCell()
            return cell
        case 1:
            let cell = tableView.dequeueCell(with: BottomSheetBottomCell.self, indexPath: indexPath)
            cell.topLineDashView.isHidden = indexPath.row == 0
            cell.populateCell(model:SystemInfoModel.shared.insulinData[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK:- Gesture Delegates
//========================
extension BottomSheetVC : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        //Identify gesture recognizer and return true else false.
        if (!mainTableView.isDragging && !mainTableView.isDecelerating) {
            return gestureRecognizer.isEqual(self.swipeDown) ? true : false
        }
        return false
    }
}

extension BottomSheetVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // This will be called every time the user scrolls the scroll view with their finger
        // so each time this is called, contentOffset should be different.
        if self.mainTableView.contentOffset.y < 0{
            self.mainTableView.isScrollEnabled = false
        } else if self.mainTableView.contentOffset.y == 0.0 {
            self.mainTableView.isScrollEnabled = false
        } else{
            self.mainTableView.isScrollEnabled = true
        }
        //Additional workaround here.
    }
}
