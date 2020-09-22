//
//  CoreDataController.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 8/5/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//
// This controller class is responsible for the Coredata CRUD operations throughout the application

import UIKit
import CoreData

class CoreDataController: NSObject, DatabaseProtocol, NSFetchedResultsControllerDelegate {
    
    
    
    let DEFAULT_CHALLENGE_NAME = "Default Challenge"
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    // Fetched Results Controllers
    var DailyTaskFetchedResultsController: NSFetchedResultsController<DailyTask>?
    var ChallengeFetchedResultsController: NSFetchedResultsController<Challenge>?
    
    override init() {
        // Load the Core Data Stack
        persistentContainer = NSPersistentContainer(name: "SleepSmart")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        super.init()
        
        
        
    }
    
    // MARK: - Lazy Initization of Default Challenge
    lazy var defaultChallenge: Challenge = {
        var challenges = [Challenge]()
        let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", DEFAULT_CHALLENGE_NAME)
        request.predicate = predicate
        
        do {
            try challenges = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        
        if challenges.count == 0 {
            
            let currentDate = Date()
            
            //Default challenge values
            return addChallenge(date: currentDate, hoursgoal: 0, totalscore: 0, length: 0)
        }
        
        return challenges.first!
        
    }()
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
    }
    
    // MARK: - Database Protocol Functions
    
    func cleanup() {
        saveContext()
    }
    
    func addChallenge(date: Date?, hoursgoal: Int16,totalscore:Int16,length: Int16) -> Challenge {
        let challenge = NSEntityDescription.insertNewObject(forEntityName: "Challenge",
                                                            into: persistentContainer.viewContext) as! Challenge
        challenge.date = date
        challenge.hoursgoal = hoursgoal
        challenge.totalscore = totalscore
        challenge.length = length
        
        
        return challenge
    }
    
    
    
    func addDailyTask(hoursslept: Int16, memoryscore: Int16, taskdate: Date?, logicscore: Int16, dailytotalscore: Int16) -> DailyTask {
        let dailytask = NSEntityDescription.insertNewObject(forEntityName: "DailyTask",
                                                            into: persistentContainer.viewContext) as! DailyTask
        
        dailytask.hoursslept=hoursslept
        dailytask.memoryscore=memoryscore
        dailytask.taskdate=taskdate
        dailytask.logicscore=logicscore
        
        return dailytask
    }
    
    func addDailyTaskToChallenge(dailytask: DailyTask, challenge: Challenge) -> Bool {
        dailytask.addToChallenge(challenge)
        return true
    }
    
    func deleteDailyTask(dailytask: DailyTask) {
        persistentContainer.viewContext.delete(dailytask)
    }
    
    func deleteChallenge(challenge: Challenge) {
        persistentContainer.viewContext.delete(challenge)
        saveContext()
    }
    
    func removeDailyTaskFromChallenge(dailytask: DailyTask, challenge: Challenge) {
        dailytask.removeFromChallenge(challenge)
        saveContext()
    }
    
    
    
    // MARK: - Listeners
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .dailytask || listener.listenerType == .all {
            listener.onTasksChange(change: .update, dailyTasks: fetchAllDailyTasks())
            
        }
        if listener.listenerType == .challenge || listener.listenerType == .all{
            listener.onChallengeChange(change: .update, challenges: fetchChallenges())
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    // MARK: - Fetched Results Controller Protocol Functions
    
    func controllerDidChangeContent(_ controller:
        NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == DailyTaskFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .challenge || listener.listenerType == .all {
                    listener.onChallengeChange(change: .update, challenges: fetchChallenges())
                }
            }
        }
        
    }
    
    // MARK: - Core Data Fetch Requests
    
    func fetchAllDailyTasks() -> [DailyTask] {
        // If results controller not currently initialized
        if DailyTaskFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<DailyTask> = DailyTask.fetchRequest()
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "taskdate", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            // Initialize Results Controller
            DailyTaskFetchedResultsController =
                NSFetchedResultsController<DailyTask>(fetchRequest:
                    fetchRequest, managedObjectContext: persistentContainer.viewContext,
                                  sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            DailyTaskFetchedResultsController?.delegate = self
            
            do {
                try DailyTaskFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        var dailyTasks = [DailyTask]()
        if DailyTaskFetchedResultsController?.fetchedObjects != nil {
            dailyTasks = (DailyTaskFetchedResultsController?.fetchedObjects)!
        }
        
        return dailyTasks
    }
    
    
    func fetchChallenges() -> [Challenge] {
        // If results controller not currently initialized
        if ChallengeFetchedResultsController == nil {
            let request: NSFetchRequest<Challenge> = Challenge.fetchRequest()
            // Sort by name
            let nameSortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [nameSortDescriptor]
            // Initialize Results Controller
            ChallengeFetchedResultsController =
                NSFetchedResultsController<Challenge>(fetchRequest:
                    request, managedObjectContext: persistentContainer.viewContext,
                             sectionNameKeyPath: nil, cacheName: nil)
            // Set this class to be the results delegate
            ChallengeFetchedResultsController?.delegate = self
            
            do {
                try ChallengeFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request Failed: \(error)")
            }
        }
        
        var challenges = [Challenge]()
        if ChallengeFetchedResultsController?.fetchedObjects != nil {
            challenges = (ChallengeFetchedResultsController?.fetchedObjects)!
        }
        
        return challenges
    }
    
    
    
}
