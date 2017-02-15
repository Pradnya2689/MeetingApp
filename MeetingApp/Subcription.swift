//
//  Subcription.swift
//  MeetingApp
//
//  Created by Administrator on 14/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import Foundation
import Firebase
struct Subcription {
    
    var attendeeId: String?
    var empId: String?
    var isAttended: String?
    var isSubscribed:String?
    var meetingId:String?
    var key:String?
    var ref: FIRDatabaseReference?
    //var completed: Bool
    
    init(attendeeId: String, empId: String, isAttended: String, isSubscribed: String,meetingId:String,key:String){
        self.attendeeId = attendeeId
        self.empId = empId
        self.isAttended = isAttended
        self.isSubscribed = isSubscribed
        self.meetingId = meetingId
        self.key = key
        self.ref = nil
        
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        attendeeId = snapshotValue["attendeeId"] as? String
        empId = snapshotValue["empId"] as? String
        isAttended = snapshotValue["isAttended"] as? String
        isSubscribed = snapshotValue["isSubscribed"] as? String
        meetingId = snapshotValue["meetingId"] as? String
        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> NSDictionary {
        return [
            "attendeeId": attendeeId!,
            "empId": empId!,
            "isAttended":isAttended!,
            "isSubscribed":isSubscribed!,
            "meetingId":meetingId!
            
        ]
    }
    
    
}


