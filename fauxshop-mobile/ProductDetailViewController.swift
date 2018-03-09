//
//  ProductDetailViewController.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/9/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {

    var productId: Int?
    var product: Products?
    @IBOutlet weak var productName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("in ProductDetailViewController")
        print(self.productId ?? -1)
        productName.text = String(describing: self.productId!)
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
