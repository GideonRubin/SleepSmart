//
//  Challenge+CoreDataProperties.swift
//  
//
//  Created by Gidi Rubin on 31/5/20.
//
//

import Foundation
import CoreData


extension Challenge {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Challenge> {
        return NSFetchRequest<Challenge>(entityName: "Challenge")
    }

    @NSManaged public var date: Date?
    @NSManaged public var hoursgoal: Int16
    @NSManaged public var length: Int16
    @NSManaged public var totalscore: Int16
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension Challenge {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: DailyTask)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: DailyTask)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
