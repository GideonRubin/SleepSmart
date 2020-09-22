//
//  String.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 11/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//  Referenced from Reinder de Vries 'Create An iOS Game With Swift In Xcode' tutorial
//

import Foundation

//Generates random number for the game
extension String
{
    static func randomNumber(length: Int) -> String
    {
        var result = ""
        
        for _ in 0..<length {
            let digit = Int.random(in: 0...9)
            result += "\(digit)"
        }
        
        return result
    }
    
    func integer(at n: Int) -> Int
    {
        let index = self.index(self.startIndex, offsetBy: n)

        return self[index].wholeNumberValue ?? 0
    }
    
    
    
}
