//
//  FavoritesViewController.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/10/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import UIKit

class FavoritesViewControllerNone: UIViewController, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
            if (!isUserLoggedIn){
                self.performSegue(withIdentifier: "favoritesNotLoggedInView", sender: self)
            } else {
                // User is logged in. Check if there are any favorites.
                let isPopulated = false;
                if (!isPopulated) {
                    // We're already here
                } else {
                    self.performSegue(withIdentifier: "favoritesLoggedInViewPopulated", sender: self)
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.delegate = self
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
