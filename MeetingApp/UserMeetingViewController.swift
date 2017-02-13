//
//  UserMeetingViewController.swift
//  MeetingApp
//
//  Created by Administrator on 03/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class UserMeetingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{

    @IBOutlet weak var userSegmentCntrl: UISegmentedControl!
    
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
    
    var allmeetingName = [String]()
    var myMeetingName = [String]()
    var instructorArray = [String]()
    var instructorArray1 = [String]()
    var venueArray = [String]()
    var venueArray1 = [String]()
    var dateArray = [String]()
    var dateArray1 = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allmeetingName = ["Meeting2","Meeting3","Meeting5","Meeting6"]
        instructorArray = ["by John Miller","by Kate Smith","by Brain Hamilton","by Henry Pitt","by Daisy Steel"]
        venueArray = ["Datsun","Galaxy","Earth","Venus"]
        dateArray = ["6thFeb 3:00 PM-4:30 PM","7thFeb 10:00 PM-12:30 PM","7thFeb 5:00 PM-6:00 PM","8thFeb 5:00 PM-6:00 PM"]
        
        myMeetingName = ["Meeting1","Meeting4","Meeting7"]
        instructorArray1 = ["by Kate Smith","by John Miller","by Daisy Steel"]
        venueArray1 = ["Jupiter","Venus","Datsun"]
        dateArray1 = ["7thFeb 10:00 PM-12:30 PM","8thFeb 5:00 PM-6:00 PM","9thFeb 5:00 PM-6:00 PM"]
        
        
        navigationItem.hidesBackButton = true
        
        let leftItem = UIBarButtonItem(title: "Admin",
                                       style: .plain,
                                       target: self,
                                       action: #selector(self.nextView))
        self.navigationItem.rightBarButtonItem = leftItem
    }
    
    func nextView(){
        
                let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "adminMeet") as! AdminMeetingsViewController
                self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Meetings"
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userTable", for: indexPath) as! UserTableViewCell
        
        cell.subcribeBtn.layer.cornerRadius = 5.0
        cell.subcribeBtn.clipsToBounds = true
        
        cell.feedbackBtn.layer.cornerRadius = 5.0
        cell.feedbackBtn.clipsToBounds = true
        
        cell.meetingCodeBtn.layer.cornerRadius = 5.0
        cell.meetingCodeBtn.clipsToBounds = true
        
        if(userSegmentCntrl.selectedSegmentIndex == 0){
            
            cell.subcribeBtn.isHidden = false
            cell.feedbackBtn.isHidden = true
            cell.meetingCodeBtn.isHidden = true
            cell.userNameLB.text = allmeetingName[indexPath.row]
            cell.instructLB.text = instructorArray[indexPath.row]
            cell.venueLB.text = venueArray[indexPath.row]
            cell.dateLB.text = dateArray[indexPath.row]
        }else{
            
            cell.subcribeBtn.isHidden = true
            cell.feedbackBtn.isHidden = false
            cell.meetingCodeBtn.isHidden = true
            cell.userNameLB.text = myMeetingName[indexPath.row]
            cell.instructLB.text = instructorArray1[indexPath.row]
            cell.venueLB.text = venueArray1[indexPath.row]
            cell.dateLB.text = dateArray1[indexPath.row]
            
            if(indexPath.row == 2){
               
                cell.subcribeBtn.isHidden = true
                cell.feedbackBtn.isHidden = true
                cell.meetingCodeBtn.isHidden = false
            }
        }
        
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
