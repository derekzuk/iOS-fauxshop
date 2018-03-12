//
//  LoginViewController.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/9/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import UIKit
import JWT

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
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
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        let userEmail = userEmailTextField.text!
        let userPassword = userPasswordTextField.text!
        
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
        
        // There is a more condensed method if you use Alamofire
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (200 ... 299 ~= httpResponse.statusCode) {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        
                        do {
                            let hash = responseJSON["id_token"] as? String
                            print(hash!)
                            
                            let secret = Data(base64Encoded: "abcdefg12345", options: [])
                            let decoded = try JWT.decode(hash!, algorithm: .hs512(secret! as Data))
                            
                            print("successfully decoded")
                            print(decoded)
                            UserDefaults.standard.set(true, forKey:"isUserLoggedIn")
                            UserDefaults.standard.synchronize()
                        } catch {
                            print("Failed to decode JWT: \(error)")
                        }
                        
                    }
                    
                } else {
                    // Fail
                    print("error \(httpResponse.statusCode)")
                }
            }
            
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                // This doesn't seem to return anything
//                print(responseJSON)
//            }
        }
        task.resume()
        
        // TODO: we only want this to happen if login is successful
        let initialLoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "initialLoginViewControllerIdentifier")
        self.navigationController?.pushViewController(initialLoginViewController!, animated: true)
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
