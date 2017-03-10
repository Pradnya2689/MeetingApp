//
//  AdminMeetingsViewController.swift
//  MeetingApp
//
//  Created by Administrator on 31/01/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import  Firebase

class AdminMeetingsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var completedmeetingName:[FIRDataSnapshot]! = [FIRDataSnapshot]()
    var upcommingMeetingName:[FIRDataSnapshot]! = [FIRDataSnapshot]()
    var instructorArray = [String]()
    var instructorArray1 = [String]()
    var name = [String]()
    var dateArray1 = [String]()
    var venueArray = [String]()
    var venueArray1 = [String]()
    var filteredmeetingName = NSMutableArray()
    var filterArray = NSArray()
    var filterArray1 = NSArray()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let  searchBar = UISearchBar()
    
    var empID = UserDefaults.standard.value(forKey: "empID") as! String
    
    var meetingsArray : NSMutableDictionary = NSMutableDictionary()
    var meetingDataArray:[FIRDataSnapshot]! = [FIRDataSnapshot]()
//    var ref: FIRDatabaseReference!
//    var ref1: FIRDatabaseReference!
    @available(iOS 2.0, *)
      func searchBarCancelButtonClicked(_ searchBar: UISearchBar) // called when cancel button pressed
    {
       // searchController.isActive = false
//        if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
//        for child in upcommingMeetingName {
//            let dict = child.value as! NSDictionary
//            print(dict)
//            filteredmeetingName.addObjects(from: [dict])
//        }
//        filterArray = (filteredmeetingName as NSArray)
//        }else{
//            for child in completedmeetingName {
//                let dict = child.value as! NSDictionary
//                print(dict)
//                filteredmeetingName.addObjects(from: [dict])
//            }
//            filterArray1 = (filteredmeetingName as NSArray)
//        }
    }
   
    func filterContentsForSearchText(searchText : String , scope : String = "All"){
        
        print(searchText)
        
        if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
            
           if(searchText == ""){
            filteredmeetingName.removeAllObjects()
            for child in upcommingMeetingName {
                let dict = child.value as! NSDictionary
                print(dict)
                filteredmeetingName.addObjects(from: [dict])
            }
            filterArray = (filteredmeetingName as NSArray)
            }else{
            
            filteredmeetingName.removeAllObjects()
            
            print(self.upcommingMeetingName)
            
            for child in upcommingMeetingName {
                let dict = child.value as! NSDictionary
                print(dict)
                filteredmeetingName.addObjects(from: [dict])
            }
            
            print(filteredmeetingName)
            
           let searchPredicate1 = NSPredicate(format: "mInstuctorName CONTAINS[C] %@", searchText)
            let searchPredicate = NSPredicate(format: "mname CONTAINS[C] %@", searchText)

         //   let  predicate = NSPredicate(format: "mInstuctorName CONTAINS[C] %@ OR mname CONTAINS[C] %@", searchText,searchText)
            
            let predicate: NSCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [searchPredicate1,searchPredicate])
            
            filterArray=NSArray()
            filterArray = (filteredmeetingName as NSArray).filtered(using: predicate) as NSArray
            
            print(filterArray)
            
            if(filterArray.count == 0){
                self.label.textAlignment = .center
                self.label.text = "No meetings"
                self.view.addSubview(self.label)
                self.view.bringSubview(toFront: self.label)
            }else{
                self.label.removeFromSuperview()
            }
            
            }
             adminTableView.reloadData()
            
        }else{
            if(searchText == ""){
                filteredmeetingName.removeAllObjects()
                for child in completedmeetingName {
                    let dict = child.value as! NSDictionary
                    print(dict)
                    filteredmeetingName.addObjects(from: [dict])
                }
                filterArray1 = (filteredmeetingName as NSArray)
            }else{
            print(self.completedmeetingName)
            
            filteredmeetingName.removeAllObjects()
            
            
            for child in completedmeetingName {
                let dict = child.value as! NSDictionary
                print(dict)
                filteredmeetingName.addObjects(from: [dict])
            }
            
            print(filteredmeetingName)
            filterArray1=NSArray()
             let searchPredicate1 = NSPredicate(format: "mInstuctorName CONTAINS[C] %@", searchText)
            let searchPredicate = NSPredicate(format: "mname CONTAINS[C] %@", searchText)
            let pred = NSCompoundPredicate.init(type: .or, subpredicates: [searchPredicate1,searchPredicate])
            filterArray1 = (filteredmeetingName as NSArray).filtered(using: pred) as NSArray
            
            print(filterArray1)
                
                if(filterArray1.count == 0){
                    self.label.textAlignment = .center
                    self.label.text = "No meetings"
                    self.view.addSubview(self.label)
                    self.view.bringSubview(toFront: self.label)
                }else{
                    self.label.removeFromSuperview()
                }
            }
            adminTableView.reloadData()

        }
        
    }
    
    
    
    
    
    @IBAction func reportActionBtn(_ sender: UIButton) {
        let dict = completedmeetingName[sender.tag] as FIRDataSnapshot
        let meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
        let instrID = dict.childSnapshot(forPath: "minstructorID").value as! String!
        
        let ListViewControllerObj = self.storyboard?.instantiateViewController(withIdentifier: "reportReview") as? AdminReportViewController
        ListViewControllerObj?.meetingID = meetID
        ListViewControllerObj?.InstrID = instrID
        ListViewControllerObj?.isCalled = "Admin"
        self.navigationController?.pushViewController(ListViewControllerObj!, animated: true)
        
    }
    
    
    @IBOutlet weak var adminTableView: UITableView!
    var label = UILabel(frame: CGRect(x: (screenWidth-350)/2, y: (screenHeight-21)/2, width: 350, height: 21))
    
    @IBAction func adminSegmentAction(_ sender: UISegmentedControl) {
        
        
        if(adminMeetingSegCntrl.selectedSegmentIndex == 1){
            //ref.removeAllObservers()
            fetchOldDAta()
        }else{
            //ref1.removeAllObservers()
            fetchAllData()
        }
        
        if(self.adminMeetingSegCntrl.selectedSegmentIndex == 0){
            if(self.upcommingMeetingName.count > 0){
                self.searchController.searchBar.isHidden = false
                self.searchController.searchResultsUpdater = self
                self.searchController.dimsBackgroundDuringPresentation = false
                self.definesPresentationContext = true
                self.searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
                self.adminTableView.tableHeaderView = self.searchController.searchBar
            }else{
                self.searchController.searchBar.isHidden = true
            }
        }else{
            if(self.completedmeetingName.count > 0){
                self.searchController.searchBar.isHidden = false
                self.searchController.searchResultsUpdater = self
                self.searchController.dimsBackgroundDuringPresentation = false
                self.definesPresentationContext = true
                self.searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
                self.adminTableView.tableHeaderView = self.searchController.searchBar
            }else{
                //self.userTableView.contentOffset = CGPoint(x: 0, y: 44)
                self.searchController.searchBar.isHidden = true
                
            }
            
        }
        
       
    }
    
    @IBOutlet weak var adminMeetingSegCntrl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        adminMeetingSegCntrl.selectedSegmentIndex = 0
        fetchAllData()
        fetchOldDAta()
        
