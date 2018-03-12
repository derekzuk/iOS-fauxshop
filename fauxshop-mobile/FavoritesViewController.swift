//
//  FavoritesNotLoggedInView.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/10/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var FavoritesPopulatedView: UIView!
    @IBOutlet weak var FavoritesNoneView: UIView!
    @IBOutlet weak var FavoritesNotLoggedInView: UIView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FavoritesPopulatedView.isHidden = true;
        FavoritesNoneView.isHidden = true;
        FavoritesNotLoggedInView.isHidden = true;
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if (!isUserLoggedIn){
            FavoritesNotLoggedInView.isHidden = false;
            FavoritesPopulatedView.isHidden = true;
            FavoritesNoneView.isHidden = true;
        } else {
            // User is logged in. Check if there are any favorites.
            let isPopulated = false;
            if (!isPopulated) {
                FavoritesNotLoggedInView.isHidden = true;
                FavoritesPopulatedView.isHidden = true;
                FavoritesNoneView.isHidden = false;
            } else {
                FavoritesNotLoggedInView.isHidden = true;
                FavoritesPopulatedView.isHidden = false;
                FavoritesNoneView.isHidden = true;
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in viewDidLoad()")

        FavoritesPopulatedView.isHidden = true;
        FavoritesNoneView.isHidden = true;
        FavoritesNotLoggedInView.isHidden = true;
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if (!isUserLoggedIn){
            FavoritesNotLoggedInView.isHidden = false;
            FavoritesPopulatedView.isHidden = true;
            FavoritesNoneView.isHidden = true;
        } else {
            // User is logged in. Check if there are any favorites.
            let isPopulated = false;
            if (!isPopulated) {
                FavoritesNotLoggedInView.isHidden = true;
                FavoritesPopulatedView.isHidden = true;
                FavoritesNoneView.isHidden = false;
            } else {
                FavoritesNotLoggedInView.isHidden = true;
                FavoritesPopulatedView.isHidden = false;
                FavoritesNoneView.isHidden = true;
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        tabBarController?.selectedIndex = 3 // Login button
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
