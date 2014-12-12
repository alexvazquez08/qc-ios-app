//
//  Login.swift
//  BCBS
//
//  Created by Alejandro Vazquez on 12/11/14.
//  Copyright (c) 2014 Alex Vazquez. All rights reserved.
//

import UIKit
import Foundation

//Login credential setup
let clientId = "fdc66a9b-334d-4ae8-b51a-7d5abee673bc"
let clientSecret = "9bb06d8d-bd3d-455d-b632-115b5b1a6917"
let clientCredentials = NSString(format: "%@:%@", clientId, clientSecret)
let clientCredentialData: NSData = clientCredentials.dataUsingEncoding(NSUTF8StringEncoding)!
let base64clientCredentials = clientCredentialData.base64EncodedStringWithOptions(nil)


//Create blank request
//var request: NSMutableURLRequest = NSMutableURLRequest()

//var loginSuccess : Bool = Bool()

class Login : UIViewController {
 
    //var loginSuccess : Bool?
    //var loginSuccess = States.LoginStates.loginSuccess
    
    /*private struct loginState { static var loginSuccess: Bool = false }
    
    class var loginStateVar: Bool
        {
        get { return loginState.loginSuccess }
        set { loginState.loginSuccess = newValue}
    }*/
    
    var loginSuccess : Bool = false
    var accessToken : String?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        self.navigationController?.navigationBar.hidden = true
        super.viewDidLoad()
        
    }
    
    @IBAction func onPushSignIn(sender: UIButton) {
        println("Clicked sign in")
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "gotoHome") {
            
            println("Preparing to go to Home screen")
            var homeVC = segue.destinationViewController as Home
            println(accessToken!)
            homeVC.token = accessToken
            //homeVC.token =
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String!, sender: AnyObject!) -> Bool {
        
        if identifier == "gotoHome" {
            
            var emailText = emailTextField.text
            var passwordText = passwordTextField.text
            
            let urlPath: String = "https://app.quantifiedcare.com/oauth/token"
            var url: NSURL = NSURL(string: urlPath)!
            
            let requestParameters : String = "grant_type=password&username=\(emailText)&password=\(passwordText)"
            let requestParameterData = requestParameters.dataUsingEncoding(NSUTF8StringEncoding)
            
            var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
            
            request.setValue("Basic \(base64clientCredentials)", forHTTPHeaderField : "Authorization")
            request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
            request.HTTPMethod = "POST"
            request.HTTPBody = requestParameterData
            
            var response : AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
            var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)!
            var err: NSError
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            println("\(jsonResult)")

            let token = jsonResult.valueForKey("access_token")
            
            accessToken = "\(token!)"
            
            //If returns nil, then error with login
            if (token == nil) {
                println("Login Failed")
                
                let alert = UIAlertController(title: "Invalid Login", message: "You entered an invalid email/password. Try Again.", preferredStyle: .Alert)
                
                alert.addAction(UIAlertAction(title: "Okay", style: .Default, handler: {
                    (action: UIAlertAction!)->Void in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
                loginSuccess = false
                
            }
                
                //login successful
            else {
                //self.loginFailMessage.text = "Login Success!"
                loginSuccess = true
                
                println("Login success")
                let expirationTime = jsonResult.valueForKey("expires_in")
                
                //self.loginSuccess = true
            }

                     ///////////////////////////////////////////////////////////////////////
                    //Code for accessing resource data with retrieved access token
                    /*var resourcePath : String = "https://app.quantifiedcare.com/userinfo"
                    
                    var resourceURL: NSURL = NSURL(string: resourcePath)!
                    
                    let resourceRequest = NSMutableURLRequest(URL: resourceURL)
                    resourceRequest.setValue("Bearer \(token!)", forHTTPHeaderField : "Authorization")
                    //resourceRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
                    resourceRequest.HTTPMethod = "GET"
                    
                    NSURLConnection.sendAsynchronousRequest(resourceRequest, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                        var err: NSError
                        var resourcejSonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                        println("\(resourcejSonResult)")
                        
                    })*/
            
            //Authorization successful, so proceed to home screen
            if loginSuccess == true {
                println("loginSuccess is true")
                return true
                
            }
            
            //Authorization not successful, so do not proceed to home screen and show failed alert
            else {
                return false
            }
            
            
        }
        
        else if identifier == "gotoForgotPassword" {
            return true
        }
        
        else {
            return true
        }
            
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

