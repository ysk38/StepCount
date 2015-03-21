//
//  ViewController.swift
//  StepCount
//
//  Created by YUSUKE on 2014/12/23.
//  Copyright (c) 2014年 YUSUKE. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let altimeter:CMAltimeter = CMAltimeter()
    let pedmeter:CMPedometer = CMPedometer()
    
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var altitudeLabel: UILabel!
    @IBOutlet var steps: UILabel!
    @IBOutlet var distance: UILabel!
    @IBOutlet var floorsascended: UILabel!
    @IBOutlet var floorsdescended: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        startUpdate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 取得開始
    func startUpdate(){
        self.pressureLabel.text = "Pressure: ---- hPa"
        self.altitudeLabel.text = "Height: -.-- m"
        
        if (CMAltimeter.isRelativeAltitudeAvailable()) {
            altimeter.startRelativeAltitudeUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler:
                {data, error in
                    if error == nil {
                        let pressure = data.pressure.doubleValue
                        let altitude = data.relativeAltitude.doubleValue
                        self.pressureLabel.text = String(format: "Pressure: %.1f hPa", pressure*10)
                        self.altitudeLabel.text = String(format: "Height: %.2f m", altitude)
                    }
                })
        } else {
            println("not use altimeter")
        }
        
        let now:NSDate = NSDate();
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var from:NSDate = self.stringToDate(formatter.stringFromDate(now), isStart: true)
        
        if (CMPedometer.isFloorCountingAvailable()) {
//            pedmeter.queryPedometerDataFromDate(from, toDate: now, withHandler: { (pedometerData:CMPedometerData!, error:NSError!) -> Void in
//                self.steps.text = String(format: "Steps: %d", pedometerData.numberOfSteps.integerValue)
//                self.distance.text = String(format: "Distance: %.3f", pedometerData.distance.doubleValue)
//                self.floorsascended.text = String(format: "FloorsAscended: %d", pedometerData.floorsAscended.integerValue)
//                self.floorsdescended.text = String(format: "FloorsDescended: %d", pedometerData.floorsDescended.integerValue)
//            })
            
            pedmeter.startPedometerUpdatesFromDate(from, withHandler: { (pedometerData:CMPedometerData!, error:NSError!) -> Void in
                self.steps.text = String(format: "Steps: %d", pedometerData.numberOfSteps.integerValue)
                self.distance.text = String(format: "Distance: %.3f", pedometerData.distance.doubleValue)
                self.floorsascended.text = String(format: "FloorsAscended: %d", pedometerData.floorsAscended.integerValue)
                self.floorsdescended.text = String(format: "FloorsDescended: %d", pedometerData.floorsDescended.integerValue)
            })
            
        }
        
        
    }

    
    private func stringToDate(date: String, isStart: Bool) -> NSDate {
        let timestamp = (isStart) ? date + " 00:00:00" : date + " 23:59:59"
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.dateFromString(timestamp)!
    }
}

