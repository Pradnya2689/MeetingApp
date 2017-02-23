//
//  ViewCommentsViewController.swift
//  MeetingApp
//
//  Created by pradnya on 16/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import Firebase
class ViewCommentsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var commntTbl:UITableView!
     var ref: FIRDatabaseReference!
    var coomntArray:NSMutableArray! = NSMutableArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "View Comments"
        
        Indicator.sharedInstance.startActivityIndicator()
            fetchData(){
             self.commntTbl.dataSource = self
             self.commntTbl.delegate = self
                

            //do something here after running your function
            print("Tada!!!!\(self.coomntArray.count)")
            if(self.coomntArray.count > 0){
               
               // self.commntTbl.reloadInputViews()
                Indicator.sharedInstance.stopActivityIndicator()
                self.commntTbl.reloadData()
            }
           
        }
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commntTbl.dequeueReusableCell(withIdentifier: "coomntCell", for: indexPath) as! CommentsCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.commntLbl.text = coomntArray.object(at: indexPath.row) as? String
        
        return cell
    }
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.commntTbl.estimatedRowHeight = 100
        self.commntTbl.rowHeight = UITableViewAutomaticDimension
        self.commntTbl.reloadData()
    }
    func fetchData(finished: @escaping () -> Void) {
       Indicator.sharedInstance.startActivityIndicator()
        self.coomntArray = NSMutableArray()
        ref = FIRDatabase.database().reference()
        
        let filter = ref.child("FeedBacks").queryOrdered(byChild: "feedbackId")
        filter.observe(.value , with: {snapshot in
            
            // filter.observe(of: .childAdded,  with: {snapshot in
            print(snapshot.value)
            
            let newItems = NSMutableArray()
            
            // loop through the children and append them to the new array
            for item in snapshot.children {
                
                let cmnt1 = (item as AnyObject).childSnapshot(forPath: "comment1").value as! String! as String
                if(cmnt1.characters.count != 0){
                  newItems.add(cmnt1)
                }
                let cmnt2 = (item as AnyObject).childSnapshot(forPath: "comment2").value as! String! as String
                if(cmnt2.characters.count != 0){
                    newItems.add(cmnt2)
                }
            }
            Indicator.sharedInstance.stopActivityIndicator()
            self.coomntArray = NSMutableArray.init(array: newItems)
            finished()
        })
        
        //
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coomntArray.count
    }
    
    //open func cellForRow(at indexPath: IndexPath) -> UITableViewCell?{
      // let cell = tableView.register(UITableViewCell.self, forCellReuseIdentifier: "coomntCell") as! CommentsCell
    
   // }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }

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
