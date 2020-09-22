//
//  CustomDateFormt.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 26/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//
// These extensions methods allow for easier date processing throughout the application
// Based on https://stackoverflow.com/questions/35771506/is-there-a-date-only-no-time-class-in-swift-or-foundation-classes forum

import Foundation


extension Date {

    //Formats date in dd/mm/yy format
    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

    //Converts date to string
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
