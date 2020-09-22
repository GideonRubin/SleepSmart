//
//  CustomNSSetExtension.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 4/6/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//
// Based on https://stackoverflow.com/questions/31100011/realmswift-convert-results-to-swift-array forum



import Foundation

//Casts NSSet to array of objects for easier iteration
extension NSSet {
    func toArray<T>() -> [T] {
        let array = self.map({ $0 as! T})
        return array
    }
}
