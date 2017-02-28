//
//  ApproveListViewController.swift
//  MeetingApp
//
//  Created by Administrator on 10/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Firebase
class ApproveListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var ref: FIRDatabaseReference!
    var empIDArray :[FIRDataSnapshot]! = [FIRDataSnapshot]()
    var meetinID:String!
    @IBOutlet var approvalTable : UITableView!
    var empID = UserDefaults.standard.value(forKey: "empID") as! String
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //empIDArray = ["106759","103428","106249","102863"]
         Indicator.sharedInstance.startActivityIndicator()
        ref = FIRDatabase.database().reference()
        let filter = ref.child("Subscriptions").queryOrdered(byChild: "meetingId").queryEqual(toValue: meetinID)
        filter.observe(.value , with: {snapshot in
            
            // filter.observe(of: .childAdded,  with: {snapshot in
            print(snapshot.value)
            
            var newItems = [FIRDataSnapshot]()
            
            // loop through the children and append them to the new array
            for item in snapshot.children {
                  newItems.append(item as! FIRDataSnapshot)
            }
            Indicator.sharedInstance.stopActivityIndicator()
            self.empIDArray = newItems
            self.approvalTable.reloadData()
            
        })

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "Approval List"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return empIDArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetingApproval", for: indexPath) as! ApproveCellTableViewCell
        let dict = empIDArray[indexPath.row] as FIRDataSnapshot

        if(dict.childSnapshot(forPath: "isSubscribed").value as! String! == "1" ){
           cell.approveBtn.isHidden = true
            cell.rejectBtn.isHidden = true
        }else if(dict.childSnapshot(forPath: "isSubscribed").value as! String! == "3" ){
            cell.approveBtn.isHidden = true
            cell.rejectBtn.isHidden = true
        }
        else{
            cell.approveBtn.isHidden = false
            cell.rejectBtn.isHidden = false
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.IdLabel.text = dict.childSnapshot(forPath: "empId").value as! String?
        cell.subscriptionID = dict.childSnapshot(forPath: "attendeeId").value as! String?
        cell.approveBtn.tag = indexPath.row
        cell.approveBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
        cell.rejectBtn.tag = indexPath.row
        cell.rejectBtn.addTarget(self, action: #selector(subcribeAction1), for: .touchUpInside)
        
        return cell
    }
    func subcribeAction1(sender: UIButton){
        Indicator.sharedInstance.startActivityIndicator()
        print(sender.tag)
        let dict = empIDArray[sender.tag] 
        
        let meetID = dict.childSnapshot(forPath: "meetingId").value as! String?
        let key = dict.childSnapshot(forPath: "attendeeId").value as! String!
        let empIDs = dict.childSnapshot(forPath: "empId").value as! String!
        
        
        let subcribe = Subcription(attendeeId:key!,empId:empIDs!,isAttended:"0",isSubscribed:"3",meetingId: meetID!,key:"")
        let sub = ref.child("Subscriptions").child(key!)
        sub.setValue(subcribe.toAnyObject())
        Indicator.sharedInstance.stopActivityIndicator()
        
        let indx = NSIndexPath.init(row: sender.tag, section: 0)
        let cell = approvalTable.cellForRow(at: indx as IndexPath) as! ApproveCellTableViewCell
        cell.approveBtn.isHidden = true
        cell.rejectBtn.isHidden = true
        
    }

    func subcribeAction(sender: UIButton){
        
        print(sender.tag)
        let dict = empIDArray[sender.tag] 
        
        let meetID = dict.childSnapshot(forPath: "meetingId").value as! String?
        let key = dict.childSnapshot(forPath: "attendeeId").value as! String!
        let empIDs = dict.childSnapshot(forPath: "empId").value as! String!
        let subcribe = Subcription(attendeeId:key!,empId:empIDs!,isAttended:"0",isSubscribed:"1",meetingId: meetID!,key:"")
        let sub = ref.child("Subscriptions").child(key!)
        sub.setValue(subcribe.toAnyObject())
        
        
        let indx = NSIndexPath.init(row: sender.tag, section: 0)
        let cell = approvalTable.cellForRow(at: indx as IndexPath) as! ApproveCellTableViewCell
        cell.approveBtn.isHidden = true
        cell.rejectBtn.isHidden = true

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
