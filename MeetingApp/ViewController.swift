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


open class Indicator {
    var window :UIWindow = UIApplication.shared.keyWindow!
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    class var sharedInstance: Indicator {
        struct Static {
            static let sharedInstance: Indicator = Indicator()
        }
        return Static.sharedInstance
    }
    
    
    
    open func startActivityIndicator() {
        
        activityIndicator.hidesWhenStopped = true;
        activityIndicator.activityIndicatorViewStyle  = UIActivityIndicatorViewStyle.gray;
        activityIndicator.center = window.center;
        activityIndicator.startAnimating();
        window.addSubview(activityIndicator)
    }
    
    open func stopActivityIndicator() {
        
        activityIndicator.stopAnimating();
        window.removeFromSuperview()
        
    }
    
    
}


var ref: FIRDatabaseReference!

class ViewController: UIViewController,UIGestureRecognizerDelegate,UITextFieldDelegate {

    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var empIdTextField: UITextField!
    
    var deviceToken = ""
    
    @IBAction func signINBtnAction(_ sender: Any) {
        
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        
//        if(self.isValidEmail(testStr: self.emailTextField.text!)){
        
        if(empIdTextField.text != "" && empIdTextField.text?.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil){
            
            
            UserDefaults.standard.set(empIdTextField.text, forKey: "empID")
            
            ref = FIRDatabase.database().reference()
            addUser()
        
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "userMeeting") as! UserMeetingViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)
            
            
        }else{
            self.showAlert(Message: "Enter Valid Employee ID")
        }
//        }else{
//            self.showAlert(Message: "Enter Valid Email")
//        }
    }
    
    func createMeeting() {
        
        let meetItem = meetingItem(mname: "ex1", mdate: "234566", mtimestart: "", mtimeend: "", mvenue: "",mid: "2",meetingCode: "1235", maxCount: "89",currentCount: "2",isexpired: "0",instructName: "Kate",instructempId: "107345", meetingType : "0",completed: true, key: "")
        
        let groceryItemRef = ref.child("Meetings")
        
        groceryItemRef.childByAutoId().setValue(meetItem.toAnyObject())
        
        
    }
    func addUser() {
        if let token = UserDefaults.standard.value(forKey: "token") as? String{
            deviceToken = token
        }
        
        let user = Users.init(deviceToken: deviceToken, empId: self.empIdTextField.text!, isAdmin: "0", deviceType: "0", key: "")
        
        let usr = ref.child("Users").child(self.empIdTextField.text!)
        usr.setValue(user.toAnyObject())
    }

    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    @IBOutlet weak var signinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(deviceToken)
        
        self.loginScrollView.contentInset = UIEdgeInsets.zero
        self.loginScrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
        self.view.addGestureRecognizer(tapGesture)
        
        empIdTextField.delegate = self
        emailTextField.delegate = self
        
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
        let alert = UIAlertController(title:"Meeting App", message:Message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Signup"
        if let username = UserDefaults.standard.value(forKey: "empID") as? String{
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "userMeeting") as! UserMeetingViewController
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let nav = UINavigationController(rootViewController: secondViewController)
            appdelegate.window!.rootViewController = nav
            
        }
        registerKeyboardNotifications()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        unregisterKeyboardNotifications()
    }
    
    func handleTap(gesture: UITapGestureRecognizer){
        empIdTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        emailTextField.resignFirstResponder()
        return true
    }
    
    func doneClicked(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = self.empIdTextField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= 6
    }
    
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardDidShow(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
        //        let contentInsets = UIEdgeInsetsMake(0, 0, 200, 0)
        //        self.loginScrollView.contentInset = contentInsets
        //        self.loginScrollView.scrollIndicatorInsets = contentInsets
        
        var contentInset:UIEdgeInsets = self.loginScrollView.contentInset
        contentInset.bottom = keyboardSize.height
        self.loginScrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
        var contentInset:UIEdgeInsets = self.loginScrollView.contentInset
        contentInset.bottom = -keyboardSize.height
        self.loginScrollView.contentInset = contentInset
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}

