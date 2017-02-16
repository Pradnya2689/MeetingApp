//
//  UserMeetingViewController.swift
//  MeetingApp
//
//  Created by Administrator on 03/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Firebase

class UserMeetingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{

    @IBOutlet weak var userSegmentCntrl: UISegmentedControl!
    var empID = UserDefaults.standard.value(forKey: "empID") as! String
    @IBOutlet weak var userTableView: UITableView!
    @IBAction func userSegmntAction(_ sender: UISegmentedControl) {
        
        userTableView.reloadData()
    }
    
    var alertText: UITextField!
    
    
    
    @IBAction func feedBackAction(_ sender: Any) {
        
        var alert = UIAlertController(title: "Enter Meeting Code", message: "", preferredStyle: UIAlertControllerStyle.alert)

        alert.addTextField{
            (textField) -> Void in
            
            self.alertText = alert.textFields![0]
            self.alertText.delegate = self
            self.alertText.autocapitalizationType = UITextAutocapitalizationType.words
        }
        
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {
            (action) -> Void in
            
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "feedBack") as! FeedbackViewController
            self.navigationController?.pushViewController(secondViewController, animated: true)
            
        }))
        
        
        
        self.present(alert, animated: true, completion:{
            //Indicator.sharedInstance.stopActivityIndicator()
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(_:))))
        })
    }
    
    func alertClose(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    var allmeetingName = [String]()
    var myMeetingName  = [FIRDataSnapshot]()
    
    
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
        
//        allmeetingName = ["Meeting2","Meeting3","Meeting5","Meeting6"]
//        instructorArray = ["by John Miller","by Kate Smith","by Brain Hamilton","by Henry Pitt","by Daisy Steel"]
//        venueArray = ["Datsun","Galaxy","Earth","Venus"]
//        dateArray = ["6thFeb 3:00 PM-4:30 PM","7thFeb 10:00 PM-12:30 PM","7thFeb 5:00 PM-6:00 PM","8thFeb 5:00 PM-6:00 PM"]
//        
        //myMeetingName = ["Meeting1","Meeting4","Meeting7"]
        instructorArray1 = ["by Kate Smith","by John Miller","by Daisy Steel"]
        venueArray1 = ["Jupiter","Venus","Datsun"]
        dateArray1 = ["7thFeb 10:00 PM-12:30 PM","8thFeb 5:00 PM-6:00 PM","9thFeb 5:00 PM-6:00 PM"]
        
        
        navigationItem.hidesBackButton = true
        
        let leftItem = UIBarButtonItem(title: "Admin",
                                       style: .plain,
                                       target: self,
                                       action: #selector(self.nextView))
        self.navigationItem.rightBarButtonItem = leftItem
        
       
        
        print("emp id \(empID)")
      
    }
    
    func nextView(){
        
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "adminMeet") as! AdminMeetingsViewController
                self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Meetings"
        fetchAllData()
        self.userTableView.reloadData()
        self.userSegmentCntrl.translatesAutoresizingMaskIntoConstraints = true
        self.userSegmentCntrl.frame = CGRect(x: 5, y: 0, width: screenWidth-10, height: 32)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.title = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(userSegmentCntrl.selectedSegmentIndex == 0){
            return allmeetingName.count
        }else{
            return myMeetingName.count
        }
    }
    
    
    
    func fetchAllData(){
         myMeetingName  = [FIRDataSnapshot]()
        
        
         allmeetingName = [FIRDataSnapshot]()
      meetingIds.removeAllObjects()
        ref = FIRDatabase.database().reference()
        
        var allMeetingDict = NSMutableDictionary()
        
        let filter = ref.child("Meetings").queryOrdered(byChild: "mdate")
        filter.observe(.value , with: {snapshot in
            
            // filter.observe(of: .childAdded,  with: {snapshot in
            print(snapshot.value)
            
            var newItems = [FIRDataSnapshot]()
            
            // loop through the children and append them to the new array
            for item in snapshot.children {
                
                
                
                newItems.append(item as! FIRDataSnapshot)
            }
            
          self.allmeetingName = newItems as? [FIRDataSnapshot]
//            print(self.allmeetingName)
           self.userTableView.reloadData()
            
        })
        
        let  ref1 = FIRDatabase.database().reference()
        
        let filter1 = ref1.child("Subscriptions").queryOrdered(byChild: "empId").queryEqual(toValue: empID)
        
        filter1.observe(.value, with: {snapshot in
            print(snapshot.value)
            var newItems = [FIRDataSnapshot]()
            
            // loop through the children and append them to the new array
            for item in snapshot.children {
                let meetingID = (item as AnyObject).childSnapshot(forPath: "meetingId").value as! String?
                let subID = (item as AnyObject).childSnapshot(forPath: "isSubscribed").value as! String?
                print("meeting id ********\((item as AnyObject).childSnapshot(forPath: "meetingId").value as! String?)")
                self.meetingIds.add(meetingID!)
                self.isSubscribed.add(subID!)
                let  ref2 = FIRDatabase.database().reference()
                
                let filter2 = ref2.child("Meetings").queryOrdered(byChild: "meetingID").queryEqual(toValue: meetingID!)
                
                filter2.observe(.value, with: {snapshot in
                    var newItems1 = [FIRDataSnapshot]()
                    
                    for item in snapshot.children {
                       
                        print("meeting id ******** \(item)")
                        self.myMeetingName.append(item as! FIRDataSnapshot)
                        newItems1.append(item as! FIRDataSnapshot)
                    }
                  
                })
                print(self.allmeetingName)
               
            }
           

            
         self.userTableView.reloadData()
        })
        
        
        
    
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTable", for: indexPath) as! UserTableViewCell
        
        cell.subcribeBtn.layer.cornerRadius = 5.0
        cell.subcribeBtn.clipsToBounds = true
        
        cell.feedbackBtn.layer.cornerRadius = 5.0
        cell.feedbackBtn.clipsToBounds = true
        
        cell.meetingCodeBtn.layer.cornerRadius = 5.0
        cell.meetingCodeBtn.clipsToBounds = true
        
      
        if(userSegmentCntrl.selectedSegmentIndex == 0){
            let dict = allmeetingName[indexPath.row] as FIRDataSnapshot
            
            if(dict.childSnapshot(forPath: "meetingType").value as! String? == "1"){
                if(meetingIds.contains(dict.childSnapshot(forPath: "meetingID").value as! String!)){
                cell.subcribeBtn.titleLabel?.text = "Interested"
                }else{
                    cell.subcribeBtn.titleLabel?.text = "Interest"
                    cell.subcribeBtn.tag = indexPath.row
                    cell.subcribeBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
                }
            }else{
            
            if(meetingIds.contains(dict.childSnapshot(forPath: "meetingID").value as! String!)){
                cell.subcribeBtn.titleLabel?.text = "Subscribed"
            }else{
                cell.subcribeBtn.titleLabel?.text = "Subscribe"
                cell.subcribeBtn.tag = indexPath.row
                cell.subcribeBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
            }
            }
            cell.userNameLB.text = dict.childSnapshot(forPath: "mname").value as! String?
            cell.instructLB.text = "By \(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
            cell.dateLB.text = "\(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
            cell.venueLB.text = dict.childSnapshot(forPath: "mvenue").value as! String?
            cell.seatAvaLB.text = dict.childSnapshot(forPath: "maxcount").value as! String?
            
            cell.subcribeBtn.isHidden = false
            cell.feedbackBtn.isHidden = true
            cell.meetingCodeBtn.isHidden = true
            
            
        }else{

            let dict = myMeetingName[indexPath.row] as FIRDataSnapshot
            
            let subid = isSubscribed[indexPath.row] as! String
            
            if(subid == "1"){
              cell.feedbackBtn.titleLabel?.text = "Feedback"
            }else if(subid == "2"){
                cell.feedbackBtn.titleLabel?.text = "Waiting For Approval"
            }else{
                cell.feedbackBtn.titleLabel?.text = "Feedback"
            }
            cell.userNameLB.text = dict.childSnapshot(forPath: "mname").value as! String?
            cell.instructLB.text = "By \(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
            cell.dateLB.text = "\(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
            cell.venueLB.text = dict.childSnapshot(forPath: "mvenue").value as! String?
            cell.seatAvaLB.text = dict.childSnapshot(forPath: "maxcount").value as! String?
            
                        cell.subcribeBtn.isHidden = true
                        cell.feedbackBtn.isHidden = false
                        cell.meetingCodeBtn.isHidden = true
            
        }
        
        
        return cell
    }
    
    
    func subcribeAction(sender: UIButton){
        
        print(sender.tag)
        print(empID)
        
        if(userSegmentCntrl.selectedSegmentIndex == 0){
            let dict = allmeetingName[sender.tag] as FIRDataSnapshot
            if(dict.childSnapshot(forPath: "meetingType").value as! String? == "1"){
               // let SubRef = ref.child("Subscriptions").childByAutoId()
                var meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
                var key = "\(meetID!)\(empID)"
                print("\(dict.childSnapshot(forPath: "meetingID").value as! String?)")
                
                
                let subcribe = Subcription(attendeeId:key,empId:empID,isAttended:"0",isSubscribed:"2",meetingId: meetID!,key:"")
                
                
                let sub = ref.child("Subscriptions").child(key)
                sub.setValue(subcribe.toAnyObject())
            }else{
            
            let meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
            let key = "\(meetID!)\(empID)"
            print("\(dict.childSnapshot(forPath: "meetingID").value as! String?)")
            let subcribe = Subcription(attendeeId:key,empId:empID,isAttended:"0",isSubscribed:"1",meetingId: meetID!,key:"")
            let sub = ref.child("Subscriptions").child(key)
            sub.setValue(subcribe.toAnyObject())
            
            }
        }
        
        fetchAllData()
        
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
