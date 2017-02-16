//
//  AdminReportViewController.swift
//  MeetingApp
//
//  Created by Administrator on 02/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Firebase

class AdminReportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var isCalled : String!
    
    var contentEffCount : Int = 0
    
    @IBOutlet weak var thankyouLB: UILabel!
    @IBOutlet weak var reportSegmentOutlet: UISegmentedControl!
    @IBAction func reportSegCntrl(_ sender: Any) {
        
        if(reportSegmentOutlet.selectedSegmentIndex == 0){
            
            feedbackView.isHidden = false
            attendanceView.isHidden = true
        }else{
            
            feedbackView.isHidden = true
            attendanceView.isHidden = false
        }
    }
    
    @IBOutlet weak var attendanceView: UIView!
    @IBOutlet weak var feedbackView: UIView!
    
    var employeeId = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        let leftItem = UIBarButtonItem(title: "Done",
                                       style: .plain,
                                       target: self,
                                       action: #selector(self.nextView))
        self.navigationItem.rightBarButtonItem = leftItem

        employeeId = ["109876","103567","103479","102439","106248"]
        
        if(isCalled == "User"){
            
            self.reportSegmentOutlet.isHidden = true
            
            self.thankyouLB.isHidden = false
            
        }else{
            
            self.reportSegmentOutlet.isHidden = false
            
            self.thankyouLB.isHidden = true
        }
        
        ref = FIRDatabase.database().reference()
        var counter = 0
        
        let filter = ref.child("FeedBacks").queryOrdered(byChild: "meetingID")
        filter.observe(.value , with: {snapshot in
            
            // filter.observe(of: .childAdded,  with: {snapshot in
            print(snapshot.value)
            
            var newItems = [FIRDataSnapshot]()
            
            // loop through the children and append them to the new array
            for item in snapshot.children {
                
                
                self.contentEffCount = self.contentEffCount + ((item as AnyObject).childSnapshot(forPath: "contentEffeciency").value as! Int?)!
                
                var effyCount = ((item as AnyObject).childSnapshot(forPath: "contentEffeciency").value as! Int?)!
                
//                if(self.effyCount == 1){
//                    
//                    
//                     counter += counter
//                }
                
                print(counter)
                
                newItems.append(item as! FIRDataSnapshot)
            }
            
            print(self.contentEffCount)
        })


    }
    
    func nextView(){
        
        if(isCalled == "User"){
            
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            print(viewControllers[viewControllers.count - 2])
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true);
        
        }else{
            
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
            print(viewControllers[viewControllers.count - 2])
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
        }
   
       
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Reports"
        
        feedbackView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendance", for: indexPath) as! EmployeeNoTableViewCell
        
        
        cell.idNumberLabel.text = employeeId[indexPath.row]
        
        return cell
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
