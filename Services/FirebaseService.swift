//
//  Service.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 7/6/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//
// Referenced from https://firebase.google.com/docs/


import UIKit
import Firebase

//Firebase service for CRUD operations
class FirebaseService {
    
    //Post challenge to Firebase
    static func uploadChallenge (sleepAverage: Int16, totalScore: Int16, length: Int16){
        let userID : String = Auth.auth().currentUser!.uid
        let today = Date()
        let formatTodayDate = today.toString(dateFormat: "dd-MM")
        let dailyTaskDictionary : NSDictionary = ["SleepAverage " : String(sleepAverage)+" "+String(totalScore)]
        
        let ref = Database.database().reference(withPath: userID)
        let taskRef = ref.child(formatTodayDate+" "+String(length))
        taskRef.setValue(dailyTaskDictionary)
    }
    
    //Retrieves challenges from Firebase as a dictionary
    static func getChallenges() -> Dictionary<String,Any>{
        let userID : String = Auth.auth().currentUser!.uid
        let ref = Database.database().reference().child(userID)
        var myDict = Dictionary<String,Any>()
        ref.observe(.value, with: { (snapshot) in
            let userDict = snapshot.value as? Dictionary<String,Any>
            myDict.merge(dict: userDict!)
            //Do not cast print it directly may be score is Int not string
            
        }
        )
        return myDict
    }
    
    //Anonymous authentication with Firebase for identifying users within the NRDB objects
    static func fireBaseAnonAuth(){
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else { return }
            var isAnonymous = user.isAnonymous  // true
            var uid = user.uid
            var displayName = user.displayName
        }
    }
    
}
