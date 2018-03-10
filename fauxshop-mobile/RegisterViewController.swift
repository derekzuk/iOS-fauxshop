//
//  RegisterViewController.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/9/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        let userEmail = userEmailTextField.text!
        let userPassword = userPasswordTextField.text!
        let userRepeatPassword = repeatPasswordTextField.text!
        
        // Check empty fields
        if ((userEmail.isEmpty) || (userPassword.isEmpty) || userRepeatPassword.isEmpty) {
            
            // Display alert message
            displayAlertMessage(userMessage: "All fields are required.")
            return
        }
        
            // Check if passwords match
        if (userPassword != userRepeatPassword) {
            // Display alert message
            displayAlertMessage(userMessage: "Passwords do not match.")
            return
        }
        
        // Store data
        UserDefaults.standard.set(userEmail,forKey:"userEmail")
        UserDefaults.standard.set(userPassword,forKey:"userPassword")
        UserDefaults.standard.synchronize()
        
        // Display alert message with confirmation
        let myAlert = UIAlertController(title:"Success", message:"Registration is successful", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            (action) in
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "loginViewIdentifier")
            self.navigationController?.pushViewController(loginViewController!, animated: true)
        })
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
        

    }

    func displayAlertMessage(userMessage:String) {
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }

}
