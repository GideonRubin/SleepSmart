//
//  UIButtonExtensions.swift
//  SleepSmart
//
//  Created by Gidi Rubin, in reference to Ayaz Rahman's lab task
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit

//Creates default button styling
extension UIButton{
    func createDefaultButton(){
        layer.cornerRadius=frame.height/3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.05
    }
}
