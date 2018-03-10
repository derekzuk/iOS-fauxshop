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
    
    // We hide the Back button here
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
    
        
        
        // TODO: this works, but we need it to return an alarm if the request fails
        let registerDictionary = [
            "login": userEmail,
            "email": userEmail,
            "password": userPassword,
            "langKey": "en"
        ]
        let url = URL(string: "http://localhost:8080/api/register")!
        let headers = [ "Content-Type": "application/json" ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: registerDictionary)
        request.allHTTPHeaderFields = headers
        
        // This is the actual REST API call. There's a more condensed method if you use Alamofire
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                // This doesn't seem to return anything
                print(responseJSON)
            }
        }
        task.resume()
    }

    func displayAlertMessage(userMessage:String) {
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }

}
