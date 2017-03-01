//
//  AdminMeetingsViewController.swift
//  MeetingApp
//
//  Created by Administrator on 31/01/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import  Firebase

class AdminMeetingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var completedmeetingName:[FIRDataSnapshot]! = [FIRDataSnapshot]()
    var upcommingMeetingName:[FIRDataSnapshot]! = [FIRDataSnapshot]()
    var instructorArray = [String]()
    var instructorArray1 = [String]()
    var dateArray = [String]()
    var dateArray1 = [String]()
    var venueArray = [String]()
    var venueArray1 = [String]()
    
    var meetingsArray : NSMutableDictionary = NSMutableDictionary()
    var meetingDataArray:[FIRDataSnapshot]! = [FIRDataSnapshot]()
    var ref: FIRDatabaseReference!
    
    
    @IBAction func reportActionBtn(_ sender: UIButton) {
        let dict = completedmeetingName[sender.tag] as FIRDataSnapshot
        let meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
        
        let ListViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "reportReview") as? AdminReportViewController
        ListViewControllerObj?.meetingID = meetID
        ListViewControllerObj?.isCalled = "Admin"
        self.navigationController?.pushViewController(ListViewControllerObj!, animated: true)
        
    }
    
    @IBAction func editBtnAction(_ sender: Any) {
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "addMeeting") as! NewMeetingViewController
        secondViewController.isCall = "CellEditBtn"
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    @IBAction func approvalAction(_ sender: Any) {
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "approvals") as! ApproveListViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    @IBOutlet weak var adminTableView: UITableView!
    let label = UILabel(frame: CGRect(x: (screenWidth-350)/2, y: (screenHeight-21)/2, width: 350, height: 21))
    
    @IBAction func adminSegmentAction(_ sender: UISegmentedControl) {
        
        if(adminMeetingSegCntrl.selectedSegmentIndex == 1){
            if(completedmeetingName.count == 0){
                label.textAlignment = .center
                self.label.font = UIFont(name: "MyriadPro-Regular", size: 17.0)
                label.text = "There are no completed meetings"
                self.view.addSubview(label)
                self.view.bringSubview(toFront: label)
                adminTableView.isHidden = true
                
            }else{
                adminTableView.isHidden = false
                label.removeFromSuperview()
                self.adminTableView.reloadData()
            }
        }else{
            if(upcommingMeetingName.count == 0){
                label.textAlignment = .center
                self.label.font = UIFont(name: "MyriadPro-Regular", size: 17.0)
                label.text = "There are no upcomming meetings"
                self.view.addSubview(label)
                self.view.bringSubview(toFront: label)
                adminTableView.isHidden = true
                
            }else{
                adminTableView.isHidden = false
                label.removeFromSuperview()
                self.adminTableView.reloadData()
            }
            
        }
        
        //adminTableView.reloadData()
    }
    
    @IBOutlet weak var adminMeetingSegCntrl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
