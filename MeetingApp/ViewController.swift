//
//  ViewController.swift
//  MeetingApp
//
//  Created by Administrator on 31/01/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit
import  Firebase


let screenSize: CGRect = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height
var ref: FIRDatabaseReference!

class ViewController: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate {

    @IBOutlet weak var lineLB: UILabel!
    @IBOutlet weak var empIdTextField: UITextField!
    
    var deviceToken = UserDefaults.standard.value(forKey: "token")
    
    @IBAction func signINBtnAction(_ sender: Any) {
        
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        
        if(empIdTextField.text != "" && empIdTextField.text?.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil){
            
            
            UserDefaults.standard.set(empIdTextField.text, forKey: "empID")
            
            ref = FIRDatabase.database().reference()
            //addUser()
        
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "adminMeet") as! AdminMeetingsViewController
//        self.navigationController?.pushViewController(secondViewController, animated: true)
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "userMeeting") as! UserMeetingViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
            
            
        }else{
            self.showAlert(Message: "Enter Valid Employee ID")
        }
        
    }
    
    func createMeeting() {
        
        let meetItem = meetingItem(mname: "ex1", mdate: "234566", mtimestart: "", mtimeend: "", mvenue: "",mid: "2",meetingCode: "1235", maxCount: "89",currentCount: "2",isexpired: "0",instructName: "Kate",instructempId: "107345", meetingType : "0",completed: true, key: "")
        
        let groceryItemRef = ref.child("Meetings")
        
        groceryItemRef.childByAutoId().setValue(meetItem.toAnyObject())
        
        
    }
    func addUser() {
        let user = Users.init(deviceToken: deviceToken as! String, empId: self.empIdTextField.text!, isAdmin: "0", deviceType: "0", key: "")
        
        let usr = ref.child("Users").child(self.empIdTextField.text!)
        usr.setValue(user.toAnyObject())
    }

    
    
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(deviceToken)
        
        var frm: CGRect = lineLB.frame
        
//        self.signinButton.translatesAutoresizingMaskIntoConstraints = true
//        self.signinButton.frame = CGRect(x: (screenWidth-103)/2, y: frm.origin.y+64, width: 103, height: 30)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        empIdTextField.delegate = self
        
        signinButton.layer.cornerRadius = 5.0
        signinButton.clipsToBounds = true
        
        
        let keyboardDoneButtonView = UIToolbar.init()
        keyboardDoneButtonView.sizeToFit()
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self,
                                              action: #selector(doneClicked))
        let doneButton1 = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace,
                                               target: nil,
                                               action: nil)
        doneButton1.width = screenWidth-80
        
        keyboardDoneButtonView.items = [doneButton1,doneButton]
        empIdTextField.inputAccessoryView = keyboardDoneButtonView
    }
    
    func showAlert(Message: String)
    {
        let alert = UIAlertController(title:"iMint", message:Message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Signup"
        
        
       
    }
    
    func handleTap(gesture: UITapGestureRecognizer){
        empIdTextField.resignFirstResponder()
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func doneClicked(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

