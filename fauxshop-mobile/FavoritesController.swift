//
//  FavoritesController.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/10/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import UIKit

class FavoritesController: UINavigationController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        if (!isUserLoggedIn){
            self.performSegue(withIdentifier: "favoritesNotLoggedInView", sender: self)
        } else {
            self.performSegue(withIdentifier: "favoritesView", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
