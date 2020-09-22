//
//  CardCollectionViewCell.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 12/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//
//  Referenced from CodeWithChris How to Build a Match Game

import UIKit

//Class that determines cards states in the UI
class CardCollectionViewCell: UICollectionViewCell {
    
    //Outlets
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    

var card:Card?
    
    func setCard(_ card:Card) {
        self.card = card
        
        //Setup the card appearance
        frontImageView.image = UIImage(named: card.cardName)
        backImageView.layer.cornerRadius=backImageView.frame.height/11
        frontImageView.layer.cornerRadius=frontImageView.frame.height/11

        //Card flip logic
        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
        }
        else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        if (card.isFlipped == false) {
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        else if (card.isFlipped == true) {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromTop, .showHideTransitionViews], completion: nil)
        }
    }
    //Turns card to show back image
    func flip(_ card:Card) {
        
        if (card.isFlipped == false) {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
            card.isFlipped = true
        }
    }
     //Turns card back to show front image in case of mismatch
    func flipBack(_ card:Card) {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            })
            
            card.isFlipped = false
            
    }
    
    //Remove cards from array if card match selected
    func remove() {
        
        self.backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
    }
    
}

