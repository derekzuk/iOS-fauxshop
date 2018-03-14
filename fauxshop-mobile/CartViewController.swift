//
//  CartViewController.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/13/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import UIKit
import KeychainSwift

class CartViewController: UIViewController {

    @IBOutlet weak var CartEmpty: UIView!
    @IBOutlet weak var CartPopulated: UIView!
    
    let keychain = KeychainSwift()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CartEmpty.isHidden = true;
        CartPopulated.isHidden = true;

        let isUserLoggedIn = (keychain.get("authenticationToken") != nil)
        if (!isUserLoggedIn){
            CartEmpty.isHidden = false;
            CartPopulated.isHidden = true;
        } else {
            // TODO: Retrieve Cart Items
            CartEmpty.isHidden = true;
            CartPopulated.isHidden = false;
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
    
    func retrieveCart() {
        let url = URL(string: "http://localhost:8080/api/products")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil {
                print(error ?? "Error encountered printing the error")
                return
            }
            
            do {
                self.products = try JSONDecoder().decode([Products].self, from: data!)
            } catch {
                print(error)
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
            }.resume()
        
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