//        upcommingMeetingName = ["Meeting4","Meeting5","Meeting6","Meeting7","Meeting8"]
//        instructorArray = ["by John Miller","by Kate Smith","by Brain Hamilton","by Henry Pitt","by Daisy Steel"]
//        dateArray = ["6thFeb 11:00 AM-12:00 PM","6thFeb 3:00 PM-4:30 PM","7thFeb 10:00 PM-12:30 PM","7thFeb 5:00 PM-6:00 PM","8thFeb 5:00 PM-6:00 PM"]
//        venueArray = ["Woody","Datsun","Galaxy","Earth","Venus"]
//        
//        completedmeetingName = ["Meeting1","Meeting2","Meeting3"]
//        instructorArray1 = ["by Kate Smith","by Daisy Steel","by John Miller"]
//        dateArray1 = ["3rdFeb 11:00 AM-12:00 PM","3rdFeb 4:00 PM-5:00 PM","2ndFeb 3:00 PM-4:00 PM"]
//        venueArray1 = ["Jupiter","Saturn","Woody"]

        
        
        
        

        
        self.adminTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Meetings"
        fetchAllData()
        let leftItem = UIBarButtonItem(title: "Add Meeting",
                                       style: .plain,
                                       target: self,
                                       action: #selector(self.nextView))
        self.navigationItem.rightBarButtonItem = leftItem
        
        self.adminMeetingSegCntrl.translatesAutoresizingMaskIntoConstraints = true
        self.adminMeetingSegCntrl.frame = CGRect(x: 5, y: 0, width: screenWidth-10, height: 32)
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.title = ""
    }
    
    func nextView(){
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "addMeeting") as! NewMeetingViewController
        secondViewController.isCall = "NavigationEditBtn"
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    func fetchAllData(){
        
        Indicator.sharedInstance.startActivityIndicator()
        let date = NSDate()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM dd, yyyy HH:mm"
        
        let result = formatter.string(from: date as Date)
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        let result1 = formatter.string(from: yesterday!)
        
        print(result1)
        ref = FIRDatabase.database().reference()
        self.upcommingMeetingName.removeAll()
       // var upcommingMeetingDict = NSMutableDictionary()
        var newItems1 = [FIRDataSnapshot]()
        let filter = ref.child("Meetings").queryOrdered(byChild: "isExpired").queryEqual(toValue: "0")
        filter.observe(.value , with: {snapshot in
           var newItems = [FIRDataSnapshot]()
            for item in snapshot.children {
                //let isexpired = (item as AnyObject).childSnapshot(forPath: "isExpired").value as! String?
               
                
                 newItems.append(item as! FIRDataSnapshot)
               
                
            }
            self.upcommingMeetingName = newItems
            print(self.meetingDataArray)
            Indicator.sharedInstance.stopActivityIndicator()
            if(self.adminMeetingSegCntrl.selectedSegmentIndex == 0){
                if(self.upcommingMeetingName.count == 0){
                    self.label.textAlignment = .center
                    self.label.text = "There are no upcomming meetings"
                    self.view.addSubview(self.label)
                    self.view.bringSubview(toFront: self.label)
                    self.adminTableView.reloadData()
                  //  self.adminTableView.isHidden = true
                    
                }else{
                    //self.adminTableView.isHidden = false
                    self.label.removeFromSuperview()
                    self.adminTableView.reloadData()
                }
            }
        })
        self.completedmeetingName.removeAll()
      //  var completedMeetingDict = NSMutableDictionary()
        let filter1 = ref.child("Meetings").queryOrdered(byChild: "isExpired").queryEqual(toValue: "1")
        
        filter1.observe(.value, with: {snapshot in
         //   print(snapshot.value)
            
            // loop through the children and append them to the new array
            for item in snapshot.children {
                newItems1.append(item as! FIRDataSnapshot)
            }
            
            self.completedmeetingName = newItems1 
            print(self.meetingDataArray)
            Indicator.sharedInstance.stopActivityIndicator()
            
                if(self.completedmeetingName.count == 1){
                    self.label.textAlignment = .center
                    self.label.text = "There are no completed meetings"
                    self.view.addSubview(self.label)
                    self.view.bringSubview(toFront: self.label)
                   // self.adminTableView.isHidden = true
                    self.adminTableView.reloadData()
                    
                }else{
                   // self.adminTableView.isHidden = false
                    self.label.removeFromSuperview()
                    self.adminTableView.reloadData()
                }
                
            //}
            
        })
        
    
}
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
            return upcommingMeetingName.count
        }else{
        return completedmeetingName.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminCell", for: indexPath) as! AdminTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.editBtn.layer.cornerRadius = 5.0
        cell.editBtn.clipsToBounds = true
        
        cell.reportBtn.layer.cornerRadius = 5.0
        cell.reportBtn.clipsToBounds = true
        
        cell.approvalBtn.layer.cornerRadius = 5.0
        cell.approvalBtn.clipsToBounds = true
        
        if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
            let dict = upcommingMeetingName[indexPath.row] as FIRDataSnapshot
            
            
            var cnt = (dict.childSnapshot(forPath: "currentCount").value as! String?)!
            
            var maxcnt = (dict.childSnapshot(forPath: "maxcount").value as! String?)!
            if(cnt == ""){
                cnt = "0"
            }
            var dif = Int(maxcnt)! - Int(cnt)!
            
            if(dif > 0 ){
                cell.seatAvabLb.text = "\(dif) of \(dict.childSnapshot(forPath: "maxcount").value as! String) seats remaining"

            }else{
                cell.seatAvabLb.text = "No seats remaining"

            }
            
            cell.nameLb.text = dict.childSnapshot(forPath: "mname").value as! String?
            cell.instructorLb.text = "\(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
            cell.dateLb.text = "\(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
            cell.venueLb.text = "\(dict.childSnapshot(forPath: "mvenue").value as! String)"
                       cell.editBtn.isHidden = false
            cell.reportBtn.isHidden = true
            cell.editBtn.tag = indexPath.row
            cell.editBtn.addTarget(self, action: #selector(editAction), for: .touchUpInside)
            cell.seatAvabLb.isHidden = false
            
            var meetType = dict.childSnapshot(forPath: "meetingType").value as! String?
            
            if(meetType == "1"){
                
                cell.approvalBtn.isHidden = false
                cell.approvalBtn.tag = indexPath.row
                cell.approvalBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
            }else{
                cell.approvalBtn.isHidden = true
            }
            
        }else{
             let dict = completedmeetingName[indexPath.row] as FIRDataSnapshot
            
            cell.nameLb.text = dict.childSnapshot(forPath: "mname").value as! String?
            cell.instructorLb.text = "\(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
            cell.dateLb.text = "\(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
            cell.venueLb.text = "\(dict.childSnapshot(forPath: "mvenue").value as! String)"
            cell.reportBtn.tag = indexPath.row
            cell.editBtn.isHidden = true
            
            cell.reportBtn.isHidden = false
            cell.approvalBtn.isHidden = true
            //cell.maxCntLb.isHidden = true
            cell.seatAvabLb.isHidden = true
        }

        
        return cell
    }
    func subcribeAction(sender: UIButton){
        
        print(sender.tag)
       // print(empID)
        if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
            let dict = upcommingMeetingName[sender.tag] as FIRDataSnapshot
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "approvals") as! ApproveListViewController
            secondViewController.meetinID = dict.childSnapshot(forPath: "meetingID").value as! String!
            secondViewController.instruID = dict.childSnapshot(forPath: "minstructorID").value as! String!
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
         let dict = upcommingMeetingName[indexPath.row] as FIRDataSnapshot
        
        print("\(dict.childSnapshot(forPath: "meetingID").value as! String?)")
         }else{
            let dict = completedmeetingName[indexPath.row] as FIRDataSnapshot
            print("\(dict.childSnapshot(forPath: "meetingID").value as! String?)")
        }
    }
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
//        UIView.animate(withDuration: 0.3, animations: {
//            cell.layer.transform = CATransform3DMakeScale(1.05, 1.05, 1)
//        },completion: nil)
//    }
//
    
    
    func editAction(sender: UIButton){
        
        print(sender.tag)
        
        if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
            let dict = upcommingMeetingName[sender.tag] as FIRDataSnapshot
            
            print("\(dict.childSnapshot(forPath: "meetingID").value as! String?)")
            
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "addMeeting") as! NewMeetingViewController
            secondViewController.isCall = "CellEditBtn"
           // secondViewController.buttonTag = sender.tag
            secondViewController.editMeetingDataArray = dict
            self.navigationController?.pushViewController(secondViewController, animated: true)
        }
        
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
