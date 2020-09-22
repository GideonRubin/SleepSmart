//
//  MemoryViewController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 12/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//
//  Referenced from CodeWithChris How to Build a Match Game

import UIKit


//Memory Game View

class MemoryViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource{
    

    //Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    //Initialised memory game data
    var cards = CardModel()
    var randomizedArray = [Card]()
    var firstFlippedCard:IndexPath?
    var timer:Timer?
    var milliseconds:Double = 250
    var score:Int=0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Randomises card values
        randomizedArray = cards.randomizeArr()
        
        //Delegate view controller for collectionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.score=0
        scoreLabel.text=String(self.score)
        
        //Create a Timer
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(elapsedTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Disposes of any resources that can be recreated.
    }
    
    //  MARK: - Timer Methods
    
    @objc func elapsedTimer(){
        //Method that updates the view label
        milliseconds -= 1
        let seconds = String.init(format: "%2.f", milliseconds / 10)
        timerLabel.text = " \(seconds)"
        
        //Will stop at zero
        
        if milliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
        }
        
        // Check if game has ended
        
        checkIfGameEnded()
    }
    
    //  UIViewCollection Protocol Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomizedArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        let card = randomizedArray[indexPath.row]
        
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if milliseconds <= 0 {
            return
        }
        
        let card = randomizedArray[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        if card.isFlipped == false {
            cell.flip(card)
            if firstFlippedCard == nil {
                firstFlippedCard = indexPath
            }
            else {
                
                //      run match logic
                checkForMatches(indexPath)
                
            }
        }
    }
    
    //  Game logic methods
    func checkForMatches(_ secondFlippedCard:IndexPath) {
        
        // get cells and cards
        let cellOne = collectionView.cellForItem(at: firstFlippedCard!) as? CardCollectionViewCell
        let cellTwo = collectionView.cellForItem(at: secondFlippedCard) as? CardCollectionViewCell
        let cardOne = randomizedArray[firstFlippedCard!.row]
        let cardTwo = randomizedArray[secondFlippedCard.row]
        
        // Compares cards
        
        if cardOne.cardName == cardTwo.cardName {
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cellOne?.remove()
            cellTwo?.remove()
            
            self.score+=1
            print(score)
            self.scoreLabel.text=String(self.score)
            // Run logic to check if game has been won
            
            checkIfGameEnded()
            
        }
        else {
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            cellOne?.flipBack(cardOne)
            cellTwo?.flipBack(cardTwo)
            
        }
        
        // Checks if card is out of view and recycled
        if cellOne == nil {
            collectionView.reloadItems(at: [firstFlippedCard!])
        }
        
        firstFlippedCard = nil
    }
    
    func checkIfGameEnded(){
        
        var isWon:Bool = true
        var header = ""
        var message = ""
        
        for card in randomizedArray {
            
            if card.isMatched == false {
                
                isWon = false
                
                if milliseconds > 0 {
                    return
                }
                
                //Sets alert message
                    
                else {
                    header = "Times up!"
                    if(abs(self.score) != 1){
                        message="You scored \(self.score) points."
                    }
                    else{
                        message="You scored \(self.score) point."
                    }
                }
                
            }
        }
        if isWon == true {
            
            //Sets alert message
            
            header = "Times up!"
            if(abs(self.score) != 1){
                message="You scored \(self.score) points."
            }
            else{
                message="You scored \(self.score) point."
            }
        }
        
        alertUser(header, message)
        
    }
    
    // Alert displayed when a game is completed
    func alertUser(_ header:String, _ message:String) {
        
        let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style:  .default, handler: { (action) -> Void in
            
            //sets memoryscore as userdefaults
            let defaults = UserDefaults.standard
            defaults.set(self.score, forKey: "MemoryScore")
            print("from memory game: "+String(self.score))
            
            self.performSegue(withIdentifier: "dailyTaskResultsSegue", sender: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
}


