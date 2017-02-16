//
//  CommentsViewController.swift
//  MeetingApp
//
//  Created by Administrator on 03/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Firebase

class CommentsViewController: UIViewController, UITextViewDelegate,UIGestureRecognizerDelegate {

    @IBOutlet weak var commentScrollView: UIScrollView!
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Feedback"
        
        self.commentTV1!.layer.borderWidth = 1
        self.commentTV1!.layer.borderColor = UIColor.gray.cgColor
        
        self.commentTV2!.layer.borderWidth = 1
        self.commentTV2!.layer.borderColor = UIColor.gray.cgColor
        
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = ""
        unregisterKeyboardNotifications()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func handleTap(gesture: UITapGestureRecognizer){
        
        commentTV1.resignFirstResponder()
        commentTV2.resignFirstResponder()
    }
    
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardDidShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
        //        let contentInsets = UIEdgeInsetsMake(0, 0, 200, 0)
        //        self.loginScrollView.contentInset = contentInsets
        //        self.loginScrollView.scrollIndicatorInsets = contentInsets
        
        var contentInset:UIEdgeInsets = self.commentScrollView.contentInset
        contentInset.bottom = keyboardSize.height
        self.commentScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.commentScrollView.contentInset = UIEdgeInsets.zero
        self.commentScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
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
