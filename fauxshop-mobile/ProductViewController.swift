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
    var product: Products?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        cell.imageView.image = UIImage(named: products[indexPath.row].productsImageMobile)
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        
        self.product = products[indexPath.item]
        self.performSegue(withIdentifier: "showProductDetail", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showProductDetail") {
            let productDetailViewController = segue.destination as! ProductDetailViewController

            productDetailViewController.product = self.product!
        }
        
    }
}
