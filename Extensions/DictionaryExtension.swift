//
//  DictionaryExtension.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 7/6/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//  Based on https://stackoverflow.com/questions/26728477/how-to-combine-two-dictionary-instances-in-swift forum

import Foundation

//Merges multiple dictionaries into one
extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
