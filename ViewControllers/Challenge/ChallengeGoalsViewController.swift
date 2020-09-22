//
//  ChallengeGoalsViewController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 25/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit
import Charts

// Initial landing page for beginning a new challenge
class ChallengeGoalsViewController: UIViewController , DatabaseListener{
    var listenerType: ListenerType = .all
    
    func onTasksChange(change: DatabaseChange, dailyTasks: [DailyTask]) {
        return
    }
    
    func onChallengeChange(change: DatabaseChange, challenges: [Challenge]) {
        return
    }
    
    // Outlets
    @IBOutlet weak var challengeLengthSlider: UISlider!
    
    @IBOutlet weak var challengeLength: UILabel!
    
    @IBOutlet weak var challengeHours: UILabel!
    
    
    @IBOutlet weak var challengeHoursSlider: UISlider!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var challengeHoursChart: PieChartView!
    
    
    weak var databaseController: DatabaseProtocol?
    
    
    // Initialised values for sliders and visualising chart
    var hours:Int = 7
    var dayHours:Int = 17
    var length:Int16 = 2
    
    var sleepHours = PieChartDataEntry(value: 7)
    var wakeHours = PieChartDataEntry(value: 17)
    
    var compareHours = [PieChartDataEntry]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        challengeLength.text=String(length)+" days"
        challengeHours.text=String(hours)+" hours"
        button.createDefaultButton()
        
        sleepHours.value=Double(hours)
        wakeHours.value=Double(dayHours)
        compareHours = [sleepHours,wakeHours]
        challengeHoursChart.drawEntryLabelsEnabled=false
        challengeHoursChart.holeColor = NSUIColor(named:"clearColor")
        challengeHoursChart.legend.enabled = false
        updateChartData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // Slider listeners
    
    //Listener for challenge length slider, setting label text accordingly
    @IBAction func lengthChange(_ sender: Any) {
        
        self.challengeLength.text=String(Int(challengeLengthSlider.value) )+" days"
        self.length=Int16(challengeLengthSlider.value)
    }
    
    //Listener for hours goal slider, setting label text accordingly
    @IBAction func hoursChange(_ sender: Any) {
        if(Int(challengeHoursSlider.value) > 0){
            self.hours=Int(challengeHoursSlider.value)
        }
        else{
            self.hours=2
        }
        
        self.challengeHours.text=String(round(2.0 * challengeHoursSlider.value) / 2.0)+" hours"
        
        sleepHours.value = Double(challengeHoursSlider.value)
        wakeHours.value = Double(24.0-challengeHoursSlider.value)
        updateChartData()
    }
    
    //Draws chart
    func updateChartData(){
        let chartDataSet = PieChartDataSet(entries: compareHours , label:nil)
        chartDataSet.drawValuesEnabled = false
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [UIColor(named:"PrimaryColor"),UIColor(named:"SecondaryColor")]
        chartDataSet.colors = colors as![NSUIColor]
        
        challengeHoursChart.data = chartData
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    @IBAction func buttonPress(_ sender: Any) {
        addChallenge()
        
    }
    
    //Adds new challenge to core data
    func addChallenge(){
        let todaysDate = Date().stripTime()
        let newChallenge = databaseController?.addChallenge(date: todaysDate, hoursgoal: Int16(self.hours), totalscore: 0, length: self.length)
        
    }
    
    
    
}
