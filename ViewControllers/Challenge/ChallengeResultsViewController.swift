//
//  ChallengeResultsViewController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 4/6/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit
import Charts
import CoreData
import Firebase

// View of completed challenge results
class ChallengeResultsViewController: UIViewController, DatabaseListener  {
    
    // Database listeners
    func onTasksChange(change: DatabaseChange, dailyTasks: [DailyTask]) {
        return
    }
    
    func onChallengeChange(change: DatabaseChange, challenges: [Challenge]) {
    }
    
    // Outlets
    @IBOutlet weak var feedback: UILabel!
    @IBOutlet weak var hoursGoalDeviation: UILabel!
    @IBOutlet weak var cognitiveMemoryScore: UILabel!
    @IBOutlet weak var challengeChart: LineChartView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var hoursGoal: UILabel!
    
    
    var listenerType: ListenerType = .challenge
    
    weak var databaseController: DatabaseProtocol?
    var ref:DatabaseReference?
    
    // Initialise values for challenge details labels
    var tasks : [DailyTask] = []
    var avgHours : Int16 = 0
    var avgScore : Int16 = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        button.createDefaultButton()
        ref = Database.database().reference()
        setChartValues()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        // Initialise chart
        setChartValues()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    
    func setChartValues(_ count: Int = 20){
        // Fetches challenge details from core data
        let challenges = databaseController?.fetchChallenges()
        let thisChallenge = challenges![challenges!.count-1]
        self.hoursGoal.text = String(thisChallenge.hoursgoal)+" hours"
        
        let tasks : [DailyTask] = thisChallenge.tasks?.toArray() ?? []
        
        //Calculates and sets average hours and average scores from tasks in challenge
        var avgHoursArray:[Int16] = []
        
        for index in 0..<tasks.count{
            avgHoursArray.append(tasks[index].hoursslept)
        }
        let sumHoursArray = avgHoursArray.reduce(0, +)
        self.avgHours = sumHoursArray / Int16(avgHoursArray.count)
        
        self.avgScore = thisChallenge.totalscore
        self.avgScore = self.avgScore / Int16(thisChallenge.length)
        
        // Updates labels
        if self.avgScore>0{
            self.cognitiveMemoryScore.text=String(self.avgScore)+"0 points"
        }
        else{
            self.cognitiveMemoryScore.text=String(self.avgScore)+" points"
        }
        self.hoursGoalDeviation.text = String(self.avgHours)+" hours"
        
        // Establishes chart data
        //Memory scores
        let values = (0..<tasks.count).map{(i) -> ChartDataEntry in
            let val = Double(tasks[i].memoryscore)
            let index = Double(i)+1
            return ChartDataEntry (x: index, y: val)
        }
        //Logic scores
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
            let val = Double(thisChallenge.hoursgoal)
            let index = Double(i)+1
            return ChartDataEntry (x: index, y: val)
        }
        
        //Sets chart data
        let set1 = LineChartDataSet(entries: values, label: "Memory Scores")
        let set2 = LineChartDataSet(entries: values2,label: "Logic Scores")
        let set3 = LineChartDataSet(entries: values3, label: "Hours Slept")
        let set4 = LineChartDataSet(entries: values4, label: "Hours Goal")
        
        // Draws chart
        set1.fillColor = UIColor(named: "PrimaryColor") ?? UIColor.purple
        set1.setColor(UIColor(named: "PrimaryColor") ?? UIColor.purple)
        set1.setCircleColor(UIColor(named: "PrimaryColor") ?? UIColor.purple)
        set2.fillColor = UIColor(named: "SecondaryColor") ?? UIColor.orange
        set2.setCircleColor(UIColor(named: "SecondaryColor") ?? UIColor.orange)
        set2.setColor(UIColor(named: "SecondaryColor") ?? UIColor.orange)
        set3.fillColor = (UIColor.gray)
        set3.setCircleColor(UIColor.gray)
        set3.setColor(UIColor.gray)
        set4.fillColor = UIColor.black
        set4.setCircleColor(UIColor.black)
        set4.setColor(UIColor.black)
        let data = LineChartData(dataSet: set1)
        data.addDataSet(set2)
        data.addDataSet(set3)
        data.addDataSet(set4)
        
        self.challengeChart.data = data
        
    }
    
    func completeChallenge(){
        
        let challenges = databaseController?.fetchChallenges()
        let thisChallenge = challenges![challenges!.count-1]
        let tasks : [DailyTask] = thisChallenge.tasks?.toArray() ?? []
        
        //Removes current challenge / associated tasks from CoreData
        for dt in tasks{
            databaseController?.deleteDailyTask(dailytask: dt)
        }
        databaseController?.deleteChallenge(challenge:thisChallenge)
        
        // Posts challenge to firebase
        FirebaseService.uploadChallenge(sleepAverage: self.avgHours, totalScore: self.avgScore, length: Int16(tasks.count))
    }
    
    
    @IBAction func goHome(_ sender: Any) {
        completeChallenge()
        // Segues homea
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
}
