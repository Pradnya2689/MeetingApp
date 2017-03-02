//
//  UserMeetingViewController.swift
//  MeetingApp
//
//  Created by Administrator on 03/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Firebase
import EventKit


class UserMeetingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{

    
    var eventStore = EKEventStore()
    @IBOutlet weak var userSegmentCntrl: UISegmentedControl!
    var empID = UserDefaults.standard.value(forKey: "empID") as! String
    @IBOutlet weak var userTableView: UITableView!
    
    let label = UILabel(frame: CGRect(x: (screenWidth-350)/2, y: (screenHeight-21)/2, width: 350, height: 21))
    
    @IBAction func userSegmntAction(_ sender: UISegmentedControl) {
      
         if(userSegmentCntrl.selectedSegmentIndex == 1){
//            fetchMyMeeting {
//                self.userTableView.reloadData()
//            }
        if(myMeetingName.count == 0){
          
                
                label.textAlignment = .center
            self.label.font = UIFont(name: "MyriadPro-Regular", size: 17.0)
               // label.text = "You have not subscribed for any meetings"
                label.text = "Not Subscribed"
                self.view.addSubview(label)
                self.view.bringSubview(toFront: label)
               // userTableView.isHidden = true
            self.userTableView.reloadData()

        }else{
            //userTableView.isHidden = false
            label.removeFromSuperview()
            self.userTableView.reloadData()
        }
         }else{
           // fetchAllData()
            if(allmeetingName.count == 0){
               
                    
                    label.textAlignment = .center
                self.label.font = UIFont(name: "MyriadPro-Regular", size: 17.0)
                    label.text = "No Meetings"
                    self.view.addSubview(label)
                    self.view.bringSubview(toFront: label)
                    //userTableView.isHidden = true
                self.userTableView.reloadData()
               
            }else{
               // userTableView.isHidden = false
                label.removeFromSuperview()
                self.userTableView.reloadData()
            }

        }
        
        if(userSegmentCntrl.selectedSegmentIndex == 1){
            Indicator.sharedInstance.startActivityIndicator()
            
                self.fetchMyMeeting(){
                   
                }
                
            
            
        }
//
       // userTableView.reloadData()
        //Indicator.sharedInstance.stopActivityIndicator()
    }
    
    var alertText: UITextField!
    
   
    func alertClose(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }

    var myMeetingName :[FIRDataSnapshot]! = [FIRDataSnapshot]()
    
    
    var allmeetingName :[FIRDataSnapshot]! = [FIRDataSnapshot]()
    //var myMeetingName :[FIRDataSnapshot]! = [FIRDataSnapshot]()
    
    var meetingIds : NSMutableArray = NSMutableArray()
    var isSubscribed : NSMutableArray = NSMutableArray()
    
    var instructorArray = [String]()
    var instructorArray1 = [String]()
    var venueArray = [String]()
    var venueArray1 = [String]()
    var dateArray = [String]()
    var dateArray1 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  ref = FIRDatabase.database().reference()
        
        navigationItem.hidesBackButton = true
        
        let leftItem = UIBarButtonItem(title: "Admin",
                                       style: .plain,
                                       target: self,
                                       action: #selector(self.nextView))
       // self.navigationItem.rightBarButtonItem = leftItem
        
       //alarmButtonClicked(sender: self)
        self.fetchMyMeeting(){
            self.fetchAllData()
            
        }
        print("emp id \(empID)")
      
    }
    
