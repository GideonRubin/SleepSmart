//
//  MemoryGameController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 11/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
// Referenced from Reinder de Vries 'Create An iOS Game With Swift In Xcode' tutorial
//

import UIKit

// ViewController for logic game
class GameViewController: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    
    //Initialise UI data
    var score = 0
    var finalScore = 0
    var timer:Timer?
    var seconds = 25
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set labels
        updateScoreLabel()
        updateNumberLabel()
        updateTimeLabel()
    }
    
    //Set labels with scores and new numbers
    func updateScoreLabel() {
        scoreLabel?.text = String(score)
    }
    
    func updateNumberLabel() {
        numberLabel?.text = String.randomNumber(length: 4)
    }
    
    //Displays time remaining
    func updateTimeLabel() {
        
        let min = (seconds / 60) % 60
        let sec = seconds % 60
        
        timeLabel?.text = String(format: "%02d", min) + ":" + String(format: "%02d", sec)
    }
    
    func finishGame()
    {
        //Stops timer
        timer?.invalidate()
        timer = nil
        
        //Sets ending message
        var message = ""
        if(abs(score) != 1){
            message="You scored \(score) points."
        }
        else{
            message="You scored \(score) point."
        }
        let alert = UIAlertController(title: "Time's Up!", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Continue", style:  .default, handler: { (action) -> Void in
            
            //Persists score
            let defaults = UserDefaults.standard
            defaults.set(self.finalScore, forKey: "LogicScore")
            self.performSegue(withIdentifier: "showMemoryGame", sender: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        
        self.finalScore=self.score
        score = 0
        seconds = 10
        //Resets labels
        updateTimeLabel()
        updateScoreLabel()
        updateNumberLabel()
    }
    
    
    //Reads user input
    @IBAction func inputFieldDidChange(){
        guard let numberText = numberLabel?.text, let inputText = inputField?.text else {
            return
        }
        guard inputText.count == 4 else {
            return
        }
        var isCorrect = true
        
        for n in 0..<4
        {
            var input = inputText.integer(at: n)
            let number = numberText.integer(at: n)
            
            if input == 0 {
                input = 10
            }
            if input != number + 1 {
                isCorrect = false
                break
            }
        }
        //Updates score according to input
        if isCorrect {
            score += 1
        } else {
            score -= 1
        }
        
        updateNumberLabel()
        updateScoreLabel()
        inputField?.text = ""
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.seconds == 0 {
                    self.finishGame()
                } else if self.seconds <= 60 {
                    self.seconds -= 1
                    self.updateTimeLabel()
                }
            }
        }
        print(inputText)
    }
    
}
