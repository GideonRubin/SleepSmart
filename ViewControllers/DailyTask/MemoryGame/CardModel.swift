//
//  CardModel.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 12/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//  Referenced from CodeWithChris How to Build a Match Game

import Foundation

//Returns array of cards in random order
class CardModel{
      var randomArray = [Card]()
        
        func randomizeArr() -> [Card] {
            let randInt = arc4random_uniform(10) + 1
            
            for i in 1...11 {
                if (i == randInt) {
                    continue
                }
                else {
                    
                    //sets the front and back to the same random card value
                    let cardOne = Card()
                    cardOne.cardName = "card\(i)"
                    randomArray.append(cardOne)
                    let cardTwo = Card()
                    cardTwo.cardName = "card\(i)"
                    randomArray.append(cardTwo)
                }
            }
            
            randomArray = randomArray.shuffled()
            
            return randomArray
        }
    
}
