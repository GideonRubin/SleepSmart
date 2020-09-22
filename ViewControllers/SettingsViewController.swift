//
//  SettingsViewController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 11/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit

//Settings tab view
class SettingsViewController: UIViewController , DatabaseListener{
    
    //Database listeners
    func onTasksChange(change: DatabaseChange, dailyTasks: [DailyTask]) {
        return
    }
    
    func onChallengeChange(change: DatabaseChange, challenges: [Challenge]) {
    }
    
    
    var listenerType: ListenerType = .challenge
    weak var databaseController: DatabaseProtocol?
    
    //Checks whether or not to notify
    var flag = false
    var hour = 0
    var minutes = 0
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var alertTime: UIDatePicker!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        notificationsSetUp()
        alertTime.datePickerMode = UIDatePicker.Mode.time
        button.createDefaultButton()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        let challenges = self.databaseController?.fetchChallenges()
        
        //Determines whether to allow a user to reset current Challenge
        if(challenges!.count==0){
            self.button.isEnabled = false
            self.button.backgroundColor = UIColor.gray
        }
        else{
            self.button.isEnabled = true
            self.button.backgroundColor = UIColor(named:"PrimaryColor")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    //Gets current time from datePicker
    @IBAction func getTime(_ sender: Any) {
        let date = alertTime.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minutes = components.minute!
        self.hour = hour
        self.minutes = minutes
    }
    
    //Toggle for whether or not to receive notifications
    @IBAction func toggled(_ sender: Any) {
        self.flag = !self.flag
        if self.flag==true{
            notificationsSetUp()
        }
        else{
              let center = UNUserNotificationCenter.current()
                  center.requestAuthorization(options: [.alert,.sound]){(granted,error) in
                  }
            center.removeAllPendingNotificationRequests()
        }
    }
  
    //Sets up notification content and timing
    func notificationsSetUp(){
        //Request permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound]){(granted,error) in
        }
        
        //Content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Sleep is for the strong!"
        notificationContent.body = "Keep track of your sleep cycle. Challenge yourself today."
        notificationContent.badge = NSNumber(value: 1)
        notificationContent.sound = .default
        
        //Sets time based on date picker view
        var datComp = DateComponents()
        datComp.hour = self.hour
        datComp.minute = self.minutes
        let trigger = UNCalendarNotificationTrigger(dateMatching: datComp, repeats: true)
        
        //Register Request
            let request = UNNotificationRequest(identifier: "ID", content: notificationContent, trigger: trigger)
            center.add(request) { (error : Error?) in
                if let theError = error {
                    print(theError as! String)
                }
            }
    }
    
    //Alert to confirm resetting challenge
    func alertControl(){
        let alert = UIAlertController(title: "Please confirm", message: "Are you sure you want to reset the current challenge?", preferredStyle: .alert)
        //Cancels request
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        //Sees request through by deleting current challenge from CoreData
        alert.addAction(UIAlertAction(title: "Yes", style:  .default, handler: { (action) -> Void in
            
            let challenges = self.databaseController?.fetchChallenges()
            let thisChallenge = challenges![challenges!.count-1]
            self.databaseController?.deleteChallenge(challenge: thisChallenge)
            //Disabled button after deleting current challenge
            self.button.isEnabled=false
            self.button.backgroundColor=UIColor.gray
            
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    
    //Resets current challenge
    @IBAction func resetChallenge(_ sender: Any) {
        alertControl()
    }
}
