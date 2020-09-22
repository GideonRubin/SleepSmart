//
//  FirstViewController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 8/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit
import Firebase
import SAConfettiView
import UserNotifications


//Landing page for application
class FirstViewController: UIViewController, DatabaseListener{
    
    //Vars
    var listenerType: ListenerType = .challenge
    var newChallenge : Bool = false
    var segueDestination : String = ""
    var myChallenges : [Challenge] = []
    var confettiView : SAConfettiView?
    var finishedTask = 1
    weak var databaseController: DatabaseProtocol?
    var myVar : String = ""
    var values = Dictionary<String,Any>()
    
    //Database listeners
    func onTasksChange(change: DatabaseChange, dailyTasks: [DailyTask]) {
        return
    }
    
    func onChallengeChange(change: DatabaseChange, challenges: [Challenge]) {
        self.myChallenges = challenges
    }
    
    
    //Outlets
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Sets delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        let defaults = UserDefaults.standard
        let myString = defaults.string(forKey: "nameLabel")
        
        //Setting text labels
        if myString?.count==0{
            self.nameLabel.text="your name"
        }
        else{
        self.nameLabel.text=defaults.string(forKey: "nameLabel")
            
        }
        titleLabel.text="Welcome,"
        
        //Setting logo frame
        logo.layer.cornerRadius=logo.frame.height/2
        button.createDefaultButton()
        self.button.isEnabled = true
        self.button.backgroundColor = UIColor(named: "SecondaryColor")
        
        //Authenticate
        FirebaseService.fireBaseAnonAuth()
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        databaseController?.addListener(listener: self)
        //Rotate logo, initialise background animation
        rotateImage(image:self.logo)
        startConfetti()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        databaseController?.removeListener(listener: self)
        //stop background animation
        stopConfetti()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        button.createDefaultButton()
        self.button.isEnabled = true
        //Determine whether the status of the application state (new challenge, resume challenge or completed daily task)
        taskOrChallenge()
        
    }
    
    //Animate logo image
    func rotateImage(image: UIImageView) {
        UIView.animate(withDuration: 90, animations: {
            image.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            image.transform = CGAffineTransform.identity
        }) { (completed) in
            self.rotateImage(image: self.logo)
        }
    }
    
    //Edit user's name and persist
    @IBAction func editName(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        defaults.set(self.nameLabel.text, forKey:"nameLabel")
    }
    
    //Segue to destination based on application state
    @IBAction func buttonPress(_ sender: Any) {
        self.performSegue(withIdentifier: segueDestination, sender: nil)
    }
    
    //Background animation start and stop
    func startConfetti(){
        let confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.type = .Star
        self.view.insertSubview(confettiView, at: 0)
        self.confettiView=confettiView
        confettiView.intensity = 0.4
        confettiView.colors = [
            UIColor(hue: 0.7111, saturation: 0, brightness: 0.95, alpha: 1.0) /* #f2f2f2 */ /* #e5e5e5 */ /* #ffffff */]
        confettiView.startConfetti()
    }
    
    func stopConfetti(){
        confettiView?.stopConfetti()
    }
    
    
    //Determines application state and whether a user will resume challenge, start a new challenge or have the button disabled
    func taskOrChallenge(){
        
        let today = Date()
        let formatTodayDate = today.toString(dateFormat: "dd-MM")
        let defaults = UserDefaults.standard
        let previousTaskComplete = String(defaults.string(forKey: "PreviousTask") ?? "")
        
        //Set button based on application state
        if formatTodayDate == previousTaskComplete && self.myChallenges.count != 0{
            self.button.titleLabel?.font = .systemFont(ofSize: 12)
            self.button.setTitle("Today's task is complete!", for: .normal)
            self.button.backgroundColor=UIColor.gray
            self.button.isEnabled = false
        }
        else{
            if self.myChallenges.count == 0{
                self.button.setTitle("Start a Challenge", for: .normal)
                self.button.backgroundColor = UIColor(named: "SecondaryColor")
                self.segueDestination = "startChallengeSegue"
            }
            else{
                self.button.setTitle("Resume my Challenge", for: .normal)
                self.button.backgroundColor = UIColor(named: "SecondaryColor")
                self.segueDestination = "startTaskSegue"
                
            }
        }
    }
    
    
}

