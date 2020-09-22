//
//  HoursSleptViewController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 14/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit

//View controller in daily task where a user reports hours slept
class HoursSleptViewController: UIViewController {
    
    //Initialise the slider value
    var hoursSlept:Int16=7
    
    //Outlets
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var hoursLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hoursLabel.text=String(Int16(slider.value))+" hours"
        button.createDefaultButton()
    }
    
    //Reads the slider for hours slept
    @IBAction func hoursSleptChanged(_ sender: Any) {
        self.hoursSlept=Int16(slider.value);
        if hoursSlept==1{
            hoursLabel.text="1 hour"
        }
        else if hoursSlept>1{
            hoursLabel.text=String(self.hoursSlept)+" hours"
        }
        
    }
    
    
    //Persists the hours slept
    @IBAction func buttonPress(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(self.hoursSlept, forKey: "HoursSlept")
        self.performSegue(withIdentifier: "logicGameSegue", sender: nil)
    }
    
}
