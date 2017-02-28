//
//  MainViewCmmtViewController.swift
//  MeetingApp
//
//  Created by Administrator on 28/02/17.
//  Copyright © 2017 IngramMicro. All rights reserved.
//

import UIKit

class MainViewCmmtViewController: UIViewController,UIPageViewControllerDataSource {
    
    
    var questionarray: NSArray!
    var pageViewController: UIPageViewController!
    var meetingId:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.questionarray = NSArray(objects: "Please comment on any areas you especially liked about your training experience(inculding content,  instructor, facilities, equipments, registration process and communications).","Please comment on any areas where there are opportunities for improvement(inculding content, material, instructor, facilities, equipments, registration process and communications).")
        
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "pageViewCntrl") as! UIPageViewController
        self.pageViewController.dataSource = self
        var startVC = self.viewControllerAtIndex(index: 0) as ViewCommentsViewController
        var viewControllers = NSArray(object: startVC)
        
        self.pageViewController.setViewControllers(viewControllers as! [UIViewController], direction: .forward, animated: true, completion: nil)
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 28, width: self.view.frame.width, height: self.view.frame.height-28)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "View Comments"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewControllerAtIndex(index : Int) -> ViewCommentsViewController
    {
        
        if((self.questionarray.count == 0) || (index >= self.questionarray.count)){
            
            return ViewCommentsViewController()
        }
        
        var vc: ViewCommentsViewController = self.storyboard?.instantiateViewController(withIdentifier: "viewComment") as! ViewCommentsViewController
        
        vc.titleText = self.questionarray[index] as! String
        vc.pageIndex = index
        vc.meetingId = self.meetingId
        return vc
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! ViewCommentsViewController
        var index = vc.pageIndex as Int
        
        if(index == 0 || index == NSNotFound){
            
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! ViewCommentsViewController
        var index = vc.pageIndex as Int
        
        if(index == NSNotFound){
            
            return nil
        }
        
        index += 1
        
        if(index == self.questionarray.count){
            
            return nil
        }
        
        return self.viewControllerAtIndex(index: index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return self.questionarray.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0
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
