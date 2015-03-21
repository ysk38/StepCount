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
    
    let altimeter = CMAltimeter()
    
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var altitudeLabel: UILabel!
    
    

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
    }

}

