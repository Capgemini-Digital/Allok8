//
//  ViewController.swift
//  Allok8
//
//  Created by Test User 1 on 09/10/17.
//  Copyright © 2017 Capgemini. All rights reserved.
//

import UIKit
import FirebaseAuth

//"rajesh.sahani@capgemini.com"
// Allok8

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mUserNameField: UITextField!
    @IBOutlet weak var mPasswordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton.layer.cornerRadius = 3
        loginButton.layer.shadowRadius = 4
        loginButton.layer.shadowColor = UIColor.init(colorLiteralRed: 30/255, green: 140/255, blue: 170/255, alpha: 1).cgColor
        loginButton.layer.shadowOpacity = 0.8
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        loginButton.layer.masksToBounds = false
        
        mPasswordField.layer.cornerRadius = 3
        mUserNameField.layer.cornerRadius = 3
       // self.navigationItem.title = "Booked Employees"
        let userView = UIView()
        userView.frame = CGRect(x: 0, y: 0, width: 10, height: mUserNameField.frame.size.height)
        
        let passwordView = UIView()
        passwordView.frame = CGRect(x: 0, y: 0, width: 10, height: mPasswordField.frame.size.height)
        
        mUserNameField.leftViewMode = UITextFieldViewMode.always
        mPasswordField.leftViewMode = UITextFieldViewMode.always
        mUserNameField.leftView = userView
        mPasswordField.leftView = passwordView
        
        self.navigationController?.isNavigationBarHidden = true
        //"nagavishnu.kuncham@capgemini.com"
        //
        mUserNameField.text = "madhu.a.rao@capgemini.com"

        mPasswordField.text = "alloc8"
    }
    
    override func viewWillAppear(_ animated: Bool) {
       var handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
       

    }
   
    
    @IBAction func loginAction(_ sender: AnyObject) {
        self.performSegue (withIdentifier:"ShowLogin", sender: nil)
        
//        if let userName = mUserNameField.text , !userName.isEmpty,
//            let password = mPasswordField.text, !password.isEmpty {
//            
//            if self.isValidEmail(testStr: userName) {
//                self.view.endEditing(true)
//                setButtonStatus(state: false)
//                activityIndicator.startAnimating()
//                
//                Auth.auth().signIn(withEmail:userName , password:password) { [weak self](user, error) in
//                   self?.setButtonStatus(state: true)
//                    self?.activityIndicator.stopAnimating()
//                    
//                    if(error == nil) {
//                        self?.performSegue (withIdentifier:"ShowLogin", sender: nil)                        // Perform Next
//                    }
//                    else{
//                        // self?.performSegue (withIdentifier:"ShowLogin", sender: nil)
//                        self?.showloginErrorAlert()
//                    }
//                }
//                
//            }
//            else {
//                self.emailvalidation()
//            }
//            
//        }
//        else {
//            
//            self.loginvalidationAlert()
//        }
    }
    
    func setButtonStatus(state: Bool) {
        mUserNameField.isUserInteractionEnabled = state
        mPasswordField.isUserInteractionEnabled = state
        loginButton.isUserInteractionEnabled = state
    }
    
    // MARK: - Alert Code
    func showloginErrorAlert()  {
        let alertView = UIAlertController(title: "Alert", message: "Invalid user", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func loginvalidationAlert()  {
        let alertView = UIAlertController(title: "Alert", message: "Please enter the required fields", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    func emailvalidation()  {
        let alertView = UIAlertController(title: "Alert", message: "Please enter valid email id", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            
        })
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    func isValidEmail(testStr:String) -> Bool {
         //print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    override func viewWillDisappear(_ animated: Bool) {
       // Auth.auth().removeStateDidChangeListener(handle!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

