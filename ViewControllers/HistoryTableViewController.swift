//
//  HistoryTableViewController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 7/6/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit
import Firebase
import Charts

//View previous challenges and current progress
class HistoryTableViewController: UITableViewController,DatabaseListener {
    
    //Database listeners
    func onTasksChange(change: DatabaseChange, dailyTasks: [DailyTask]) {
        return
    }
    
    func onChallengeChange(change: DatabaseChange, challenges: [Challenge]) {
    }
    
    //Tableview values
    var values = Dictionary<String,Any>()
    let SECTION_INFO = 0
    let SECTION_MESSAGE = 1
    let SECTION_DATA = 2
    let CELL_INFO = "infoCell"
    let CELL_MESSAGE = "messageCell"
    let CELL_DATA = "challengeCell"
    
    var listenerType: ListenerType = .challenge
    weak var databaseController: DatabaseProtocol?
    //Arrays for TableView data
    var tasks : [DailyTask] = []
    var challenges : [Challenge] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        //Set up Firebase for CRUD operations
        configureFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        //Updates tableview content
        self.challenges = (databaseController?.fetchChallenges())!
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case SECTION_INFO:
            return 1
        case SECTION_MESSAGE:
            return 1
        case SECTION_DATA:
            return self.values.count
        default:
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Top section shows a graph view of current challenge progress
        if indexPath.section == SECTION_INFO{
            let infoCell =
                tableView.dequeueReusableCell(withIdentifier: CELL_INFO, for: indexPath) as! HistoryChartTableViewCell
            
            let challenges = self.challenges
            if challenges.count>0{
                let thisChallenge = challenges[challenges.count-1]
                let tasks : [DailyTask] = thisChallenge.tasks?.toArray() ?? []
                let values = (0..<tasks.count).map{(i) -> ChartDataEntry in
                    let val = Double(tasks[i].memoryscore)
                    let index = Double(i)+1
                    return ChartDataEntry (x: index, y: val)
                }
                let values2 = (0..<tasks.count).map{(i) -> ChartDataEntry in
                    let val = Double(tasks[i].logicscore)
                    let index = Double(i)+1
                    return ChartDataEntry (x: index, y: val)
                }
                
                let values3 = (0..<tasks.count).map{(i) -> ChartDataEntry in
                    let val = Double(tasks[i].hoursslept)
                    let index = Double(i)+1
                    return ChartDataEntry (x: index, y: val)
                }
                let set1 = LineChartDataSet(entries: values, label: "Memory Scores")
                let set2 = LineChartDataSet(entries: values2,label:"Logic Scores")
                let set3 = LineChartDataSet(entries: values3, label: "Hours Slept")
                set1.fillColor = UIColor(named: "PrimaryColor") ?? UIColor.purple
                set1.setColor(UIColor(named: "PrimaryColor") ?? UIColor.purple)
                set1.setCircleColor(UIColor(named: "PrimaryColor") ?? UIColor.purple)
                set2.fillColor = UIColor(named: "SecondaryColor") ?? UIColor.orange
                set2.setCircleColor(UIColor(named: "SecondaryColor") ?? UIColor.orange)
                set2.setColor(UIColor(named: "SecondaryColor") ?? UIColor.orange)
                set3.fillColor = (UIColor.gray)
                set3.setCircleColor(UIColor.gray)
                set3.setColor(UIColor.gray)
                let data = LineChartData(dataSet: set1)
                data.addDataSet(set2)
                data.addDataSet(set3)
                infoCell.challengeChart.data = data
                infoCell.titleLabel.text="Current challenge"
                infoCell.titleLabel.textColor=UIColor.label
            }
            else{
                infoCell.titleLabel.text="No existing challenge 🦄"
                infoCell.titleLabel.textColor=UIColor.gray
            }
            return infoCell
            
        }
            
        //This section shows a list of previous challenge data
        else if indexPath.section == SECTION_DATA {
            let messageCell =
                tableView.dequeueReusableCell(withIdentifier: CELL_DATA, for: indexPath) as! HistoryTableViewCell
            let challengeValues = Array(values.values)[indexPath.row] as! Dictionary<String,Any>
            let challengeDate = Array(values.keys)[indexPath.row]
            let hoursScore = Array(challengeValues)[0].value
            //            var date = Array(secondKey)[0].value
            let score = (hoursScore as! String).components(separatedBy: " ")
            let dateLength = (challengeDate ).components(separatedBy: " ")
            messageCell.dateText.text = "Avg hours of sleep: \(score[0])  Cognitive Score: \(score[1])"
            messageCell.hoursText.text = "Date completed: \(dateLength[0] ) Length: \(dateLength[1]) days"
            
            
            return messageCell
        }
        
         //This section introduces list of past challenges
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_MESSAGE, for: indexPath)
        
        if(self.values.count>1){
            
            cell.textLabel?.text="Average hours slept and total score for your \(self.values.count) past challenges:"
            cell.textLabel?.textColor=UIColor(named:"PrimaryColor")
        }
        else if(self.values.count == 1){
            
            cell.textLabel?.text="Average hours slept and total score for your \(self.values.count) past challenge:"
            cell.textLabel?.textColor=UIColor(named:"PrimaryColor")
        }
        else{
            cell.textLabel?.text="Previous challenges:"
        }
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        
        return cell
        
        
    }
    
    //Firebase set up
    func configureFirebase(){
        let defaults = UserDefaults.standard
        let myId = String(defaults.string(forKey: "nameLabel") ?? "myId")
        //Sets firebase id as namelabel from landing page if UID is currently unavailable.
        let userID : String = Auth.auth().currentUser?.uid ?? myId
        let ref = Database.database().reference().child(userID)
        let myDict = Dictionary<String,Any>()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let myDict=snapshot.value as? Dictionary<String,Any> else{
                return
            }
            //Sets tableview data based on retrieved history from firebase
            self.values=myDict
            self.tableView.reloadData()
        }
        )
        
    }
    
    
}
