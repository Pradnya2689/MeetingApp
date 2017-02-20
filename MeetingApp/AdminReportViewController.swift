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

    @IBOutlet weak var viewaAllCmtsBtn: UIButton!
    var isCalled : String!
    
    var contentEffTotalCount : Int = 0
    var encouragIntTotalCount : Int = 0
    var learnObjTotalCount :  Int = 0
    var valuableTimeTotalCount : Int = 0
    var overallFeedbackTotalCount : Int = 0
    
    var counter11 = 0
    var counter12 = 0
    var counter13 = 0
    var counter14 = 0
    var counter15 = 0
    
    var counter21 = 0
    var counter22 = 0
    var counter23 = 0
    var counter24 = 0
    var counter25 = 0
    
    var counter31 = 0
    var counter32 = 0
    var counter33 = 0
    var counter34 = 0
    var counter35 = 0
    
    var counter41 = 0
    var counter42 = 0
    var counter43 = 0
    var counter44 = 0
    var counter45 = 0
    
    var counter51 = 0
    var counter52 = 0
    var counter53 = 0
    var counter54 = 0
    var counter55 = 0
    


    
    
    
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
    
    @IBOutlet weak var stronglyAgreePB: UIProgressView!
    @IBOutlet weak var countLb1: UILabel!
    @IBOutlet weak var stronglyDisagreePB: UIProgressView!
    @IBOutlet weak var disagreePB: UIProgressView!
    @IBOutlet weak var countLb2: UILabel!
    @IBOutlet weak var neutralPB: UIProgressView!
    @IBOutlet weak var countLb3: UILabel!
    @IBOutlet weak var agreePB: UIProgressView!
    @IBOutlet weak var countLb4: UILabel!
    @IBOutlet weak var countLb5: UILabel!
    
    
    
    @IBOutlet weak var stronglyDisagreePB2: UIProgressView!
    @IBOutlet weak var disagreePB2: UIProgressView!
    @IBOutlet weak var neutralPB2: UIProgressView!
    @IBOutlet weak var agreePB2: UIProgressView!
    @IBOutlet weak var stronglyagreePB2: UIProgressView!
    @IBOutlet weak var countLBQ2: UILabel!
    @IBOutlet weak var countLb2Q2: UILabel!
    @IBOutlet weak var countLb3Q2: UILabel!
    @IBOutlet weak var countLb4Q2: UILabel!
    @IBOutlet weak var countLb5Q2: UILabel!
    
    
    @IBOutlet weak var stronglyDisagreePB3: UIProgressView!
    @IBOutlet weak var disagreePB3: UIProgressView!
    @IBOutlet weak var neutralPB3: UIProgressView!
    @IBOutlet weak var agreePB3: UIProgressView!
    @IBOutlet weak var stronglyagreePB3: UIProgressView!
    @IBOutlet weak var countLb1Q3: UILabel!
    @IBOutlet weak var countLb2Q3: UILabel!
    @IBOutlet weak var countLb3Q3: UILabel!
    @IBOutlet weak var countLb4Q3: UILabel!
    @IBOutlet weak var countLb5Q3: UILabel!
    
    
    
    @IBOutlet weak var stronglyDisagreePB4: UIProgressView!
    @IBOutlet weak var disagreePB4: UIProgressView!
    @IBOutlet weak var neutralPB4: UIProgressView!
    @IBOutlet weak var agreePB4: UIProgressView!
    @IBOutlet weak var stronglyagreePB4: UIProgressView!
    @IBOutlet weak var countLb1Q4: UILabel!
    @IBOutlet weak var countLb2Q4: UILabel!
    @IBOutlet weak var countLb3Q4: UILabel!
    @IBOutlet weak var countLb4Q4: UILabel!
    @IBOutlet weak var countLb5Q4: UILabel!
    
    
    
    @IBOutlet weak var stronglyDisagreePB5: UIProgressView!
    @IBOutlet weak var disagreePB5: UIProgressView!
    @IBOutlet weak var neutralPB5: UIProgressView!
    @IBOutlet weak var agreePB5: UIProgressView!
    @IBOutlet weak var stronglyagreePB5: UIProgressView!
    @IBOutlet weak var countLb1Q5: UILabel!
    @IBOutlet weak var countLb2Q5: UILabel!
    @IBOutlet weak var countLb3Q5: UILabel!
    @IBOutlet weak var countLb4Q5: UILabel!
    @IBOutlet weak var countLb5Q5: UILabel!
    
    
    
    var meetingID : String!
    
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
            
            self.viewaAllCmtsBtn.isHidden = true
            
        }else{
            
            self.reportSegmentOutlet.isHidden = false
            
            self.thankyouLB.isHidden = true
            
            self.viewaAllCmtsBtn.isHidden = false
        }
        
        ref = FIRDatabase.database().reference()
        
        let filter = ref.child("FeedBacks").queryOrdered(byChild: "meetingID").queryEqual(toValue: meetingID)
        filter.observe(.value , with: {snapshot in
            
            print(snapshot.value)
            
            var totalCount = snapshot.childrenCount
            print(totalCount)
            var newItems = [FIRDataSnapshot]()
            
            // loop through the children and append them to the new array
            for  item in snapshot.children {
               
                self.contentEffTotalCount = self.contentEffTotalCount + ((item as AnyObject).childSnapshot(forPath: "contentEffeciency").value as! Int?)!
                
                self.encouragIntTotalCount = self.encouragIntTotalCount + ((item as AnyObject).childSnapshot(forPath: "encouragedInteraction").value as! Int?)!
                
                self.learnObjTotalCount = self.learnObjTotalCount + ((item as AnyObject).childSnapshot(forPath: "learningObjectives").value as! Int?)!
                
                self.valuableTimeTotalCount = self.valuableTimeTotalCount + ((item as AnyObject).childSnapshot(forPath: "valuableuseOfTime").value as! Int?)!
                
                self.overallFeedbackTotalCount = self.overallFeedbackTotalCount + ((item as AnyObject).childSnapshot(forPath: "overallFeedback").value as! Int?)!
                
                var effyCount = ((item as AnyObject).childSnapshot(forPath: "contentEffeciency").value as! Int?)!
                
                if(effyCount == 1){
                     self.counter11 += 1
                }else if(effyCount == 2) {
                    self.counter12 += 1
                }else if(effyCount == 3){
                    self.counter13 += 1
                }else if(effyCount == 4){
                    self.counter14 += 1
                }else{
                    self.counter15 += 1
                }
                
                
                var interactionCount = ((item as AnyObject).childSnapshot(forPath: "encouragedInteraction").value as! Int?)!
                
                if(interactionCount == 1){
                    self.counter21 += 1
                }else if(effyCount == 2) {
                    self.counter22 += 1
                }else if(effyCount == 3){
                    self.counter23 += 1
                }else if(effyCount == 4){
                    self.counter24 += 1
                }else{
                    self.counter25 += 1
                }
                
                
                var objectiveCount = ((item as AnyObject).childSnapshot(forPath: "learningObjectives").value as! Int?)!
                
                if(objectiveCount == 1){
                    self.counter31 += 1
                }else if(effyCount == 2) {
                    self.counter32 += 1
                }else if(effyCount == 3){
                    self.counter33 += 1
                }else if(effyCount == 4){
                    self.counter34 += 1
                }else{
                    self.counter35 += 1
                }
                
                
                var valueTimeCount = ((item as AnyObject).childSnapshot(forPath: "valuableuseOfTime").value as! Int?)!
                
                if(valueTimeCount == 1){
                    self.counter41 += 1
                }else if(effyCount == 2) {
                    self.counter42 += 1
                }else if(effyCount == 3){
                    self.counter43 += 1
                }else if(effyCount == 4){
                    self.counter44 += 1
                }else{
                    self.counter45 += 1
                }
                
                
                var overAllFBCount = ((item as AnyObject).childSnapshot(forPath: "encouragedInteraction").value as! Int?)!
                
                if(overAllFBCount == 1){
                    self.counter51 += 1
                }else if(effyCount == 2) {
                    self.counter52 += 1
                }else if(effyCount == 3){
                    self.counter53 += 1
                }else if(effyCount == 4){
                    self.counter54 += 1
                }else{
                    self.counter55 += 1
                }
                
                newItems.append(item as! FIRDataSnapshot)
                
            }
            
            let stronglydisAgreeCount1 = (Float(self.counter11) / Float(totalCount))
            let disAgreeCount1 = (Float(self.counter12) / Float(totalCount))
            let neutralCount1 = (Float(self.counter13) / Float(totalCount))
            let AgreeCount1 = (Float(self.counter14) / Float(totalCount))
            let stronglyAgreeCount1 = (Float(self.counter15) / Float(totalCount))
            
            self.stronglyDisagreePB.progress = Float(stronglydisAgreeCount1)
            self.disagreePB.progress = Float(disAgreeCount1)
            self.neutralPB.progress = Float(neutralCount1)
            self.agreePB.progress = Float(AgreeCount1)
            self.stronglyAgreePB.progress = Float(stronglyAgreeCount1)
            
            self.countLb1.text = "\(self.counter11)"
            self.countLb2.text = "\(self.counter12)"
            self.countLb3.text = "\(self.counter13)"
            self.countLb4.text = "\(self.counter14)"
            self.countLb5.text = "\(self.counter15)"
            
            
            let stronglydisAgreeCount2 = (Float(self.counter21) / Float(totalCount))
            let disAgreeCount2 = (Float(self.counter22) / Float(totalCount))
            let neutralCount2 = (Float(self.counter23) / Float(totalCount))
            let AgreeCount2 = (Float(self.counter24) / Float(totalCount))
            let stronglyAgreeCount2 = (Float(self.counter25) / Float(totalCount))
            
            self.stronglyDisagreePB2.progress = Float(stronglydisAgreeCount2)
            self.disagreePB2.progress = Float(disAgreeCount2)
            self.neutralPB2.progress = Float(neutralCount2)
            self.agreePB2.progress = Float(AgreeCount2)
            self.stronglyagreePB2.progress = Float(stronglyAgreeCount2)
            
            self.countLBQ2.text = "\(self.counter21)"
            self.countLb2Q2.text = "\(self.counter22)"
            self.countLb3Q2.text = "\(self.counter23)"
            self.countLb4Q2.text = "\(self.counter24)"
            self.countLb5Q2.text = "\(self.counter25)"

            
            let stronglydisAgreeCount3 = (Float(self.counter31) / Float(totalCount))
            let disAgreeCount3 = (Float(self.counter32) / Float(totalCount))
            let neutralCount3 = (Float(self.counter33) / Float(totalCount))
            let AgreeCount3 = (Float(self.counter34) / Float(totalCount))
            let stronglyAgreeCount3 = (Float(self.counter35) / Float(totalCount))
            
            self.stronglyDisagreePB3.progress = Float(stronglydisAgreeCount3)
            self.disagreePB3.progress = Float(disAgreeCount3)
            self.neutralPB3.progress = Float(neutralCount3)
            self.agreePB3.progress = Float(AgreeCount3)
            self.stronglyagreePB3.progress = Float(stronglyAgreeCount3)
            
            self.countLb1Q3.text = "\(self.counter31)"
            self.countLb2Q3.text = "\(self.counter32)"
            self.countLb3Q3.text = "\(self.counter33)"
            self.countLb4Q3.text = "\(self.counter34)"
            self.countLb5Q3.text = "\(self.counter35)"
            
            
            let stronglydisAgreeCount4 = (Float(self.counter41) / Float(totalCount))
            let disAgreeCount4 = (Float(self.counter42) / Float(totalCount))
            let neutralCount4 = (Float(self.counter43) / Float(totalCount))
            let AgreeCount4 = (Float(self.counter44) / Float(totalCount))
            let stronglyAgreeCount4 = (Float(self.counter45) / Float(totalCount))
            
            self.stronglyDisagreePB4.progress = Float(stronglydisAgreeCount4)
            self.disagreePB4.progress = Float(disAgreeCount4)
            self.neutralPB4.progress = Float(neutralCount4)
            self.agreePB4.progress = Float(AgreeCount4)
            self.stronglyagreePB4.progress = Float(stronglyAgreeCount4)
            
            self.countLb1Q4.text = "\(self.counter41)"
            self.countLb2Q4.text = "\(self.counter42)"
            self.countLb3Q4.text = "\(self.counter43)"
            self.countLb4Q4.text = "\(self.counter44)"
            self.countLb5Q4.text = "\(self.counter45)"
            
            
            let stronglydisAgreeCount5 = (Float(self.counter51) / Float(totalCount))
            let disAgreeCount5 = (Float(self.counter52) / Float(totalCount))
            let neutralCount5 = (Float(self.counter53) / Float(totalCount))
            let AgreeCount5 = (Float(self.counter54) / Float(totalCount))
            let stronglyAgreeCount5 = (Float(self.counter55) / Float(totalCount))
            
            self.stronglyDisagreePB5.progress = Float(stronglydisAgreeCount5)
            self.disagreePB5.progress = Float(disAgreeCount5)
            self.neutralPB5.progress = Float(neutralCount5)
            self.agreePB5.progress = Float(AgreeCount5)
            self.stronglyagreePB5.progress = Float(stronglyAgreeCount5)
            
            self.countLb1Q5.text = "\(self.counter51)"
            self.countLb2Q5.text = "\(self.counter52)"
            self.countLb3Q5.text = "\(self.counter53)"
            self.countLb4Q5.text = "\(self.counter54)"
            self.countLb5Q5.text = "\(self.counter55)"
            

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
