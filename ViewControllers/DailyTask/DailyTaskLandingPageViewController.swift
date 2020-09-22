//
//  DailyTaskLandingPageViewController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 4/6/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit
import Charts

//Landing page for Daiy Task
class DailyTaskLandingPageViewController: UIViewController , DatabaseListener {
    
    //Database listeners
    var listenerType: ListenerType = .all
    
    func onTasksChange(change: DatabaseChange, dailyTasks: [DailyTask]) {
        return
    }
    
    func onChallengeChange(change: DatabaseChange, challenges: [Challenge]) {
        return
    }
    
    weak var databaseController: DatabaseProtocol?
    
    
    //Outlets
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var daysToGo: UILabel!
    @IBOutlet weak var lineChartView: LineChartView!
    
    
    
    var tasks : [DailyTask] = []
    var thisChallenge : Challenge?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        button.createDefaultButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Fetches challenge from core data
        databaseController?.addListener(listener: self)
        let challenges = databaseController?.fetchChallenges()
        let thisChallenge = challenges![challenges!.count-1]
        self.thisChallenge=thisChallenge
        self.tasks = (thisChallenge.tasks?.toArray())!
        let toGo = Int(thisChallenge.length) - Int(self.tasks.count)
        
        //Sets welcome message
        if toGo > 1{
            self.daysToGo.text = "You have \(toGo) days to go!"
        }
        else{
            self.daysToGo.text = "It is your last task for this challenge!"
        }
        setChartValues()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    //Creates a line chart of current challenge progress
    func setChartValues(){
        let tasks = self.tasks
        
        //Establishes chart data
        
        //Memory Scores
        let values = (0..<tasks.count).map{(i) -> ChartDataEntry in
            let val = Double(tasks[i].memoryscore)
            let index = Double(i)+1
            return ChartDataEntry (x: index, y: val)
        }
        //Logic Scores
        let values2 = (0..<tasks.count).map{(i) -> ChartDataEntry in
            let val = Double(tasks[i].logicscore)
            let index = Double(i)+1
            return ChartDataEntry (x: index, y: val)
        }
         //Hours slept
        let values3 = (0..<tasks.count).map{(i) -> ChartDataEntry in
            let val = Double(tasks[i].hoursslept)
            let index = Double(i)+1
            return ChartDataEntry (x: index, y: val)
        }
        //Hours goal
        let values4 = (0..<tasks.count).map{(i) -> ChartDataEntry in
            let val = Double(self.thisChallenge!.hoursgoal)
            let index = Double(i)+1
            return ChartDataEntry (x: index, y: val)
        }
        
        //Sets chart data
        let set1 = LineChartDataSet(entries: values, label: "Memory Scores")
        let set2 = LineChartDataSet(entries: values2,label:"Logic Scores")
        let set3 = LineChartDataSet(entries: values3, label: "Hours Slept")
        let set4 = LineChartDataSet(entries: values4, label: "Hours Goal")
        
        //Draws chart
        set1.fillColor = UIColor(named: "PrimaryColor") ?? UIColor.purple
        set1.setColor(UIColor(named: "PrimaryColor") ?? UIColor.purple)
        set1.setCircleColor(UIColor(named: "PrimaryColor") ?? UIColor.purple)
        set2.fillColor = UIColor(named: "SecondaryColor") ?? UIColor.orange
        set2.setCircleColor(UIColor(named: "SecondaryColor") ?? UIColor.orange)
        set2.setColor(UIColor(named: "SecondaryColor") ?? UIColor.orange)
        set3.fillColor = (UIColor.gray)
        set3.setCircleColor(UIColor.gray)
        set3.setColor(UIColor.gray)
        set4.fillColor = (UIColor.black)
        set4.setCircleColor(UIColor.black)
        set4.setColor(UIColor.black)
        let data = LineChartData(dataSet: set1)
        data.addDataSet(set2)
        data.addDataSet(set3)
        data.addDataSet(set4)
        self.lineChartView.data = data
        
    }
    
    //Segues to beginning of daily task
    @IBAction func buttonPress(_ sender: Any) {
        self.performSegue(withIdentifier: "showHoursSleptSegue", sender: self)
    }
}