    func nextView(){
        
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "adminMeet") as! AdminMeetingsViewController
                self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Meetings"
       
        
       // self.userTableView.reloadData()
        self.userSegmentCntrl.translatesAutoresizingMaskIntoConstraints = true
        self.userSegmentCntrl.frame = CGRect(x: 5, y: 0, width: screenWidth-10, height: 32)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.title = ""
       // ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(userSegmentCntrl.selectedSegmentIndex == 0){
            return allmeetingName.count
        }else if(userSegmentCntrl.selectedSegmentIndex == 1){
            return myMeetingName.count
        }
        return 0
    }
    
    func fetchMyMeeting(finished: @escaping () -> Void)  {
        
        Indicator.sharedInstance.startActivityIndicator()
        myMeetingName.removeAll()
        // ref = FIRDatabase.database().reference()
        
        meetingIds.removeAllObjects()
        isSubscribed.removeAllObjects()
        
        //  self.addMyMeetings()
       // let  ref1 = FIRDatabase.database().reference()
        let filter1 = refr.child("Subscriptions").queryOrdered(byChild: "empId").queryEqual(toValue: empID)
        self.myMeetingName = [FIRDataSnapshot]()
        filter1.observe(.value, with: {snapshot in
            print(snapshot.value ?? "")
            
            if(snapshot.childrenCount == 0){
                Indicator.sharedInstance.stopActivityIndicator()
            }
            // loop through the children and append them to the new array
            for item in snapshot.children {
                let meetingID = (item as AnyObject).childSnapshot(forPath: "meetingId").value as! String?
                let subID = (item as AnyObject).childSnapshot(forPath: "isSubscribed").value as! String?
                let isattend = (item as AnyObject).childSnapshot(forPath: "isAttended").value as! String?
                
                print("meeting id ********\((item as AnyObject).childSnapshot(forPath: "meetingId").value as! String?)")
                self.meetingIds.add(meetingID!)
                self.isSubscribed.add(subID!)
                if(isattend != "1" ){
                    
                 //   let  ref2 = FIRDatabase.database().reference()
                   
                    let filter2 = refr.child("Meetings").queryOrdered(byChild: "meetingID").queryEqual(toValue: meetingID!)
                    
                    filter2.observe(.value, with: {snapshot in
                        //var newItems1 = [FIRDataSnapshot]()
                        
                        
                        for item1 in snapshot.children {
                            let isexpired = (item1 as AnyObject).childSnapshot(forPath: "isExpired").value as! String?
                            let instrID = (item1 as AnyObject).childSnapshot(forPath: "minstructorID").value as! String?
                            if(isexpired != "1" ){
                                
                                print("meeting id ******** \(item1,instrID)")
                                //if(instrID != self.empID)
                                //{
                                self.myMeetingName.append(item1 as! FIRDataSnapshot)
                                //newItems1.append(item1 as! FIRDataSnapshot)
                                //}
                            }
                        }
                        
                        //Indicator.sharedInstance.stopActivityIndicator()
                        self.userTableView.reloadData()
                    })
                }
            }
            
            Indicator.sharedInstance.stopActivityIndicator()
            self.userTableView.reloadData()
            finished()
        })
    }

    func fetchAllData(){
        
        allmeetingName.removeAll()
        userTableView.reloadData()
        //meetingIds.removeAllObjects()
        
        Indicator.sharedInstance.startActivityIndicator()
        
        
        // var allMeetingDict = NSMutableDictionary()
        
        let filter = refr.child("Meetings").queryOrdered(byChild: "isExpired").queryEqual(toValue: "0")
        filter.observe(.value , with: {snapshot in
            print(snapshot.value!)
            
            var newItems = [FIRDataSnapshot]()
            for item in snapshot.children {
                // let instrID = (item as AnyObject).childSnapshot(forPath: "minstructorID").value as! String?
                // if(instrID != self.empID){
                if(self.meetingIds.contains((item as AnyObject).childSnapshot(forPath: "meetingID").value as! String!)){
                    
                }else{
                    newItems.append(item as! FIRDataSnapshot)
                }
                //}
                
            }
            Indicator.sharedInstance.stopActivityIndicator()
            self.allmeetingName = newItems as? [FIRDataSnapshot]
            self.userTableView.reloadData()
            
            if(self.allmeetingName.count == 0){
                self.label.textAlignment = .center
                self.label.text = "No meetings"
                self.view.addSubview(self.label)
                self.view.bringSubview(toFront: self.label)
               self.userTableView.reloadData()
                
            }else{
                self.userTableView.isHidden = false
                self.label.removeFromSuperview()
                self.userTableView.reloadData()
            }
        })
        
        
    
        
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   //     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTable", for: indexPath) as! UserTableViewCell
        
        cell.subcribeBtn.layer.cornerRadius = 5.0
        cell.subcribeBtn.clipsToBounds = true
        
        cell.feedbackBtn.layer.cornerRadius = 5.0
        cell.feedbackBtn.clipsToBounds = true
        
        cell.meetingCodeBtn.layer.cornerRadius = 5.0
        cell.meetingCodeBtn.clipsToBounds = true
        
        cell.endMeetingBtn.layer.cornerRadius = 5.0
        cell.endMeetingBtn.clipsToBounds = true
        
      
        if(userSegmentCntrl.selectedSegmentIndex == 0){
            cell.subcribeBtn.isHidden = true
            let dict = allmeetingName[indexPath.row] as FIRDataSnapshot
            var cnt = (dict.childSnapshot(forPath: "currentCount").value as! String?)!
            
            var maxcnt = (dict.childSnapshot(forPath: "maxcount").value as! String?)!
            if(cnt == ""){
                cnt = "0"
            }
            var dif = Int(maxcnt)! - Int(cnt)!
            
            if(dict.childSnapshot(forPath: "meetingType").value as! String! == "1"){

                    if(dif > 0){
                         cell.seatAvaLB.text = "\(dif) seats"
                        cell.subcribeBtn.isHidden = false
                     
                    }else{
                         cell.seatAvaLB.text = "\(0) seats"
                        cell.subcribeBtn.isHidden = true
                    }
                    
                    cell.subcribeBtn.setTitle("Interest", for: .normal)
                    cell.subcribeBtn.tag = indexPath.row
                    cell.subcribeBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
                //}
            }else if(dict.childSnapshot(forPath: "meetingType").value as! String! == "0"){
            

                if(dif > 0){
                    cell.subcribeBtn.isHidden = false
                    cell.seatAvaLB.text = "\(dif) seats"
                 
                }else{
                    cell.subcribeBtn.isHidden = true
                    cell.seatAvaLB.text = "\(0) seats"
                }
              
                cell.subcribeBtn.setTitle("Subscribe", for: .normal)
                cell.subcribeBtn.tag = indexPath.row
                cell.subcribeBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
            //}
            }
            
            
            cell.userNameLB.text = dict.childSnapshot(forPath: "mname").value as! String?
            cell.instructLB.text = "\(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
            cell.dateLB.text = "\(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
            cell.venueLB.text = "\(dict.childSnapshot(forPath: "mvenue").value as! String)"
            
            
           
            cell.feedbackBtn.isHidden = true
            cell.meetingCodeBtn.isHidden = true
            cell.seatAvaLB.isHidden = false
            //cell.seatsLabel.isHidden = false
            cell.endMeetingBtn.isHidden = true
            cell.waitingForApprvBtn.isHidden = true
            
            
        }else{
            
            if(myMeetingName.count > 0){
            let dict = myMeetingName[indexPath.row] as FIRDataSnapshot
           
            let subid = isSubscribed[indexPath.row] as! String
            
            cell.feedbackBtn.isHidden = true
             cell.waitingForApprvBtn.isHidden = true
            

            let instrID = dict.childSnapshot(forPath: "minstructorID").value as? String
            if(instrID! == self.empID){
                cell.endMeetingBtn.isHidden = false
                cell.meetingCodeBtn.isHidden = false
                cell.endMeetingBtn.tag = indexPath.row
                cell.endMeetingBtn.addTarget(self, action: #selector(endcodeAction), for: .touchUpInside)
                cell.feedbackBtn.isHidden = true
                cell.meetingCodeBtn.tag = indexPath.row
                cell.meetingCodeBtn.addTarget(self, action: #selector(codeAction), for: .touchUpInside)
            }else if(instrID! != self.empID){
                //cell.feedbackBtn.isHidden = false
                cell.endMeetingBtn.isHidden = true
                cell.meetingCodeBtn.isHidden = true
                if(subid == "1" ){
                    cell.feedbackBtn.isHidden = false
                    cell.feedbackBtn.setTitle("Feedback", for: .normal)
                    cell.feedbackBtn.tag = indexPath.row
                    cell.feedbackBtn.addTarget(self, action: #selector(feedbackAction), for: .touchUpInside)
                     cell.waitingForApprvBtn.isHidden = true
                }else if(subid == "2"){
                    //cell.feedbackBtn.titleLabel?.text = "Waiting For Approval"
                    cell.feedbackBtn.isHidden = true
                    cell.waitingForApprvBtn.isHidden = false
                     cell.waitingForApprvBtn.setTitle("Waiting For Approval", for: .normal)
                }else if(subid == "3"){
                    //cell.feedbackBtn.titleLabel?.text = "Waiting For Approval"
                    cell.feedbackBtn.isHidden = true
                    cell.waitingForApprvBtn.isHidden = false
                     cell.waitingForApprvBtn.setTitle("Rejected by admin", for: .normal)
                }
            }
           
            cell.userNameLB.text = dict.childSnapshot(forPath: "mname").value as! String?
            cell.instructLB.text = "\(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
            cell.dateLB.text = "\(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
            cell.venueLB.text = "\(dict.childSnapshot(forPath: "mvenue").value as! String)"
            cell.subcribeBtn.isHidden = true
            cell.seatAvaLB.isHidden = true
          
        }
        }
        
        
        
    //}
    return cell
    }
    
   
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    
//        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
//        UIView.animate(withDuration: 0.3, animations: {
//            cell.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
//        },completion: nil)
//    }
    func updateCount(sender:Int){
       
       
        let dict = self.allmeetingName[sender] as FIRDataSnapshot
        var cnt = (dict.childSnapshot(forPath: "currentCount").value as! String?)!
        let maxcnt = (dict.childSnapshot(forPath: "maxcount").value as! String?)!
        if(cnt == ""){
            cnt = "0"
        }
        if(Int(cnt)! <= Int(maxcnt)!){
            let c = Int(cnt)! + 1 as Int
            let usr = refr.child("Meetings").child((dict.childSnapshot(forPath: "meetingID").value as! String?)!)
            // print("key of tbl \(groceryItemRef.key)")
            let meetItem = meetingItem(mname: (dict.childSnapshot(forPath: "mname").value as! String?)!, mdate: (dict.childSnapshot(forPath: "mdate").value as! String?)!, mtimestart: "", mtimeend: (dict.childSnapshot(forPath: "mendtime").value as! String?)!, mvenue: (dict.childSnapshot(forPath: "mvenue").value as! String?)!,mid: (dict.childSnapshot(forPath: "meetingID").value as! String?)!,meetingCode: (dict.childSnapshot(forPath: "meetingCode").value as! String?)!, maxCount: (dict.childSnapshot(forPath: "maxcount").value as! String?)!,currentCount: String(c),isexpired:(dict.childSnapshot(forPath: "isExpired").value as! String?)!,instructName: (dict.childSnapshot(forPath: "mInstuctorName").value as! String?)!,instructempId: (dict.childSnapshot(forPath: "minstructorID").value as! String?)!,meetingType: (dict.childSnapshot(forPath: "meetingType").value as! String?)! ,completed: true, key: "")
            
            usr.setValue(meetItem.toAnyObject())
        }else{
            
            
            
        }
        self.fetchMyMeeting(){
            self.fetchAllData()
            
        }
       
        
        
    }
    
    func subcribeAction(sender: UIButton){
    
        let alert = UIAlertController(title: "Do you want to Subscribe for this Meeting?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {
            (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            
            UIAlertAction in
            
            print(sender.tag)
            print(self.empID)
            
            if(self.userSegmentCntrl.selectedSegmentIndex == 0){
                let dict = self.allmeetingName[sender.tag] as FIRDataSnapshot
                if(dict.childSnapshot(forPath: "meetingType").value as! String? == "1"){
                    // let SubRef = ref.child("Subscriptions").childByAutoId()
                    let meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
                    let key = "\(meetID!)\(self.empID)"
                    print("\(dict.childSnapshot(forPath: "meetingID").value as! String?)")
                    
                     let subcribe = Subcription(attendeeId:key,empId:self.empID,isAttended:"0",isSubscribed:"2",meetingId: meetID!,key:"")
                    
                    let sub = refr.child("Subscriptions").child(key)
                    sub.setValue(subcribe.toAnyObject())
                }else{
                    
                    let meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
                    let key = "\(meetID!)\(self.empID)"
                    print("\(dict.childSnapshot(forPath: "meetingID").value as! String?)")
                    let subcribe = Subcription(attendeeId:key,empId:self.empID,isAttended:"0",isSubscribed:"1",meetingId: meetID!,key:"")
                    let sub = refr.child("Subscriptions").child(key)
                    sub.setValue(subcribe.toAnyObject())
                    
                }
                let meetname = dict.childSnapshot(forPath: "mname").value as! String
                let starttime = dict.childSnapshot(forPath: "mdate").value as! String
                let endtime = dict.childSnapshot(forPath: "mendtime").value as! String
                
                self.alarmButtonClicked(startTime: starttime, endTime: endtime, titleOfMeeting: meetname)
               
               self.updateCount(sender: sender.tag)
                
                
            }
            
        }))
        
        
        alert.view.tintColor = UIColor.black
        
        
        self.present(alert, animated: true, completion:{
            // Indicator.sharedInstance.stopActivityIndicator()
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(_:))))
        })

     
    }
    
    var meetingCode : String!
    func endcodeAction(sender: UIButton){
         let dict = self.myMeetingName[sender.tag] as FIRDataSnapshot
        let usr = refr.child("Meetings").child((dict.childSnapshot(forPath: "meetingID").value as! String?)!)
        
        let meetItem = meetingItem(mname: (dict.childSnapshot(forPath: "mname").value as! String?)!, mdate: (dict.childSnapshot(forPath: "mdate").value as! String?)!, mtimestart: "", mtimeend: (dict.childSnapshot(forPath: "mendtime").value as! String?)!, mvenue: (dict.childSnapshot(forPath: "mvenue").value as! String?)!,mid: (dict.childSnapshot(forPath: "meetingID").value as! String?)!,meetingCode: (dict.childSnapshot(forPath: "meetingCode").value as! String?)!, maxCount: (dict.childSnapshot(forPath: "maxcount").value as! String?)!,currentCount: (dict.childSnapshot(forPath: "currentCount").value as! String?)!,isexpired:"1",instructName: (dict.childSnapshot(forPath: "mInstuctorName").value as! String?)!,instructempId: (dict.childSnapshot(forPath: "minstructorID").value as! String?)!,meetingType: (dict.childSnapshot(forPath: "meetingType").value as! String?)! ,completed: true, key: "")
        
        usr.setValue(meetItem.toAnyObject())
        fetchMyMeeting(){
            
        }
    }
    func codeAction(sender: UIButton){
        let dict = self.myMeetingName[sender.tag] as FIRDataSnapshot
        let meetID = dict.childSnapshot(forPath: "meetingCode").value as! String?
         let alert = UIAlertController(title: "Your Meeting Code is \(meetID!)", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
            (action) -> Void in
             }))
        self.present(alert, animated: true, completion:{
            //Indicator.sharedInstance.stopActivityIndicator()
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(_:))))
        })
    }
    
    func feedbackAction(sender: UIButton){
        
        let alert = UIAlertController(title: "Enter Meeting Code", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField{
            (textField) -> Void in
            
            self.alertText = alert.textFields![0]
            self.alertText.delegate = self
            self.alertText.autocapitalizationType = UITextAutocapitalizationType.words
            self.alertText.keyboardType = UIKeyboardType.numberPad
            self.alertText.returnKeyType = UIReturnKeyType.done

        }
        
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {
            (action) -> Void in
            
            let code = alert.textFields![0].text
            self.meetingCode = code
           
            if(self.meetingCode == ""){
                
               self.showAlert(Message: "Enter Meeting Code")
                
            }else{
                
                let dict = self.myMeetingName[sender.tag] as FIRDataSnapshot
                let meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
                let alrttxt = self.alertText.text
                let meetingCode = dict.childSnapshot(forPath: "meetingCode").value as! String?
                let subid = self.isSubscribed[sender.tag] as! String
                if(alrttxt == meetingCode){
                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "feedBack") as! FeedbackViewController
                    secondViewController.meetingID = meetID
                    secondViewController.isSubscribed = subid
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                }else{
                    self.dismiss(animated: false, completion: nil)
                    let alert = UIAlertController(title: "Invalid Meeting code", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                        (action) -> Void in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                
            }
            
//            if(self.meetingCode != ""){
//            
//            let dict = self.myMeetingName[sender.tag] as FIRDataSnapshot
//            let meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
//            let alrttxt = self.alertText.text
//             let meetingCode = dict.childSnapshot(forPath: "meetingCode").value as! String?
//                let subid = self.isSubscribed[sender.tag] as! String
//                if(alrttxt == meetingCode){
//                    let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "feedBack") as! FeedbackViewController
//                    secondViewController.meetingID = meetID
//                    secondViewController.isSubscribed = subid
//                    self.navigationController?.pushViewController(secondViewController, animated: true)
//                }else{
//                    self.dismiss(animated: false, completion: nil)
//                     let alert = UIAlertController(title: "Invalid Meeting code", message: "", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
//                        (action) -> Void in
//                        
//                    }))
//                    self.present(alert, animated: true, completion: nil)
//                    
//                }
//            
//                
//            }else{
//                
//                self.showAlert(Message: "Enter Meeting Code")
//            }
            
        }))
        
        
        
        self.present(alert, animated: true, completion:{
            //Indicator.sharedInstance.stopActivityIndicator()
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(_:))))
        })
        
    }
    
    func showAlert(Message: String)
    {
        let alert = UIAlertController(title:"Meeting App", message:Message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = self.alertText.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 4
    }
    func reminderIsAlreadyAdded()->Void {
        let alert:UIAlertController = UIAlertController(title:"Auctionteer", message: "This alarm has already added to the reminder", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
        self.present(alert, animated: true, completion:nil)
    }
    func alarmButtonClicked(startTime:String,endTime:String,titleOfMeeting:String) {
        print("Alarm Event add")
        
        self.eventStore = EKEventStore()
        
        EKEventStore().requestAccess(to: EKEntityType.event, completion: {
            (success: Bool, error: Error?) in
            
            if success{
                 //self.addAlarmToReminder()
                let calendars = self.eventStore.calendars(for: EKEntityType.event)
                
                
                for calendar in calendars {
                    print(calendars)
                    if calendar.title == "Calendar" {
                    let formatter = DateFormatter()
                    
                    formatter.dateFormat = "MMM dd, yyyy HH:mm"
                    let startDatetm = formatter.date(from: startTime)
                    //print(startDate)
                    let arry = startTime.components(separatedBy: " ")
                    let endstr = "\(arry[0]) \(arry[1]) \(arry[2]) \(endTime)"
                    
                    print(endstr)
                    let datformatter = DateFormatter()
                    
                    datformatter.dateFormat = "MMM dd, yyyy HH:mm"
                    let startDate = datformatter.date(from: endstr)
                    print(startDate!)
                    var event = EKEvent(eventStore: self.eventStore)
                    event.calendar = calendar
                    print(Date())
                    event.title = titleOfMeeting
                    event.startDate = startDatetm! as Date
                    event.endDate = startDate! as Date
                    event.calendar = self.eventStore.defaultCalendarForNewEvents
                   
                    let alarm:EKAlarm = EKAlarm(relativeOffset: -900)
                    event.alarms = [alarm]
                   // print("start date \(endTime) end date \(endDate1)")
                   
                    do {
                        try self.eventStore.save(event, span: EKSpan.thisEvent, commit: true)
                        
                    }
                        
                    catch let error {
                        print("Event failed with error \(error.localizedDescription)")
                    }
                
                    }
                }

               
            }else{
                print("The app is not permitted to access reminders, make sure to grant permission in the settings and try again")
            }
        })
        
    }
    func addAlarmToReminder() -> Void {
        
       
               // }
        
       
    }
    func requestAccess(to entityType: EKEntityType, completion: @escaping EventKit.EKEventStoreRequestAccessCompletionHandler){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        cell.separatorInset = UIEdgeInsets.zero
//        cell.layoutMargins = UIEdgeInsets.zero
//        
//        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
//        UIView.animate(withDuration: 0.25, animations: {
//             cell.layer.transform = CATransform3DMakeScale(1,1,1)
//        })
//        
////        UIView.animateWithDuration(0.25, animations: {
////            
////            cell.layer.transform = CATransform3DMakeScale(1,1,1)
////        })
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
