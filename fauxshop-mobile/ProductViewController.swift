//
//  ProductViewController.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/7/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var products = [Products]()
    var productId = 0;
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        productId = 0
        
        collectionView.dataSource = self
        
        // Retrieve Products
        retrieveProducts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        let priceValue = products[indexPath.row].productsPrice
        cell.price.text = String(format: "$%.02f", priceValue)
        cell.productDescription.text = products[indexPath.row].productsName
        
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        self.productId = indexPath.item + 1
    }
    
    func retrieveProducts() {
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
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let productDetailViewController = segue.destination as! ProductDetailViewController
        
        productDetailViewController.productId = self.productId
    }
}