//        self.searchController.searchBar.delegate = self
//        // self.searchController.datas
//        self.searchController.searchResultsUpdater = self
//        self.searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        //self.searchController.searchBar.barTintColor = UIColor.clear
//        self.searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
//        adminTableView.tableHeaderView = self.searchController.searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        label.frame =  CGRect(x: (screenWidth-350)/2, y: (screenHeight-21)/2, width: 350, height: 21)
        self.title = "Meetings"
       
        let leftItem = UIBarButtonItem(title: "Add Meeting",
                                       style: .plain,
                                       target: self,
                                       action: #selector(self.nextView))
        self.navigationItem.rightBarButtonItem = leftItem
        
        self.adminMeetingSegCntrl.translatesAutoresizingMaskIntoConstraints = true
        self.adminMeetingSegCntrl.frame = CGRect(x: 5, y: 10, width: screenWidth-10, height: 32)
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //ref.removeAllObservers()
        self.title = ""
    }
    
    func nextView(){
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "addMeeting") as! NewMeetingViewController
        secondViewController.isCall = "NavigationEditBtn"
      //  let nav = UINavigationController.init(rootViewController: secondViewController)
       // self.navigationController!.present(nav, animated: true, completion: nil)
        self.navigationController!.pushViewController(secondViewController, animated: true)
    }
    func fetchOldDAta(){
        if(adminMeetingSegCntrl.selectedSegmentIndex == 1){
        Indicator.sharedInstance.startActivityIndicator()
        var newItems1 = [FIRDataSnapshot]()
          
        //ref1 = FIRDatabase.database().reference()
        
        //  var completedMeetingDict = NSMutableDictionary()
        let filter1 = refr.child("Meetings").queryOrdered(byChild: "isExpired").queryEqual(toValue: "1")
           
        filter1.observe(.value, with: {snapshot in
            for item in snapshot.children {
                newItems1.append(item as! FIRDataSnapshot)
            }
            self.completedmeetingName.removeAll()
            self.completedmeetingName = [FIRDataSnapshot]()
            self.completedmeetingName = newItems1
            print(self.meetingDataArray)
            Indicator.sharedInstance.stopActivityIndicator()
            
            if(self.adminMeetingSegCntrl.selectedSegmentIndex == 0){
                if(self.upcommingMeetingName.count > 0){
                    self.searchController.searchBar.isHidden = false
                    self.searchController.searchResultsUpdater = self
                    self.searchController.dimsBackgroundDuringPresentation = false
                    self.definesPresentationContext = true
                    self.searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
                    self.adminTableView.tableHeaderView = self.searchController.searchBar
                }else{
                    self.searchController.searchBar.isHidden = true
                }
            }else{
                if(self.completedmeetingName.count > 0){
                    self.searchController.searchBar.isHidden = false
                    self.searchController.searchResultsUpdater = self
                    self.searchController.dimsBackgroundDuringPresentation = false
                    self.definesPresentationContext = true
                    self.searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
                    self.adminTableView.tableHeaderView = self.searchController.searchBar
                }else{
                    //self.userTableView.contentOffset = CGPoint(x: 0, y: 44)
                    self.searchController.searchBar.isHidden = true
                    
                }
                
            }
            
            if(self.completedmeetingName.count == 0){
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
    }
    func fetchAllData(){
        if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
        Indicator.sharedInstance.startActivityIndicator()

       //filterArray = NSArray()
            filteredmeetingName.removeAllObjects()
        self.upcommingMeetingName.removeAll()
        self.upcommingMeetingName =  [FIRDataSnapshot]()
         
        let filter = refr.child("Meetings").queryOrdered(byChild: "isExpired").queryEqual(toValue: "0")
        filter.observe(.value , with: {snapshot in
           var newItems = [FIRDataSnapshot]()
            for item in snapshot.children {
                   newItems.append(item as! FIRDataSnapshot)
                
            }
            self.upcommingMeetingName = newItems
//            for child in self.upcommingMeetingName {
//                let dict = child.value as! NSDictionary
//                print(dict)
//                self.filteredmeetingName.addObjects(from: [dict])
//            }
//
//             self.filterArray = self.filteredmeetingName as NSArray
            print(self.meetingDataArray)
            Indicator.sharedInstance.stopActivityIndicator()
            
            if(self.adminMeetingSegCntrl.selectedSegmentIndex == 0){
                if(self.upcommingMeetingName.count > 0){
                    self.searchController.searchBar.isHidden = false
                    self.searchController.searchResultsUpdater = self
                    self.searchController.dimsBackgroundDuringPresentation = false
                    self.definesPresentationContext = true
                    self.searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
                    self.adminTableView.tableHeaderView = self.searchController.searchBar
                }else{
                    self.searchController.searchBar.isHidden = true
                }
            }else{
                if(self.completedmeetingName.count > 0){
                    self.searchController.searchBar.isHidden = false
                    self.searchController.searchResultsUpdater = self
                    self.searchController.dimsBackgroundDuringPresentation = false
                    self.definesPresentationContext = true
                    self.searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
                    self.adminTableView.tableHeaderView = self.searchController.searchBar
                }else{
                    //self.userTableView.contentOffset = CGPoint(x: 0, y: 44)
                    self.searchController.searchBar.isHidden = true
                    
                }
                
            }
            
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
        }
        
    
}
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive  {
            if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
                return filterArray.count
            }else{
                return filterArray1.count
            }
        }else  if !searchController.isActive && searchController.searchBar.text == ""{
        
        if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
            return upcommingMeetingName.count
        }else{
        return completedmeetingName.count
        }
            
        }
        return 0
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
            
            
            
            if searchController.isActive {
                let dict = filterArray[indexPath.row] as! NSDictionary
                
                
                var cnt = dict.value(forKey: "currentCount") as! String
                var maxcnt = dict.value(forKey: "maxcount") as! String
                if(cnt == ""){
                    cnt = "0"
                }
                var dif = Int(maxcnt)! - Int(cnt)!
                
                if(dif > 0 ){
                    cell.seatAvabLb.text = "\(dif) of \(maxcnt) seats remaining"
                    
                }else{
                    cell.seatAvabLb.text = "No seats remaining"
                    
                }
                cell.nameLb.text = dict.value(forKey: "mname") as! String?
                cell.instructorLb.text = dict.value(forKey: "mInstuctorName")as! String?
                cell.dateLb.text = "\(dict.value(forKey: "mdate")as! String) - \(dict.value(forKey: "mendtime")as! String)"
                cell.venueLb.text = dict.value(forKey: "mvenue")as! String?
                cell.editBtn.isHidden = false
                cell.reportBtn.isHidden = true
                cell.editBtn.tag = indexPath.row
                cell.editBtn.addTarget(self, action: #selector(editAction), for: .touchUpInside)
                cell.seatAvabLb.isHidden = false
                cell.instrID = ""
                var meetType = dict.value(forKey: "meetingType") as! String
                
                if(meetType == "1"){
                    
                    cell.approvalBtn.isHidden = false
                    cell.approvalBtn.tag = indexPath.row
                    cell.approvalBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
                }else{
                    cell.approvalBtn.isHidden = true
                }
                
                
                
                cell.feedBACKBtn.isHidden = false
                cell.feedBACKBtn.tag = indexPath.row
                cell.feedBACKBtn.addTarget(self, action: #selector(feedBackAction), for: .touchUpInside)
                
            } else {
                
                if(upcommingMeetingName.count > 0){
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
                cell.instrID = ""
                var meetType = dict.childSnapshot(forPath: "meetingType").value as! String?
                
                if(meetType == "1"){
                    
                    cell.approvalBtn.isHidden = false
                    cell.approvalBtn.tag = indexPath.row
                    cell.approvalBtn.addTarget(self, action: #selector(subcribeAction), for: .touchUpInside)
                }else{
                    cell.approvalBtn.isHidden = true
                }
                
                
                
                cell.feedBACKBtn.isHidden = false
                cell.feedBACKBtn.tag = indexPath.row
                cell.feedBACKBtn.addTarget(self, action: #selector(feedBackAction), for: .touchUpInside)
                }else{
                    
                        self.label.textAlignment = .center
                        self.label.text = "There are no upcomming meetings"
                        self.view.addSubview(self.label)
                        self.view.bringSubview(toFront: self.label)
                        self.adminTableView.reloadData()
                   
                }
                
            }
            
            
        }else{
            
            
            if searchController.isActive {
                
                
                let dict = filterArray1[indexPath.row] as! NSDictionary
                
                cell.nameLb.text = dict.value(forKey: "mname") as! String?
                cell.instructorLb.text = dict.value(forKey: "mInstuctorName")as! String?
                cell.dateLb.text = "\(dict.value(forKey: "mdate")as! String) - \(dict.value(forKey: "mendtime")as! String)"
                cell.venueLb.text = dict.value(forKey: "mvenue")as! String?
                cell.reportBtn.tag = indexPath.row
                cell.editBtn.isHidden = true
                cell.instrID = dict.value(forKey: "minstructorID")as! String?
                cell.reportBtn.isHidden = false
                cell.approvalBtn.isHidden = true
                //cell.maxCntLb.isHidden = true
                cell.seatAvabLb.isHidden = true
                cell.feedBACKBtn.isHidden = true
                
            } else if !searchController.isActive && searchController.searchBar.text == ""{
                let dict = completedmeetingName[indexPath.row] as FIRDataSnapshot
                
                cell.nameLb.text = dict.childSnapshot(forPath: "mname").value as! String?
                cell.instructorLb.text = "\(dict.childSnapshot(forPath: "mInstuctorName").value as! String)"
                cell.dateLb.text = "\(dict.childSnapshot(forPath: "mdate").value as! String) - \(dict.childSnapshot(forPath: "mendtime").value as! String)"
                cell.venueLb.text = "\(dict.childSnapshot(forPath: "mvenue").value as! String)"
                cell.reportBtn.tag = indexPath.row
                cell.editBtn.isHidden = true
                cell.instrID = "\(dict.childSnapshot(forPath: "minstructorID").value as! String)"
                cell.reportBtn.isHidden = false
                cell.approvalBtn.isHidden = true
                //cell.maxCntLb.isHidden = true
                cell.seatAvabLb.isHidden = true
                cell.feedBACKBtn.isHidden = true
            }
            
            
            
            
            
            
            
      
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
            self.navigationController!.pushViewController(secondViewController, animated: true)
        }
        
    }
    
    
    func feedBackAction(sender: UIButton){
        
        print(sender.tag)
        
        if(adminMeetingSegCntrl.selectedSegmentIndex == 0){
            let dict = upcommingMeetingName[sender.tag] as FIRDataSnapshot
            
            let meetID = dict.childSnapshot(forPath: "meetingID").value as! String?
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginPage") as! ViewController
            UserDefaults.standard.set(meetID, forKey: "meetID")
            secondViewController.isCalled = "AdminMeet"
            //secondViewController.meetingID = meetID
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


extension AdminMeetingsViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
       
        filterContentsForSearchText(searchText: searchController.searchBar.text!)
        
    }
    
}
