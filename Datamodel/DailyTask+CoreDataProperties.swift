//
//  DailyTask+CoreDataProperties.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 10/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//
//

import Foundation
import CoreData


extension DailyTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyTask> {
        return NSFetchRequest<DailyTask>(entityName: "DailyTask")
    }

    @NSManaged public var dailytotalscore: Int16
    @NSManaged public var hoursslept: Int16
    @NSManaged public var logicscore: Int16
    @NSManaged public var memoryscore: Int16
    @NSManaged public var taskdate: Date?
    @NSManaged public var challenge: NSSet?

}

// MARK: Generated accessors for challenge
extension DailyTask {

    @objc(addChallengeObject:)
    @NSManaged public func addToChallenge(_ value: Challenge)

    @objc(removeChallengeObject:)
    @NSManaged public func removeFromChallenge(_ value: Challenge)

    @objc(addChallenge:)
    @NSManaged public func addToChallenge(_ values: NSSet)

    @objc(removeChallenge:)
    @NSManaged public func removeFromChallenge(_ values: NSSet)

}
