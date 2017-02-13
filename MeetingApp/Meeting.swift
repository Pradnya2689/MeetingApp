//
//  Meeting.swift
//  MeetingManagemnt
//
//  Created by pradnya on 30/01/17.
//  Copyright © 2017 pradnya. All rights reserved.
//

import Foundation
import Firebase
struct meetingItem {
   
  
    var key: String?
    var mdate: String?
    var mname: String?
    var mtimeend:String?
    var mtimestart : String?
    var mvenue : String?
    var mid:String?
    var meetingCode:String?
    var maxCount:String?
    var currentCount:String?
    var isexpired:String?
    var instructName:String?
    var instructempId:String?
     var meetingType:String?
    //var attendee:NSArray?
    
    var ref: FIRDatabaseReference?
    var completed: Bool
    
    init(mname: String, mdate: String, mtimestart: String, mtimeend: String, mvenue: String,mid: String,meetingCode: String, maxCount: String,currentCount: String,isexpired: String,instructName: String,instructempId: String,meetingType: String, completed: Bool, key: String = "") {
        self.key = key
        self.mname = mname
        self.mdate = mdate
        self.mid = mid
        self.mvenue = mvenue
        self.mtimestart = mtimestart
        self.mtimeend = mtimeend
        self.meetingCode = meetingCode
        self.maxCount = maxCount
        self.currentCount = currentCount
        self.isexpired = isexpired
        self.instructempId = instructempId
        self.instructName = instructName
        self.meetingType = meetingType
        self.completed = completed
        self.ref = nil
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
      
        let snapshotValue = snapshot.value as! [String: AnyObject]
        mname = snapshotValue["mname"] as? String
        mvenue = snapshotValue["mvenue"] as? String
         mdate = snapshotValue["mdate"] as? String
         mtimestart = snapshotValue["mstarttime"] as? String
         mtimeend = snapshotValue["mendtime"] as? String
         mid = snapshotValue["meetingID"] as? String
         meetingCode = snapshotValue["meetingCode"] as? String
         currentCount = snapshotValue["currentCount"] as? String
         instructName = snapshotValue["mInstuctorName"] as? String
         instructempId = snapshotValue["minstructorID"] as? String
         maxCount = snapshotValue["maxcount"] as? String
         isexpired = snapshotValue["isExpired"] as? String
        meetingType = snapshotValue["meetingType"] as? String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func fetchById(mid:String) {
        ref?.child("Meetings").queryOrdered(byChild: "meetingID").queryEqual(toValue: "2").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
            print(snapshot.value)
        }
//        let ref = FIRDatabase.database().referenceWithPath("Meetings").queryOrderByChild("meetingID").queryEqualToValue("1")
//        
//        ref.observeSingleEventOfType(.ChildAdded, block: { snapshot in
//            print(snapshot)
//        })
    }
    func toAnyObject() -> NSDictionary {
        return [
            "mname": mname!,
            "mvenue": mvenue!,
            "meetingID":mid!,
            "mdate":mdate!,
            "mendtime":mtimeend!,
            "mstarttime":mtimestart!,
            "meetingCode":meetingCode!,
            "currentCount":currentCount!,
            "mInstuctorName":instructName!,
            "minstructorID":instructempId!,
            "maxcount":maxCount!,
            "isExpired":isexpired!,
            "meetingType":meetingType!,
            "completed": completed
        ]
    }

    
}
