//
//  NewMeetingViewController.swift
//  MeetingApp
//
//  Created by Administrator on 01/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Firebase

class NewMeetingViewController: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate {

    @IBOutlet weak var newMeetScrollView: UIScrollView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var isCall : String!
    
    var datePickerView  : UIDatePicker = UIDatePicker()
    var timePickerView  : UIDatePicker = UIDatePicker()
    
    let check = UIImage(named: "checkBoxEnable")! as UIImage
    let uncheck = UIImage(named: "checkBoxDisable")! as UIImage
    
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var nameMeetingLb: UITextField!
    @IBOutlet weak var venueLb: UITextField!
    @IBOutlet weak var instructorNameLB: UITextField!
    @IBOutlet weak var instructorIDLb: UITextField!
    @IBOutlet weak var dateLb: UITextField!
    @IBOutlet weak var maxLb: UITextField!
    @IBOutlet weak var startTimeLb: UITextField!
    @IBOutlet weak var endTimeLb: UITextField!
    
    @IBOutlet weak var approveBtn: UIButton!
    @IBOutlet weak var selfSubcribeBtn: UIButton!
    @IBAction func newMeetingSubmitAction(_ sender: Any) {
        ref = FIRDatabase.database().reference()
        createMeeting()
    }
    @IBAction func selfSubAction(_ sender: Any) {
        
        if(selfSubcribeBtn.currentImage == uncheck){
            
            selfSubcribeBtn.setImage(check, for: .normal)
            approveBtn.setImage(uncheck, for: .normal)
            
        }else{
            
            selfSubcribeBtn.setImage(uncheck, for: .normal)
        }
    }
    @IBAction func adminApproveAction(_ sender: Any) {
        
        if(approveBtn.currentImage == uncheck){
            
            approveBtn.setImage(check, for: .normal)
            selfSubcribeBtn.setImage(uncheck, for: .normal)
            
        }else{
            
            approveBtn.setImage(uncheck, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitBtn.layer.cornerRadius = 5.0
        submitBtn.clipsToBounds = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func createMeeting() {
        
        let meetItem = meetingItem(mname: nameMeetingLb.text!, mdate: dateLb.text!, mtimestart: startTimeLb.text!, mtimeend: endTimeLb.text!, mvenue: venueLb.text!,mid: "2",meetingCode: "1235", maxCount: maxLb.text!,currentCount: "2",isexpired: "0",instructName: instructorNameLB.text!,instructempId: instructorIDLb.text!,meetingType: "0" ,completed: true, key: "")
        
        let groceryItemRef = ref.child("Meetings")
        
        groceryItemRef.childByAutoId().setValue(meetItem.toAnyObject())
        
        
    }

    
    func handleTap(gesture: UITapGestureRecognizer){
        nameMeetingLb.resignFirstResponder()
        venueLb.resignFirstResponder()
        instructorNameLB.resignFirstResponder()
        instructorIDLb.resignFirstResponder()
        dateLb.resignFirstResponder()
        maxLb.resignFirstResponder()
        startTimeLb.resignFirstResponder()
        endTimeLb.resignFirstResponder()
    }

    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if(textField == dateLb){
            
            
//            timePickerView.datePickerMode = UIDatePickerMode.time
//            startTimeLb.inputView = timePickerView
//            timePickerView.tag = 1
//            timePickerView.addTarget(self, action: #selector(self.onDidChangeTime), for: .valueChanged)
//            //textField.resignFirstResponder()
            
            datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
            dateLb.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(self.onDidChangeDate), for: .valueChanged)
            
            
        }
        
        
        
        if(textField == startTimeLb){
            
            
            timePickerView.datePickerMode = UIDatePickerMode.time
            startTimeLb.inputView = timePickerView
            timePickerView.tag = 1
            timePickerView.addTarget(self, action: #selector(self.onDidChangeTime), for: .valueChanged)
            //textField.resignFirstResponder()
        }
        
        if(textField == endTimeLb){
            
            
            timePickerView.datePickerMode = UIDatePickerMode.time
            endTimeLb.inputView = timePickerView
            timePickerView.tag = 2
            timePickerView.addTarget(self, action: #selector(self.onDidChangeTime), for: .valueChanged)
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {

       textField.resignFirstResponder()
        return true
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
        
        var contentInset:UIEdgeInsets = self.newMeetScrollView.contentInset
        contentInset.bottom = keyboardSize.height
        self.newMeetScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ notification: Notification) {
        self.newMeetScrollView.contentInset = UIEdgeInsets.zero
        self.newMeetScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Add Meeting"
        registerKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unregisterKeyboardNotifications()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func onDidChangeDate(sender: UIDatePicker) {
        
//        var dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMM yyyy"
//        dateLb.text = dateFormatter.string(from: sender.date)
        
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM dd, yyyy HH:mm a"
        
        let result = formatter.string(from: sender.date as Date)
       // var strDate = dateFormatter.string(from: sender.date)
        dateLb.text = result
       
    }
    
    func onDidChangeTime(sender: UIDatePicker) {
        
        
        if(sender.tag == 1){
            
            var dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            var strDate = dateFormatter.string(from: sender.date)
            startTimeLb.text = strDate
        }
        
        if(sender.tag == 2){
            var dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            // let dateAsString = "6:35 PM"
            // let dateFormatter = NSDateFormatter()
            //  dateFormatter.dateFormat = "h:mm a"
            //  let date = dateFormatter.dateFromString(dateAsString)
            
            dateFormatter.dateFormat = "HH:mm a"
            let date24 = dateFormatter.string(from: sender.date)
            endTimeLb.text = date24
        }
        
        
    }
    
    
    @IBAction func datePicker(_ sender: UITextField) {
        
        datePickerView.datePickerMode = UIDatePickerMode.dateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(self.onDidChangeDate), for: .valueChanged)
    }
    
    @IBAction func startTimePicker(_ sender: UITextField) {
        
        timePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = timePickerView
        timePickerView.addTarget(self, action: #selector(self.onDidChangeTime), for: .valueChanged)
    }
   
    @IBAction func endTimePicker(_ sender: UITextField) {
        
        timePickerView.datePickerMode = UIDatePickerMode.time
        sender.inputView = timePickerView
        timePickerView.addTarget(self, action: #selector(self.onDidChangeTime), for: .valueChanged)
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
