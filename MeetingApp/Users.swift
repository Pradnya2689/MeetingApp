//
//  Users.swift
//  MeetingApp
//
//  Created by pradnya on 03/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import Foundation
import Firebase
struct Users {
    
    var deviceToken: String?
    var empId: String?
    var isAdmin: String?
    var deviceType:String?
    var key:String?
    var ref: FIRDatabaseReference?
    //var completed: Bool
    
    init(deviceToken: String, empId: String, isAdmin: String, deviceType: String,key:String){
        self.deviceToken = deviceToken
        self.empId = empId
        self.isAdmin = isAdmin
        self.deviceType = deviceType
        self.key = key
        self.ref = nil
        
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        deviceToken = snapshotValue["deviceToken"] as? String
        empId = snapshotValue["empId"] as? String
        isAdmin = snapshotValue["isAdmin"] as? String
        deviceType = snapshotValue["deviceType"] as? String
      
        ref = snapshot.ref
    }
    
    func toAnyObject() -> NSDictionary {
        return [
            "deviceToken": deviceToken!,
            "empId": empId!,
            "isAdmin":isAdmin!,
            "deviceType":deviceType!,
            
        ]
    }
    
    
}
