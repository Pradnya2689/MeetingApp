//
//  ApproveListViewController.swift
//  MeetingApp
//
//  Created by Administrator on 10/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class ApproveListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var empIDArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        empIDArray = ["106759","103428","106249","102863"]

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Approval List"
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return empIDArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "meetingApproval", for: indexPath) as! ApproveCellTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.IdLabel.text = empIDArray[indexPath.row]
    
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
