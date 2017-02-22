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
    var empID = UserDefaults.standard.value(forKey: "empID") as! String
    var isCall : String!
    
    var datePickerView  : UIDatePicker = UIDatePicker()
    var timePickerView  : UIDatePicker = UIDatePicker()
    
    let check = UIImage(named: "checkBoxEnable")! as UIImage
    let uncheck = UIImage(named: "checkBoxDisable")! as UIImage
    
    var meetType: String!
    
    var ref: FIRDatabaseReference!
    
    var editMeetingDataArray: FIRDataSnapshot!
    
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
    
    var meetID : String!
    
    @IBAction func newMeetingSubmitAction(_ sender: Any) {
        ref = FIRDatabase.database().reference()
        createMeeting()
    }
    @IBAction func selfSubAction(_ sender: Any) {
        
        if(selfSubcribeBtn.currentImage == uncheck){
            
            selfSubcribeBtn.setImage(check, for: .normal)
            approveBtn.setImage(uncheck, for: .normal)
            
            meetType = "0"
            
        }else{
            
            selfSubcribeBtn.setImage(uncheck, for: .normal)
            
            meetType = ""
        }
    }
    @IBAction func adminApproveAction(_ sender: Any) {
        
        if(approveBtn.currentImage == uncheck){
            
            approveBtn.setImage(check, for: .normal)
            selfSubcribeBtn.setImage(uncheck, for: .normal)
            
            meetType = "1"
            
        }else{
            
            approveBtn.setImage(uncheck, for: .normal)
            
            meetType = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        submitBtn.layer.cornerRadius = 5.0
        submitBtn.clipsToBounds = true
        
        
        if(isCall == "CellEditBtn"){
            
            print(editMeetingDataArray)
            
//            cell.nameLb.text = dict.childSnapshot(forPath: "mname").value as! String?
//            cell.instructorLb.text = "By \(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
//            cell.dateLb.text = "\(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
//            cell.venueLb.text = dict.childSnapshot(forPath: "mvenue").value as! String?
//            
            
            nameMeetingLb.text = editMeetingDataArray.childSnapshot(forPath: "mname").value as! String?
            venueLb.text = editMeetingDataArray.childSnapshot(forPath: "mvenue").value as! String?
            instructorNameLB.text = editMeetingDataArray.childSnapshot(forPath: "mInstuctorName").value as! String?
            instructorIDLb.text = editMeetingDataArray.childSnapshot(forPath: "minstructorID").value as! String?
            dateLb.text = editMeetingDataArray.childSnapshot(forPath: "mdate").value as! String?
            maxLb.text = editMeetingDataArray.childSnapshot(forPath: "maxcount").value as! String?
            endTimeLb.text = editMeetingDataArray.childSnapshot(forPath: "mendtime").value as! String?
            meetType = editMeetingDataArray.childSnapshot(forPath: "meetingType" ).value as! String?
              meetID = editMeetingDataArray.childSnapshot(forPath: "meetingID" ).value as! String?
            
            if(meetType == "0"){
                selfSubcribeBtn.setImage(check, for: .normal)
                approveBtn.setImage(uncheck, for: .normal)
            }else{
                selfSubcribeBtn.setImage(uncheck, for: .normal)
                approveBtn.setImage(check, for: .normal)
            }
            
        }else{
            
        }
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func createMeeting() {
        
          if(isCall == "CellEditBtn"){
          //  let groceryItemRef = ref.child("Meetings").childByAutoId()
            let usr = ref.child("Meetings").child(meetID)
           // print("key of tbl \(groceryItemRef.key)")
            let meetItem = meetingItem(mname: nameMeetingLb.text!, mdate: dateLb.text!, mtimestart: "", mtimeend: endTimeLb.text!, mvenue: venueLb.text!,mid: meetID,meetingCode: fourUniqueDigits, maxCount: maxLb.text!,currentCount: "",isexpired: "0",instructName: instructorNameLB.text!,instructempId: instructorIDLb.text!,meetingType: meetType ,completed: true, key: "")
            
            usr.setValue(meetItem.toAnyObject())
            let alert = UIAlertController(title: "Meeting is Edited", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action) -> Void in
                
                
                self.navigationController!.popViewController(animated: true)
                
                
            }))
            
            
            
            self.present(alert, animated: true, completion:{
                //Indicator.sharedInstance.stopActivityIndicator()
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(_:))))
            })
            
          }else{
        let groceryItemRef = ref.child("Meetings").childByAutoId()
        let usr = ref.child("Meetings").child(groceryItemRef.key)
        print("key of tbl \(groceryItemRef.key)")
        let meetItem = meetingItem(mname: nameMeetingLb.text!, mdate: dateLb.text!, mtimestart: "", mtimeend: endTimeLb.text!, mvenue: venueLb.text!,mid: groceryItemRef.key,meetingCode: fourUniqueDigits, maxCount: maxLb.text!,currentCount: "",isexpired: "0",instructName: instructorNameLB.text!,instructempId: instructorIDLb.text!,meetingType: meetType ,completed: true, key: "")
        
        usr.setValue(meetItem.toAnyObject())
            
            
            if(meetType == "1"){
                // let SubRef = ref.child("Subscriptions").childByAutoId()
                let meetID = groceryItemRef.key
                let key = "\(meetID)\(self.empID)"
              //  print("\(dict.childSnapshot(forPath: "meetingID").value as! String?)")
                
                let subcribe = Subcription(attendeeId:key,empId:self.empID,isAttended:"0",isSubscribed:"2",meetingId: meetID,key:"")
                
                let sub = ref.child("Subscriptions").child(key)
                sub.setValue(subcribe.toAnyObject())
            }else{
                
                let meetID = groceryItemRef.key
                let key = "\(meetID)\(self.empID)"
               // print("\(dict.childSnapshot(forPath: "meetingID").value as! String?)")
                let subcribe = Subcription(attendeeId:key,empId:self.empID,isAttended:"0",isSubscribed:"1",meetingId: meetID,key:"")
                let sub = ref.child("Subscriptions").child(key)
                sub.setValue(subcribe.toAnyObject())
                
            }

            
            let alert = UIAlertController(title: "Meeting added.", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                (action) -> Void in
                
                
                self.navigationController!.popViewController(animated: true)
                
                
            }))
            
            
            
            self.present(alert, animated: true, completion:{
                //Indicator.sharedInstance.stopActivityIndicator()
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(_:))))
            })
        }
        
       
    }
    
    
    func alertClose(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var fourUniqueDigits: String {
        var result = ""
        repeat {
            // create a string with up to 4 leading zeros with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
            // generate another random number if the set of characters count is less than four
        } while Set<Character>(result.characters).count < 4
        return result    // ran 5 times
    }
    
    func handleTap(gesture: UITapGestureRecognizer){
        nameMeetingLb.resignFirstResponder()
        venueLb.resignFirstResponder()
        instructorNameLB.resignFirstResponder()
        instructorIDLb.resignFirstResponder()
        dateLb.resignFirstResponder()
        maxLb.resignFirstResponder()
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
        
        formatter.dateFormat = "MMM dd, yyyy hh:mm a"
        
        let result = formatter.string(from: sender.date as Date)
       // var strDate = dateFormatter.string(from: sender.date)
        dateLb.text = result
       
    }
    
    func onDidChangeTime(sender: UIDatePicker) {
        
        
        if(sender.tag == 1){
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            var strDate = dateFormatter.string(from: sender.date)
            //startTimeLb.text = strDate
        }
        
        if(sender.tag == 2){
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            // let dateAsString = "6:35 PM"
            // let dateFormatter = NSDateFormatter()
            //  dateFormatter.dateFormat = "h:mm a"
            //  let date = dateFormatter.dateFromString(dateAsString)
            
            dateFormatter.dateFormat = "hh:mm a"
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
