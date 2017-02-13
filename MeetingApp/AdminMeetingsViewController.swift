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
    
    @IBAction func reportActionBtn(_ sender: Any) {
        
        let ListViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "reportReview") as? AdminReportViewController
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
   
    
    @IBAction func adminSegmentAction(_ sender: UISegmentedControl) {
        
        adminTableView.reloadData()
    }
    
    @IBOutlet weak var adminMeetingSegCntrl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        upcommingMeetingName = ["Meeting4","Meeting5","Meeting6","Meeting7","Meeting8"]
//        instructorArray = ["by John Miller","by Kate Smith","by Brain Hamilton","by Henry Pitt","by Daisy Steel"]
//        dateArray = ["6thFeb 11:00 AM-12:00 PM","6thFeb 3:00 PM-4:30 PM","7thFeb 10:00 PM-12:30 PM","7thFeb 5:00 PM-6:00 PM","8thFeb 5:00 PM-6:00 PM"]
//        venueArray = ["Woody","Datsun","Galaxy","Earth","Venus"]
//        
//        completedmeetingName = ["Meeting1","Meeting2","Meeting3"]
//        instructorArray1 = ["by Kate Smith","by Daisy Steel","by John Miller"]
//        dateArray1 = ["3rdFeb 11:00 AM-12:00 PM","3rdFeb 4:00 PM-5:00 PM","2ndFeb 3:00 PM-4:00 PM"]
//        venueArray1 = ["Jupiter","Saturn","Woody"]

        
        
        
        

        fetchAllData()
        self.adminTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Meetings"
        
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
        
        let date = NSDate()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MMM dd, yyyy HH:mm a"
        
        let result = formatter.string(from: date as Date)
        
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        
        let result1 = formatter.string(from: yesterday!)
        
        print(result1)
        ref = FIRDatabase.database().reference()
        
        var upcommingMeetingDict = NSMutableDictionary()
        
        let filter = ref.child("Meetings").queryOrdered(byChild: "mdate").queryStarting(atValue: result ,childKey: "mdate")
        filter.observe(.value , with: {snapshot in
            
        // filter.observe(of: .childAdded,  with: {snapshot in
            print(snapshot.value)

            var newItems = [FIRDataSnapshot]()
           
            // loop through the children and append them to the new array
            for item in snapshot.children {
                
//                let dateAsString =  (item as AnyObject).childSnapshot(forPath: "mstarttime").value as! String
//                
//                let calender = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
//                calender!.locale = NSLocale.current
//                
//                //let timeToday = "20:00" as! NSString
//                let timeToday = dateAsString
//                let timeArray = timeToday.components(separatedBy: ":")
//                let timeTodayHours = Int(timeArray[0])
//                let timeTodayMin = Int(timeArray[1])
//                let timeTodayDate = calender!.date(bySettingHour: timeTodayHours!, minute: timeTodayMin!, second: 00, of: NSDate() as Date, options: NSCalendar.Options())
//                
//                                let dateFormatter = DateFormatter()
//                                 dateFormatter.timeStyle = .short
//                               dateFormatter.dateFormat = "HH:mm"
//                                let dateA = dateFormatter.date(from: dateAsString)
//                print(dateA)
//                let now = NSDate()
//                if now.compare(timeTodayDate!) == .orderedDescending {
//                    print(" 'timeToday' has passed!!! ")
//                }
//                
//                
//                switch now.compare(timeTodayDate!) {
//                case .orderedAscending    :   print("Date A is earlier than date B")
//                case .orderedDescending    :   print("Date A is later than date B")
//                case .orderedSame          :   print("The two dates are the same")
//
//                }
               

                newItems.append(item as! FIRDataSnapshot)
            }
            
            self.upcommingMeetingName = newItems as? [FIRDataSnapshot]
            print(self.meetingDataArray)
            self.adminTableView.reloadData()

            
        })
        
        var completedMeetingDict = NSMutableDictionary()
        
        let filter1 = ref.child("Meetings").queryOrdered(byChild: "mdate").queryEnding(atValue: result )
        
        filter1.observe(.value, with: {snapshot in
            print(snapshot.value)
            
//            if let meetings = snapshot.value{
//                
//                //  for item in snapshot.children{
//                if(meetings != nil){
////                    completedMeetingDict = (meetings as? NSMutableDictionary)!
//                }
//               
//                //   }
//                
//                
//            }
            
            var newItems = [FIRDataSnapshot]()
            
            // loop through the children and append them to the new array
            for item in snapshot.children {
                newItems.append(item as! FIRDataSnapshot)
            }
            
            self.completedmeetingName = newItems as? [FIRDataSnapshot]
            print(self.meetingDataArray)
            self.adminTableView.reloadData()
            
            
        })
        
    

        
        
//        ref.child("Meetings").observe(.value, with: { snapshot in
//            print(snapshot.value)
//            
//            if let meetings = snapshot.value{
//            
//              //  for item in snapshot.children{
//                    
//                     self.meetingsArray = (meetings as? NSMutableDictionary)!
//                //   }
//                
//           
//            }
//            
//            var newItems = [FIRDataSnapshot]()
//            
//            // loop through the children and append them to the new array
//            for item in snapshot.children {
//                newItems.append(item as! FIRDataSnapshot)
//            }
//
//            self.meetingDataArray = newItems as? [FIRDataSnapshot]
//            print(self.meetingDataArray)
//            self.adminTableView.reloadData()
//            
//            
////            for item in (self.meetingsArray as? NSDictionary)!{
////                self.meetingDataArray.add(item)
////            }
////            print(self.meetingDataArray)
//        })
        
        
}



    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
            
            //return meetingDataArray.count
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
            
            
            cell.nameLb.text = dict.childSnapshot(forPath: "mname").value as! String?
            cell.instructorLb.text = "By \(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
            cell.dateLb.text = "\(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
            cell.venueLb.text = dict.childSnapshot(forPath: "mvenue").value as! String?
           
            cell.editBtn.isHidden = false
            cell.reportBtn.isHidden = true
            cell.approvalBtn.isHidden = false
            
            
        }else{
             let dict = completedmeetingName[indexPath.row] as FIRDataSnapshot
            cell.nameLb.text = dict.childSnapshot(forPath: "mname").value as! String?
            cell.instructorLb.text = "By \(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
            cell.dateLb.text = "\(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
            cell.venueLb.text = dict.childSnapshot(forPath: "mvenue").value as! String?
            cell.editBtn.isHidden = true
            cell.reportBtn.isHidden = false
            cell.approvalBtn.isHidden = true
        }

        
        return cell
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
