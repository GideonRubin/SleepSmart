//
//  DatabaseProtocol.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 8/5/20.
//  Referenced from Monash University FIT3178 Core Data Lab.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import Foundation
import CoreData

enum DatabaseChange {
    case add
    case remove
    case update
}

//Listeners for different core data object changes
enum ListenerType {
    case dailytask
    case challenge
    case all
}
protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    func onTasksChange(change: DatabaseChange, dailyTasks: [DailyTask])
    func onChallengeChange(change: DatabaseChange, challenges: [Challenge])
}
protocol DatabaseProtocol: AnyObject {
    var defaultChallenge: Challenge {get}
    
    //Coredata CRUD operations
    func cleanup()
    func addChallenge(date: Date?, hoursgoal: Int16,totalscore:Int16,length:Int16) -> Challenge
    func addDailyTask(hoursslept: Int16,memoryscore:Int16,taskdate:Date?,logicscore:Int16,dailytotalscore:Int16) -> DailyTask
    func addDailyTaskToChallenge(dailytask: DailyTask, challenge: Challenge) -> Bool
    func deleteDailyTask(dailytask: DailyTask)
    func deleteChallenge(challenge: Challenge)
    func removeDailyTaskFromChallenge(dailytask: DailyTask, challenge: Challenge)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func fetchChallenges() -> [Challenge]
}

