//
//  InitialLoginViewController.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/9/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import UIKit
import JWT
import KeychainSwift

class PersonalLoginRegistration: UIViewController {

    @IBOutlet weak var Personal: UIView!
    @IBOutlet weak var Login: UIView!
    @IBOutlet weak var Register: UIView!
    
    var user: User?
    let keychain = KeychainSwift()
    
    // Personal View
    @IBAction func logoutButtonTapped(_ sender: Any) {
        keychain.delete("isUserLoggedIn")
        keychain.delete("authenticationToken")
        
        displayLoginView()
    }
    
    
    // Login View
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        displayRegisterView()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let userEmail = emailText.text!
        let userPassword = passwordText.text!
        
        let loginDictionary = [
            "username": userEmail,
            "password": userPassword,
            "rememberMe": true
            ] as [String : Any]
        let url = URL(string: "http://localhost:8080/api/authenticate")!
        let headers = [ "Content-Type": "application/json" ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: loginDictionary)
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (200 ... 299 ~= httpResponse.statusCode) {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        
                        do {
                            let hash = responseJSON["id_token"] as? String
                            
                            let secret = Data(base64Encoded: "abcdefg12345", options: [])
                            let decoded = try JWT.decode(hash!, algorithm: .hs512(secret! as Data))
                            let login = decoded["sub"]
                            let auth = decoded["auth"]
                            
                            // Set the user data to be used in other API calls
                            self.setUser(login:login as! String, userPassword:userPassword)
                            
                            self.keychain.set(hash!, forKey: "authenticationToken")
                            self.keychain.set(true, forKey: "isUserLoggedIn")
                            self.keychain.set(String(describing: login!), forKey: "login")
                            self.keychain.set(String(describing: auth!), forKey: "auth")
                            
                            // Navigate to Personal View after login is successful
                            DispatchQueue.main.async() { () -> Void in
                                self.displayPersonalView()
                            }
                        } catch {
                            print("Failed to decode JWT: \(error)")
                        }
                    }
                } else {
                    // Fail
                    print("error \(httpResponse.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    func setUser(login: String, userPassword: String) {
        let url = URL(string: "http://localhost:8080/api/account/\(login)/\(userPassword)")!
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("error in setUser")
                print(error ?? "Error encountered printing the error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if (200 ... 299 ~= httpResponse.statusCode) {
                    do {
                        self.user = try JSONDecoder().decode(User.self, from: data!)
                        self.keychain.set(String(self.user!.id), forKey: "id")
                        self.keychain.set(self.user!.login, forKey: "login")
                    } catch {
                        print("error decoding")
                        print(error)
                    }
                } else {
                    print("service call not successful")
                }
            }
        }.resume()
    }
    
    
    // Register View
    @IBOutlet weak var registerEmailText: UITextField!
    @IBOutlet weak var registerPasswordText: UITextField!
    @IBOutlet weak var registerRepeatPasswordText: UITextField!
    
    @IBAction func backToLoginPageTapped(_ sender: Any) {
        displayLoginView()
    }
    
    
    // TODO: this method needs work
    @IBAction func registerViewButtonTapped(_ sender: Any) {
        let userEmail = registerEmailText.text!
        let userPassword = registerPasswordText.text!
        let userRepeatPassword = registerRepeatPasswordText.text!
        
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
        keychain.set(userEmail, forKey: "userEmail")
        keychain.set(userPassword, forKey: "userPassword")
        
        // Display alert message with confirmation
        let myAlert = UIAlertController(title:"Success", message:"Registration is successful", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            (action) in
            self.displayLoginView()
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
    
    
    // We hide the Back button here
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationItem.hidesBackButton = true
        
        hideAllViews()
        
        let isUserLoggedIn = (keychain.get("authenticationToken") != nil)
        if (isUserLoggedIn){
            displayPersonalView()
        } else {
            displayLoginView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func displayAlertMessage(userMessage:String) {
        let myAlert = UIAlertController(title:"Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func hideAllViews() {
        Personal.isHidden = true
        Login.isHidden = true
        Register.isHidden = true
    }
    
    func displayPersonalView() {
        Login.isHidden = true
        Personal.isHidden = false
        Register.isHidden = true
    }
    
    func displayLoginView() {
        Login.isHidden = false
        Personal.isHidden = true
        Register.isHidden = true
    }
    
    func displayRegisterView() {
        Login.isHidden = true
        Personal.isHidden = true
        Register.isHidden = false
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
