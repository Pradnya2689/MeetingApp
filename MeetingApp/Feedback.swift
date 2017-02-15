//
//  Feedback.swift
//  MeetingApp
//
//  Created by Administrator on 15/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import Foundation
import Firebase
struct Feedback {
    
    var comment1: String?
    var comment2: String?
    var contentEffeciency: Int?
    var encouragedInteraction:Int?
    var feedbackId: String?
    var learningObjectives: Int?
    var meetingID: String?
    var overallFeedback: Int?
    var valuableuseOfTime: Int?
    var key:String?
    var empId:String?
    var ref: FIRDatabaseReference?
    //var completed: Bool
    
    init(comment1: String, comment2: String, contentEffeciency: Int, encouragedInteraction: Int,feedbackId: String,learningObjectives: Int,meetingID: String,overallFeedback: Int,valuableuseOfTime: Int,key:String,empId:String){
        
         self.comment1 = comment1
         self.comment2 = comment2
         self.contentEffeciency = contentEffeciency
         self.encouragedInteraction = encouragedInteraction
         self.feedbackId = feedbackId
         self.learningObjectives = learningObjectives
         self.meetingID = meetingID
         self.overallFeedback = overallFeedback
         self.valuableuseOfTime = valuableuseOfTime
         self.key = key
        self.empId = empId
         self.ref = nil
        
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        comment1 = snapshotValue["comment1"] as? String
        comment2 = snapshotValue["comment2"] as? String
        contentEffeciency = snapshotValue["contentEffeciency"] as? Int
        encouragedInteraction = snapshotValue["encouragedInteraction"] as? Int
        empId = snapshotValue["empId"] as? String
        feedbackId = snapshotValue["feedbackId"] as? String
        learningObjectives = snapshotValue["learningObjectives"] as? Int
        meetingID = snapshotValue["meetingID"] as? String
        overallFeedback = snapshotValue["overallFeedback"] as? Int
        valuableuseOfTime = snapshotValue["valuableuseOfTime"] as? Int
        
        ref = snapshot.ref
    }
    
    func toAnyObject() -> NSDictionary {
        return [
            
            "comment1" : comment1!,
            "comment2" : comment2!,
            "contentEffeciency" : contentEffeciency!,
            "encouragedInteraction" : encouragedInteraction!,
            "empId" : empId!,
            "feedbackId" : feedbackId!,
            "learningObjectives" : learningObjectives!,
            "meetingID" : meetingID!,
            "overallFeedback" : overallFeedback!,
            "valuableuseOfTime" : valuableuseOfTime!
        ]
    }
    
    
}
