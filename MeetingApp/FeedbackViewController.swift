//
//  FeedbackViewController.swift
//  MeetingApp
//
//  Created by Administrator on 03/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController{

    @IBOutlet weak var feedBackBtn: UIButton!
    @IBOutlet weak var questionLB: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    
    
    @IBOutlet weak var stronglyDisagreeLabel: UILabel!
    @IBOutlet weak var disagreeLabel: UILabel!
    @IBOutlet weak var neutralLabel: UILabel!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var stronglyAgreeLabel: UILabel!
    
    
    @IBOutlet weak var countLabel: UILabel!
    var isSubscribed: String!
    var meetingID : String!
    let check = UIImage(named: "checkBoxEnable")! as UIImage
    let uncheck = UIImage(named: "checkBoxDisable")! as UIImage
    
    
    @IBAction func btn1Action(_ sender: Any) {
        
        if(btn1.currentImage == uncheck){
            
            btn1.setImage(check, for: .normal)
            btn2.setImage(uncheck, for: .normal)
            btn3.setImage(uncheck, for: .normal)
            btn4.setImage(uncheck, for: .normal)
            btn5.setImage(uncheck, for: .normal)
            
            selectedAnswer = 1
            
        }else{
            
             btn1.setImage(uncheck, for: .normal)
            
            selectedAnswer = 0
        }
        
    }
    
    @IBAction func btn2Action(_ sender: Any) {
        
        if(btn2.currentImage == uncheck){
            
            btn2.setImage(check, for: .normal)
            btn1.setImage(uncheck, for: .normal)
            btn3.setImage(uncheck, for: .normal)
            btn4.setImage(uncheck, for: .normal)
            btn5.setImage(uncheck, for: .normal)
            
            selectedAnswer = 2
            
        }else{
            
            btn2.setImage(uncheck, for: .normal)
            
            selectedAnswer = 0
        }
    }
    
    @IBAction func btn3Action(_ sender: Any) {
        
        if(btn3.currentImage == uncheck){
            
            btn3.setImage(check, for: .normal)
            btn1.setImage(uncheck, for: .normal)
            btn2.setImage(uncheck, for: .normal)
            btn4.setImage(uncheck, for: .normal)
            btn5.setImage(uncheck, for: .normal)
            
            selectedAnswer = 3
            
        }else{
            
            btn3.setImage(uncheck, for: .normal)
            
            selectedAnswer = 0
        }
    }
    
    @IBAction func btn4Action(_ sender: Any) {
        
        if(btn4.currentImage == uncheck){
            
            btn4.setImage(check, for: .normal)
            btn1.setImage(uncheck, for: .normal)
            btn2.setImage(uncheck, for: .normal)
            btn3.setImage(uncheck, for: .normal)
            btn5.setImage(uncheck, for: .normal)
            
            selectedAnswer = 4
            
        }else{
            
            btn4.setImage(uncheck, for: .normal)
            
            selectedAnswer = 0
        }
    }
    @IBAction func btn5Action(_ sender: Any) {
        
        if(btn5.currentImage == uncheck){
            
            btn5.setImage(check, for: .normal)
            btn1.setImage(uncheck, for: .normal)
            btn2.setImage(uncheck, for: .normal)
            btn3.setImage(uncheck, for: .normal)
            btn4.setImage(uncheck, for: .normal)
            
            selectedAnswer = 5
            
        }else{
            
            btn5.setImage(uncheck, for: .normal)
            
            selectedAnswer = 0
        }
    }

    
    
    var questionArray = [String]()
    var answerArray = [Int]()
    var countArray = [String]()
    
    var counter: Int = 0
    var selectedAnswer: Int = 0
    func fadeIn(withDuration duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.view.alpha = 1.0
        })
    }

    @IBAction func nextBtnAction(_ sender: Any) {
        
        if(counter < 4){
            
            print(counter)
            
            if((btn1.currentImage == uncheck)&&(btn2.currentImage == uncheck)&&(btn3.currentImage == uncheck)&&(btn4.currentImage == uncheck)&&(btn5.currentImage == uncheck)){
                
                self.showAlert(Message: "Provide your Feedback")
                
                //            counter += 1
                //            answerArray.append(selectedAnswer)
                //            btn5.setImage(uncheck, for: .normal)
                //            btn1.setImage(uncheck, for: .normal)
                //            btn2.setImage(uncheck, for: .normal)
                //            btn3.setImage(uncheck, for: .normal)
                //            btn4.setImage(uncheck, for: .normal)
                //            selectedAnswer = 0
                //            print(answerArray)
            }else{
                //self.view.alpha = 0.5
                counter += 1
                questionLB.text = questionArray[counter]
                countLabel.text = countArray[counter]
                answerArray.append(selectedAnswer)
                btn5.setImage(uncheck, for: .normal)
                btn1.setImage(uncheck, for: .normal)
                btn2.setImage(uncheck, for: .normal)
                btn3.setImage(uncheck, for: .normal)
                btn4.setImage(uncheck, for: .normal)
                selectedAnswer = 0
//                self.view.frame = CGRect(x: screenWidth, y: 0 , width: screenWidth, height: screenHeight)
//                
//                UIView.animate(withDuration: 0.50, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
//                    //Set x position what ever you want
//                    self.view.frame = CGRect(x: 0, y: 0 , width: screenWidth, height: screenHeight)
//                    
//                }, completion: nil)
                print(answerArray)
            }
        
        }else{
            
            answerArray.append(selectedAnswer)
            btn5.setImage(uncheck, for: .normal)
            btn1.setImage(uncheck, for: .normal)
            btn2.setImage(uncheck, for: .normal)
            btn3.setImage(uncheck, for: .normal)
            btn4.setImage(uncheck, for: .normal)
            selectedAnswer = 0

            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "comments") as! CommentsViewController
            secondViewController.ansArray = self.answerArray
            secondViewController.meetId = meetingID
            secondViewController.isSubscribed = self.isSubscribed
            self.navigationController?.pushViewController(secondViewController, animated: true)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         navigationItem.hidesBackButton = true

        questionArray = ["The instructor presented the content effectively","The instructor encouraged interaction","The learning objectives were clearly presented and achieved.","I feel this session was a valuable use of my time.","Overall training feedback"]
        
        countArray = ["1 of 5", "2 of 5","3 of 5","4 of 5","5 of 5"]
        
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
        
    
        questionLB.text = questionArray[0]
        countLabel.text = countArray[0]
        //counter += 1
        
        
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
//        stronglyDisagreeLabel.isUserInteractionEnabled = true
//        var tag = stronglyDisagreeLabel.tag
//        stronglyDisagreeLabel.addGestureRecognizer(tap)
    }
    
//    func tapFunction(sender:UITapGestureRecognizer, tag: Int) {
//        print("tap working")
//        
//        if(tag == 1){
//            if(btn1.currentImage == uncheck){
//                
//                btn1.setImage(check, for: .normal)
//                btn2.setImage(uncheck, for: .normal)
//                btn3.setImage(uncheck, for: .normal)
//                btn4.setImage(uncheck, for: .normal)
//                btn5.setImage(uncheck, for: .normal)
//                
//                selectedAnswer = 1
//                
//            }else{
//                
//                btn1.setImage(uncheck, for: .normal)
//                
//                selectedAnswer = 0
//            }
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        self.title = "FeedBack"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.title = ""
    }
    
    
    func showAlert(Message: String)
    {
        let alert = UIAlertController(title:"Meeting App", message:Message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
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
