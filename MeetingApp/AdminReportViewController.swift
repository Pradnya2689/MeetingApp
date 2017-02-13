//
//  AdminReportViewController.swift
//  MeetingApp
//
//  Created by Administrator on 02/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class AdminReportViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var isCalled : String!
    
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
