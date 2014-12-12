//
//  Home.swift
//  BCBS
//
//  Created by Alejandro Vazquez on 12/11/14.
//  Copyright (c) 2014 Alex Vazquez. All rights reserved.
//

import UIKit

class Home: UIViewController {

    var userName : String = String()
    var token : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //nameLabel.text = token!
        
    ///////////////////////////////////////////////////////////////////////
    //Code for accessing resource data with retrieved access token
    var resourcePath : String = "https://app.quantifiedcare.com/userinfo"

    var resourceURL: NSURL = NSURL(string: resourcePath)!

    let resourceRequest = NSMutableURLRequest(URL: resourceURL)
    
    resourceRequest.setValue("Bearer \(token!)", forHTTPHeaderField : "Authorization")
    //resourceRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
    resourceRequest.HTTPMethod = "GET"

    var response : AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
    var dataVal : NSData =  NSURLConnection.sendSynchronousRequest(resourceRequest, returningResponse: response, error:nil)!
    var err : NSError
    var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
    
    println("\(jsonResult)")
    
    let name = jsonResult.valueForKey("name")
    let firstName = name?.valueForKey("firstName")
    let lastName = name?.valueForKey("lastName")
        
    println("User Name: \(firstName!) \(lastName!)")
    
    nameLabel.text = "\(firstName!) \(lastName!)"
        
        // Do any additional setup after loading the view.
    }
    @IBAction func onPushLogout(sender: UIButton) {
        println("Logging out...")
        
    }
    @IBOutlet weak var nameLabel: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
