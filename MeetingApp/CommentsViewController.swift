//
//  CommentsViewController.swift
//  MeetingApp
//
//  Created by Administrator on 03/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UIViewController {

    @IBOutlet weak var commentTV1: UITextView!
    @IBOutlet weak var commentTV2: UITextView!
    @IBOutlet weak var submitBTNComment: UIButton!
    var empID = UserDefaults.standard.value(forKey: "empID") as! String
    var ansArray = [Int]()
    var meetId : String!
    
    @IBAction func commentSubmitAction(_ sender: Any) {
         let sub = ref.child("FeedBacks").childByAutoId()
        
        let feedBack = Feedback(comment1: commentTV1.text, comment2: commentTV2.text, contentEffeciency: ansArray[0], encouragedInteraction: ansArray[1], feedbackId: sub.key, learningObjectives: ansArray[2], meetingID: meetId,overallFeedback: ansArray[4], valuableuseOfTime: ansArray[3], key:"",empId:empID)
        
       
        sub.setValue(feedBack.toAnyObject())
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "reportReview") as! AdminReportViewController
        secondViewController.isCalled = "User"
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.hidesBackButton = true
        
        print(ansArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Feedback"
        
        self.commentTV1!.layer.borderWidth = 1
        self.commentTV1!.layer.borderColor = UIColor.gray.cgColor
        
        self.commentTV2!.layer.borderWidth = 1
        self.commentTV2!.layer.borderColor = UIColor.gray.cgColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
