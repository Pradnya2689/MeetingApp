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
        //Indicator.sharedInstance.startActivityIndicator()
        userTableView.reloadData()
        //Indicator.sharedInstance.stopActivityIndicator()
    }
    
    var alertText: UITextField!
    
    
   
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
        userSegmentCntrl.selectedSegmentIndex = 0
        Indicator.sharedInstance.startActivityIndicator()
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
        
        
        
         allmeetingName = [FIRDataSnapshot]()
      
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
            // Indicator.sharedInstance.stopActivityIndicator()
           self.userTableView.reloadData()
            
        })
        
        let  ref1 = FIRDatabase.database().reference()
        meetingIds.removeAllObjects()
         myMeetingName  = [FIRDataSnapshot]()
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
                      //  newItems1.append(item as! FIRDataSnapshot)
                        print("meeting id ******** \(item)")
                        
                        newItems1.append(item as! FIRDataSnapshot)
                    }
                  self.myMeetingName = (newItems1 as? [FIRDataSnapshot])!
                })
                print(self.allmeetingName)
               
            }
           

             Indicator.sharedInstance.stopActivityIndicator()
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
                cell.subcribeBtn.tag = indexPath.row
                cell.subcribeBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
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
            cell.seatAvaLB.isHidden = false
            cell.seatsLabel.isHidden = false
            
            
        }else{

            let dict = myMeetingName[indexPath.row] as FIRDataSnapshot
            
            let subid = isSubscribed[indexPath.row] as! String
            
            if(subid == "1"){
              cell.feedbackBtn.titleLabel?.text = "Feedback"
                cell.feedbackBtn.tag = indexPath.row
                cell.feedbackBtn.addTarget(self, action: #selector(feedbackAction), for: .touchUpInside)
                
            }else if(subid == "2"){
                cell.feedbackBtn.titleLabel?.text = "Waiting For Approval"
            }else{
                cell.feedbackBtn.titleLabel?.text = "Feedback"
                cell.feedbackBtn.tag = indexPath.row
                cell.feedbackBtn.addTarget(self, action: #selector(feedbackAction), for: .touchUpInside)
            }
            cell.userNameLB.text = dict.childSnapshot(forPath: "mname").value as! String?
            cell.instructLB.text = "By \(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
            cell.dateLB.text = "\(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
            cell.venueLB.text = dict.childSnapshot(forPath: "mvenue").value as! String?
            //cell.seatAvaLB.text = dict.childSnapshot(forPath: "maxcount").value as! String?
            
                        cell.subcribeBtn.isHidden = true
                        cell.feedbackBtn.isHidden = false
                        cell.meetingCodeBtn.isHidden = true
            cell.seatAvaLB.isHidden = true
            cell.seatsLabel.isHidden = true
        }
        
        
        return cell
    }
    
    
    func subcribeAction(sender: UIButton){
        
        
        var alert = UIAlertController(title: "Do you want to Subscribe", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {
            (action) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            
            UIAlertAction in
            
            // Indicator.sharedInstance.startActivityIndicator()
            
            print(sender.tag)
            print(self.empID)
            
            if(self.userSegmentCntrl.selectedSegmentIndex == 0){
                let dict = self.allmeetingName[sender.tag] as FIRDataSnapshot
                if(dict.childSnapshot(forPath: "meetingType").value as! String? == "1"){
                    // let SubRef = ref.child("Subscriptions").childByAutoId()
                    var meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
                    var key = "\(meetID!)\(self.empID)"
                    print("\(dict.childSnapshot(forPath: "meetingID").value as! String?)")
                    
                    
                    let subcribe = Subcription(attendeeId:key,empId:self.empID,isAttended:"0",isSubscribed:"2",meetingId: meetID!,key:"")
                    
                    
                    let sub = ref.child("Subscriptions").child(key)
                    sub.setValue(subcribe.toAnyObject())
                }else{
                    
                    let meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
                    let key = "\(meetID!)\(self.empID)"
                    print("\(dict.childSnapshot(forPath: "meetingID").value as! String?)")
                    let subcribe = Subcription(attendeeId:key,empId:self.empID,isAttended:"0",isSubscribed:"1",meetingId: meetID!,key:"")
                    let sub = ref.child("Subscriptions").child(key)
                    sub.setValue(subcribe.toAnyObject())
                    
                }
                
                
            }
             Indicator.sharedInstance.startActivityIndicator()
            self.fetchAllData()
            
            
        }))
        
        
        alert.view.tintColor = UIColor.black
        
        
        self.present(alert, animated: true, completion:{
            // Indicator.sharedInstance.stopActivityIndicator()
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertClose(_:))))
        })

        
        
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "viewComment") as! ViewCommentsViewController
//        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    var meetingCode : String!
    
    func feedbackAction(sender: UIButton){
        
        var alert = UIAlertController(title: "Enter Meeting Code", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField{
            (textField) -> Void in
            
            self.alertText = alert.textFields![0]
            self.alertText.delegate = self
            self.alertText.autocapitalizationType = UITextAutocapitalizationType.words
        }
        
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: {
            (action) -> Void in
            
            let code = alert.textFields![0].text
            self.meetingCode = code
            
            if(self.meetingCode != ""){
            
            let dict = self.allmeetingName[sender.tag] as FIRDataSnapshot
                var meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
            
            
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "feedBack") as! FeedbackViewController
            secondViewController.meetingID = meetID
            self.navigationController?.pushViewController(secondViewController, animated: true)
                
            }else{
                
                self.showAlert(Message: "Enter Meeting Code")
            }
            
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
