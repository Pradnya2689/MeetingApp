//
//  FeedbackViewController.swift
//  MeetingApp
//
//  Created by Administrator on 03/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var feedBackBtn: UIButton!
    @IBOutlet weak var questionLB: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    
    let check = UIImage(named: "checkBoxEnable")! as UIImage
    let uncheck = UIImage(named: "checkBoxDisable")! as UIImage
    
    
    @IBAction func btn1Action(_ sender: Any) {
        
        if(btn1.currentImage == uncheck){
            
            btn1.setImage(check, for: .normal)
            btn2.setImage(uncheck, for: .normal)
            btn3.setImage(uncheck, for: .normal)
            btn4.setImage(uncheck, for: .normal)
            btn5.setImage(uncheck, for: .normal)
            
        }else{
            
             btn1.setImage(uncheck, for: .normal)
        }
        
    }
    
    @IBAction func btn2Action(_ sender: Any) {
        
        if(btn2.currentImage == uncheck){
            
            btn2.setImage(check, for: .normal)
            btn1.setImage(uncheck, for: .normal)
            btn3.setImage(uncheck, for: .normal)
            btn4.setImage(uncheck, for: .normal)
            btn5.setImage(uncheck, for: .normal)
            
            
        }else{
            
            btn2.setImage(uncheck, for: .normal)
        }
    }
    
    @IBAction func btn3Action(_ sender: Any) {
        
        if(btn3.currentImage == uncheck){
            
            btn3.setImage(check, for: .normal)
            btn1.setImage(uncheck, for: .normal)
            btn2.setImage(uncheck, for: .normal)
            btn4.setImage(uncheck, for: .normal)
            btn5.setImage(uncheck, for: .normal)
            
        }else{
            
            btn3.setImage(uncheck, for: .normal)
        }
    }
    
    @IBAction func btn4Action(_ sender: Any) {
        
        if(btn4.currentImage == uncheck){
            
            btn4.setImage(check, for: .normal)
            btn1.setImage(uncheck, for: .normal)
            btn2.setImage(uncheck, for: .normal)
            btn3.setImage(uncheck, for: .normal)
            btn5.setImage(uncheck, for: .normal)
            
        }else{
            
            btn4.setImage(uncheck, for: .normal)
        }
    }
    @IBAction func btn5Action(_ sender: Any) {
        
        if(btn5.currentImage == uncheck){
            
            btn5.setImage(check, for: .normal)
            btn1.setImage(uncheck, for: .normal)
            btn2.setImage(uncheck, for: .normal)
            btn3.setImage(uncheck, for: .normal)
            btn4.setImage(uncheck, for: .normal)
            
        }else{
            
            btn5.setImage(uncheck, for: .normal)
        }
    }

    
    
    var questionArray = [String]()
    
    @IBAction func nextBtnAction(_ sender: Any) {
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "comments") as! CommentsViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        questionArray = ["The instructor presented the content effectively","The instructor encouraged interaction","The learning objectives were clearly presented and achieved.","I feel this session was a valuable use of my time.","Overall training feedback"]
        
       feedBackBtn.layer.cornerRadius = 5.0
        feedBackBtn.clipsToBounds = true
        
        btn1.layer.cornerRadius = 5.0
        btn1.clipsToBounds = true
        
        btn2.layer.cornerRadius = 5.0
        btn2.clipsToBounds = true
        
        btn3.layer.cornerRadius = 5.0
        btn3.clipsToBounds = true
        
        btn4.layer.cornerRadius = 5.0
        btn4.clipsToBounds = true
        
        btn5.layer.cornerRadius = 5.0
        btn5.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        self.title = "FeedBack"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.title = ""
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
