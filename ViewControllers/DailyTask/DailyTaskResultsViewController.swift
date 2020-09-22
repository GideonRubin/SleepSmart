//
//  DailyTaskResultsViewController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 14/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit
import CoreData
import Firebase


// View controller that shows results of daily task
class DailyTaskResultsViewController: UIViewController , DatabaseListener{
    
    //Database listeners
    func onTasksChange(change: DatabaseChange, dailyTasks: [DailyTask]) {
        return
    }
    
    func onChallengeChange(change: DatabaseChange, challenges: [Challenge]) {
        return
    }
    
    var listenerType: ListenerType = .all
    
    
    func onChallengeChange(change: DatabaseChange, dailyTasks: [DailyTask]) {
    }
    
    
    //Outlets
    @IBOutlet weak var memoryScoreLabel: UILabel!
    @IBOutlet weak var logicScoreLabel: UILabel!
    @IBOutlet weak var hoursSleptLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var returnHomeButton: UIButton!
    @IBOutlet weak var hoursGoalLabel: UILabel!
    
    //Initialise scores
    var memoryScore:Int16=0
    var logicScore:Int16=0
    var hoursSlept:Int16=0
    var UID : String = ""
    
    //Copy to historyView
    var ref:DatabaseReference?
    var challengeData = [String]()
    
    weak var databaseController: DatabaseProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        //return button styling
        returnHomeButton.createDefaultButton()
        setLabels()
        
        ref = Database.database().reference()
        setFeedback()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    //Initialises values and labels of scores from activities from UserDefaults
    func setLabels(){
        let defaults = UserDefaults.standard
        self.memoryScore = Int16(defaults.integer(forKey: "MemoryScore"))
        self.logicScore = Int16(defaults.integer(forKey:"LogicScore"))
        self.hoursSlept = Int16(defaults.integer(forKey:"HoursSlept"))
        self.memoryScoreLabel.text=String(self.memoryScore)
        self.logicScoreLabel.text=String(self.logicScore)
        self.hoursSleptLabel.text=String(self.hoursSlept)
    }
    
    
    @IBAction func buttonPress(_ sender: Any) {
        addTask()
    }
    
    
    //Adds existing task to current challenge
    func addTask(){
        let todaysDate = Date().stripTime()
        
        //Fetches current challenge from core data
        let challenges = databaseController?.fetchChallenges()
        let thisChallenge = challenges![challenges!.count-1]
        let tasks = thisChallenge.tasks
        
        //Adds task to challenge
        if(self.logicScore == 0){self.logicScore = 1}
        if(self.memoryScore == 0){self.memoryScore = 1}
        let totalScore = Int16(self.logicScore+self.memoryScore)
        let thisTask = databaseController!.addDailyTask(hoursslept: self.hoursSlept, memoryscore: self.memoryScore, taskdate: todaysDate, logicscore: self.logicScore, dailytotalscore: totalScore)
        let _ = databaseController?.addDailyTaskToChallenge(dailytask: thisTask, challenge: thisChallenge)
        thisChallenge.totalscore+=totalScore
        
        //Sets daily task as completed, changing the landing page view controller to disabled until next day
        let today = Date()
        let formatTodayDate = today.toString(dateFormat: "dd-MM")
        let defaults = UserDefaults.standard
        defaults.set(formatTodayDate, forKey: "PreviousTask")
        
        if(thisChallenge.tasks!.count >= Int(thisChallenge.length)){
            self.performSegue(withIdentifier: "endChallengeSegue", sender: self)
        }
        else{
            self.view.window?.rootViewController?.dismiss(animated: true)
        }
    }
    
    //Sets feedback label based on relative performance to previous daily tasks
    func setFeedback(){
        
        let challenges = databaseController?.fetchChallenges()
        
        let thisChallenge = challenges![challenges!.count-1]
        self.hoursGoalLabel.text=String(thisChallenge.hoursgoal)
        let tasks = thisChallenge.tasks
        
        //Feedback for first task in challenge
        if tasks?.count==0{
            let fallshort:Int16 = self.hoursSlept-thisChallenge.hoursgoal
            var message = ""
            if(fallshort<0){
                message+="to get \(abs(fallshort)) more hours of sleep 🥱."
            }
            else if(fallshort>0){
                message+="to get \(fallshort) less hours of sleep 😴."
            }
            else if(fallshort==0){
                message+="to keep this record going 👑."
            }
            
            self.feedbackLabel.text="Good start, keep it up! Try \(message)"
        }
            
        //Feedback for second+ task in challenge
        else if (tasks!.count>0 && tasks!.count<thisChallenge.length){
            let fallshort:Int16 = self.hoursSlept-thisChallenge.hoursgoal
            var message = ""
            if(fallshort<0){
                message+="to get \(abs(fallshort)) more hours of sleep 🥱."
            }
            else if(fallshort>0){
                message+="to get \(fallshort) less hours of sleep 😴."
            }
            else if(fallshort==0){
                message+="to keep this record going 👑."
            }
            var allTasks = tasks!.allObjects as! [DailyTask]
            let lastTask = allTasks[0]
            let scoreDifference = (self.logicScore+self.memoryScore)-(lastTask.logicscore+lastTask.memoryscore)
            if(scoreDifference < 0){
                message+="You scored less than yesterday by \(abs(scoreDifference)) points. 👎"
            }
            else if(scoreDifference > 0){
                message+="You scored more than yesterday by \(scoreDifference) points. 👍"
            }
            else{
                message+="You scored the same as yesterday. 👍"
            }
            self.feedbackLabel.text="Welcome back, try \(message)"
        }
            
            
        else{
             //Feedback for final task in challenge
            self.feedbackLabel.text="Congrats for making it to the end 💪."
        }
        
    }
    
}


