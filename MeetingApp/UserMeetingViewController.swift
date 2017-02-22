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
    
    let label = UILabel(frame: CGRect(x: (screenWidth-350)/2, y: (screenHeight-21)/2, width: 350, height: 21))
    
    @IBAction func userSegmntAction(_ sender: UISegmentedControl) {
      
         if(userSegmentCntrl.selectedSegmentIndex == 1){
        if(myMeetingName.count == 0){
          
                
                label.textAlignment = .center
                label.text = "You have not subscribed for any meetings"
                self.view.addSubview(label)
                self.view.bringSubview(toFront: label)
                userTableView.isHidden = true
            
        }else{
            userTableView.isHidden = false
            label.removeFromSuperview()
            self.userTableView.reloadData()
        }
         }else{
            if(allmeetingName.count == 0){
               
                    
                    label.textAlignment = .center
                    label.text = "No meetings added"
                    self.view.addSubview(label)
                    self.view.bringSubview(toFront: label)
                    userTableView.isHidden = true
               
            }else{
                userTableView.isHidden = false
                label.removeFromSuperview()
                self.userTableView.reloadData()
            }

        }
        
        if(userSegmentCntrl.selectedSegmentIndex == 1){
            Indicator.sharedInstance.startActivityIndicator()
            self.fetchMyMeeting(){
//                self.addMyMeetings {
//                    self.userTableView.reloadData()
//                }
                
            }
            
            
        }
//
        userTableView.reloadData()
        //Indicator.sharedInstance.stopActivityIndicator()
    }
    
    var alertText: UITextField!
    
   
    func alertClose(_ gesture: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
//    var allmeetingName = [String]()
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
        //Indicator.sharedInstance.startActivityIndicator()
        
            self.fetchMyMeeting(){
//                self.addMyMeetings {
//                    self.userTableView.reloadData()
//                }
                
            }
            
       
        userTableView.isHidden = false
        label.removeFromSuperview()
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
    
    func fetchMyMeeting(finished: @escaping () -> Void)  {
        Indicator.sharedInstance.startActivityIndicator()
        myMeetingName.removeAll()
       // ref = FIRDatabase.database().reference()
        
        meetingIds.removeAllObjects()
        isSubscribed.removeAllObjects()
        
      //  self.addMyMeetings()
        let  ref1 = FIRDatabase.database().reference()
        let filter1 = ref1.child("Subscriptions").queryOrdered(byChild: "empId").queryEqual(toValue: empID)
        
        filter1.observe(.value, with: {snapshot in
            print(snapshot.value)
            
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
                
                let  ref2 = FIRDatabase.database().reference()
                
                let filter2 = ref2.child("Meetings").queryOrdered(byChild: "meetingID").queryEqual(toValue: meetingID!)
                
                filter2.observe(.value, with: {snapshot in
                    var newItems1 = [FIRDataSnapshot]()
                    
                    
                    for item1 in snapshot.children {
                        let isexpired = (item1 as AnyObject).childSnapshot(forPath: "isExpired").value as! String?
                        let instrID = (item1 as AnyObject).childSnapshot(forPath: "minstructorID").value as! String?
                        if(isexpired != "1" ){
                        
                        print("meeting id ******** \(item1)")
                        //if(instrID != self.empID)
                        //{
                        self.myMeetingName.append(item1 as! FIRDataSnapshot)
                        newItems1.append(item1 as! FIRDataSnapshot)
                        //}
                        }
                    }
                    
                    Indicator.sharedInstance.stopActivityIndicator()
                    self.userTableView.reloadData()
                })
                }
            }
            //self.addMyMeetings()
            Indicator.sharedInstance.stopActivityIndicator()
           self.userTableView.reloadData()
            finished()
        })
    }
    func addMyMeetings(finished: @escaping () -> Void){
        let  ref2 = FIRDatabase.database().reference()
        
        let filter2 = ref2.child("Meetings").queryOrdered(byChild: "minstructorID").queryEqual(toValue: empID)
        
        filter2.observe(.value, with: {snapshot in
            var newItems1 = [FIRDataSnapshot]()
            
            
            for item1 in snapshot.children {
                let isexpired = (item1 as AnyObject).childSnapshot(forPath: "isExpired").value as! String?
                if(isexpired != "1"){
                    //  newItems1.append(item as! FIRDataSnapshot)
                    print("meeting id ******** \(item1)")
                    self.myMeetingName.append(item1 as! FIRDataSnapshot)
                    newItems1.append(item1 as! FIRDataSnapshot)
                }
            }
          finished()
        })

    }
    func fetchAllData(){
        // myMeetingName.removeAll()
         allmeetingName.removeAll()
        userTableView.reloadData()
         //meetingIds.removeAllObjects()
        
         Indicator.sharedInstance.startActivityIndicator()
        ref = FIRDatabase.database().reference()
        
        var allMeetingDict = NSMutableDictionary()
        
        let filter = ref.child("Meetings").queryOrdered(byChild: "isExpired").queryEqual(toValue: "0")
        filter.observe(.value , with: {snapshot in
             print(snapshot.value)
           
            var newItems = [FIRDataSnapshot]()
            for item in snapshot.children {
                let instrID = (item as AnyObject).childSnapshot(forPath: "minstructorID").value as! String?
               // if(instrID != self.empID){
                    newItems.append(item as! FIRDataSnapshot)
                //}
                
            }
            Indicator.sharedInstance.stopActivityIndicator()
          self.allmeetingName = newItems as? [FIRDataSnapshot]
          self.userTableView.reloadData()
            
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
            let dict = allmeetingName[indexPath.row] as FIRDataSnapshot
            
            if(dict.childSnapshot(forPath: "meetingType").value as! String? == "1"){
                if(meetingIds.contains(dict.childSnapshot(forPath: "meetingID").value as! String!)){
               // cell.subcribeBtn.titleLabel?.text = "Interested"
                    cell.subcribeBtn.isHidden = true
                }else{
                    cell.subcribeBtn.isHidden = false
                    cell.subcribeBtn.titleLabel?.text = "Interest"
                    cell.subcribeBtn.tag = indexPath.row
                    cell.subcribeBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
                }
            }else{
            
            if(meetingIds.contains(dict.childSnapshot(forPath: "meetingID").value as! String!)){
                cell.subcribeBtn.isHidden = true
                cell.subcribeBtn.titleLabel?.text = "Subscribed"
//                cell.subcribeBtn.tag = indexPath.row
//                cell.subcribeBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
            }else{
                cell.subcribeBtn.isHidden = false
                cell.subcribeBtn.titleLabel?.text = "Subscribe"
                cell.subcribeBtn.tag = indexPath.row
                cell.subcribeBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
            }
            }
//            var cnt = (dict.childSnapshot(forPath: "currentCount").value as! String?)!
//            
//            var maxcnt = (dict.childSnapshot(forPath: "maxcount").value as! String?)!
//            
//            var dif = Int(maxcnt)! - Int(cnt)!
//            if(dif > 0){
//                cell.subcribeBtn.isHidden = false
//                cell.subcribeBtn.tag = indexPath.row
//                cell.subcribeBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
//            }else{
//                cell.subcribeBtn.isHidden = true
//            }
            cell.userNameLB.text = dict.childSnapshot(forPath: "mname").value as! String?
            cell.instructLB.text = "By \(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
            cell.dateLB.text = "On \(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
            cell.venueLB.text = "At  \(dict.childSnapshot(forPath: "mvenue").value as! String)"
            cell.seatAvaLB.text = dict.childSnapshot(forPath: "maxcount").value as! String?
            
           // cell.subcribeBtn.isHidden = false
            cell.feedbackBtn.isHidden = true
            cell.meetingCodeBtn.isHidden = true
            cell.seatAvaLB.isHidden = false
            cell.seatsLabel.isHidden = false
            cell.endMeetingBtn.isHidden = true
            
            
        }else{
            
//            if(myMeetingName.count == 0){
//                
//                let label = UILabel(frame: CGRect(x: (screenWidth-100)/2, y: (screenHeight-21)/2, width: 100, height: 21))
//                            label.center = CGPoint(x: 160, y: 285)
//                            label.textAlignment = .center
//                            label.text = "No Meetings"
//                            self.view.addSubview(label)
//                
//            }else{

            let dict = myMeetingName[indexPath.row] as FIRDataSnapshot
           // if(meetingIds.contains(dict.childSnapshot(forPath: "meetingID").value as! String!)){
                let subid = isSubscribed[indexPath.row] as! String
                // let instrID = dict.childSnapshot(forPath: "minstructorID").value as! String?
                if(subid == "1" ){
                    
                    cell.feedbackBtn.titleLabel?.text = "Feedback"
                    cell.feedbackBtn.tag = indexPath.row
                    cell.feedbackBtn.addTarget(self, action: #selector(feedbackAction), for: .touchUpInside)
                    
                }else if(subid == "2"){
                    cell.feedbackBtn.titleLabel?.text = "Waiting For Approval"
                    //                cell.translatesAutoresizingMaskIntoConstraints = true
                    //                cell.feedbackBtn.frame = CGRect(x: 200, y: 124, width: 162, height: 21)
                    
                }
            //}
           
            //            else{
////                cell.translatesAutoresizingMaskIntoConstraints = true
////                cell.feedbackBtn.frame = CGRect(x: 272, y: 124, width: 90, height: 21)
//                cell.feedbackBtn.titleLabel?.text = "Feedback"
//                cell.feedbackBtn.tag = indexPath.row
//                cell.feedbackBtn.addTarget(self, action: #selector(feedbackAction), for: .touchUpInside)
//            }
            var instrID = dict.childSnapshot(forPath: "minstructorID").value as? String
            if(instrID! == self.empID){
                cell.endMeetingBtn.isHidden = false
                cell.meetingCodeBtn.isHidden = false
                cell.endMeetingBtn.tag = indexPath.row
                cell.endMeetingBtn.addTarget(self, action: #selector(endcodeAction), for: .touchUpInside)
                cell.feedbackBtn.isHidden = true
                cell.meetingCodeBtn.tag = indexPath.row
                cell.meetingCodeBtn.addTarget(self, action: #selector(codeAction), for: .touchUpInside)
            }
            //minstructorID
            cell.userNameLB.text = dict.childSnapshot(forPath: "mname").value as! String?
            cell.instructLB.text = "By \(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
            cell.dateLB.text = "On \(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
            cell.venueLB.text = "At \(dict.childSnapshot(forPath: "mvenue").value as! String)"
            cell.subcribeBtn.isHidden = true
            cell.feedbackBtn.isHidden = false
            cell.seatAvaLB.isHidden = true
            cell.seatsLabel.isHidden = true
        }
        
        
        
    //}
    return cell
    }
    
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
        },completion: nil)
    }
    func updateCount(sender:Int){
       
        //currentCount = snapshotValue["currentCount"] as? String
      
        let dict = self.allmeetingName[sender] as FIRDataSnapshot
        var cnt = (dict.childSnapshot(forPath: "currentCount").value as! String?)!
        
        var maxcnt = (dict.childSnapshot(forPath: "maxcount").value as! String?)!
        
        if(Int(cnt)! <= Int(maxcnt)!){
            let c = Int(cnt)! + 1 as Int
            let usr = ref.child("Meetings").child((dict.childSnapshot(forPath: "meetingID").value as! String?)!)
            // print("key of tbl \(groceryItemRef.key)")
            let meetItem = meetingItem(mname: (dict.childSnapshot(forPath: "mname").value as! String?)!, mdate: (dict.childSnapshot(forPath: "mdate").value as! String?)!, mtimestart: "", mtimeend: (dict.childSnapshot(forPath: "mendtime").value as! String?)!, mvenue: (dict.childSnapshot(forPath: "mvenue").value as! String?)!,mid: (dict.childSnapshot(forPath: "meetingID").value as! String?)!,meetingCode: (dict.childSnapshot(forPath: "meetingCode").value as! String?)!, maxCount: (dict.childSnapshot(forPath: "maxcount").value as! String?)!,currentCount: String(c),isexpired:(dict.childSnapshot(forPath: "isExpired").value as! String?)!,instructName: (dict.childSnapshot(forPath: "mInstuctorName").value as! String?)!,instructempId: (dict.childSnapshot(forPath: "minstructorID").value as! String?)!,meetingType: (dict.childSnapshot(forPath: "meetingType").value as! String?)! ,completed: true, key: "")
            
            usr.setValue(meetItem.toAnyObject())
        }else{
            
            
            
        }
      
       
        
        
    }
    
    func subcribeAction(sender: UIButton){
    
        
        
        var alert = UIAlertController(title: "Do you want to Subscribe for this Meeting?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        
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
               
               
                self.fetchAllData()
            }
            
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
    func endcodeAction(sender: UIButton){
         let dict = self.myMeetingName[sender.tag] as FIRDataSnapshot
        let usr = ref.child("Meetings").child((dict.childSnapshot(forPath: "meetingID").value as! String?)!)
        
        let meetItem = meetingItem(mname: (dict.childSnapshot(forPath: "mname").value as! String?)!, mdate: (dict.childSnapshot(forPath: "mdate").value as! String?)!, mtimestart: "", mtimeend: (dict.childSnapshot(forPath: "mendtime").value as! String?)!, mvenue: (dict.childSnapshot(forPath: "mvenue").value as! String?)!,mid: (dict.childSnapshot(forPath: "meetingID").value as! String?)!,meetingCode: (dict.childSnapshot(forPath: "meetingCode").value as! String?)!, maxCount: (dict.childSnapshot(forPath: "maxcount").value as! String?)!,currentCount: (dict.childSnapshot(forPath: "currentCount").value as! String?)!,isexpired:"1",instructName: (dict.childSnapshot(forPath: "mInstuctorName").value as! String?)!,instructempId: (dict.childSnapshot(forPath: "minstructorID").value as! String?)!,meetingType: (dict.childSnapshot(forPath: "meetingType").value as! String?)! ,completed: true, key: "")
        
        usr.setValue(meetItem.toAnyObject())
        fetchMyMeeting(){
            
        }
    }
    func codeAction(sender: UIButton){
        let dict = self.myMeetingName[sender.tag] as FIRDataSnapshot
        var meetID = dict.childSnapshot(forPath: "meetingCode").value as! String?
         var alert = UIAlertController(title: "Your Meeting Code is \(meetID!)", message: "", preferredStyle: UIAlertControllerStyle.alert)
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
        
        var alert = UIAlertController(title: "Enter Meeting Code", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
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
            
            if(self.meetingCode != ""){
            
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
                     var alert = UIAlertController(title: "Invalid Meeting code", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                        (action) -> Void in
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
            
                
            }else{
                
               // self.showAlert(Message: "Enter Meeting Code")
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
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
        UIView.animate(withDuration: 0.25, animations: {
             cell.layer.transform = CATransform3DMakeScale(1,1,1)
        })
        
//        UIView.animateWithDuration(0.25, animations: {
//            
//            cell.layer.transform = CATransform3DMakeScale(1,1,1)
//        })
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
