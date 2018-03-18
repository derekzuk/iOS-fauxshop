//
//  CartViewController.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/13/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import UIKit
import KeychainSwift
import JWT

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var CartEmpty: UIView!
    @IBOutlet weak var CartPopulated: CartPopulatedView!
    @IBOutlet weak var CartTable: UITableView!
    @IBOutlet weak var cartTableView: UITableView!    
    
    let keychain = KeychainSwift()
    var cart = [Cart]()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < cart.count){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableCell", for: indexPath) as! CustomCartTableViewCell
            
            // Establish functionality for add and remove buttons
            cell.removeButton.addTarget(self, action: #selector(self.removeButtonTapped(_:)), for: .touchUpInside)
            cell.addButton.addTarget(self, action: #selector(self.addButtonTapped(_:)), for: .touchUpInside)
            
            // Populate table cell data
            cell.itemName.text = cart[indexPath.row].productsName
            cell.itemImage.image = UIImage(named: cart[indexPath.row].productsImageMobile)
            cell.itemDescription.text = cart[indexPath.row].productsDescription
            cell.cellPrice.text = String(cart[indexPath.row].cartItemTotalPrice)
            return cell
        } else {
            // final cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartFinalCell", for: indexPath) as! CustomCartTableViewCell
            print("in final cell")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150.0;//Choose your custom row height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cartTableView.dataSource = self
        
        CartEmpty.isHidden = true;
        CartPopulated.isHidden = true;
        
        retrieveCart()

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
        print("in retrieveCart()")
        let id = keychain.get("id")!
        let url = URL(string: "http://localhost:8080/api/cart/\(id)")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print(error ?? "Error encountered printing the error")
                return
            }
            do {
                self.cart = try JSONDecoder().decode([Cart].self, from: data!)
                print(self.cart)
            } catch {
                print(error)
            }
            
            DispatchQueue.main.async {
                self.cartTableView.reloadData()
            }
            
        }.resume()
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: cartTableView as UIView)
        let indexPath: IndexPath! = cartTableView.indexPathForRow(at: point)
        
        print("row is = \(indexPath.row)")
    }
    
    @objc func removeButtonTapped(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: cartTableView as UIView)
        let indexPath: IndexPath! = cartTableView.indexPathForRow(at: point)
        
        let cartId = cart[indexPath.row].cartId
        removeItemFromCart(cartId: cartId)
        
        print("row is = \(indexPath.row)")
    }
    
    func removeItemFromCart(cartId: Int) {
        let url = URL(string: "http://localhost:8080/api/cart/\(cartId)")!
        let headers = [ "Content-Type": "application/json" ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if (200 ... 299 ~= httpResponse.statusCode) {
                    // Cart item was successfuly removed
                    // TODO: update the cart listing
                } else {
                    // Fail
                print("Error removing item from cart: \(httpResponse.statusCode)")
                }
            }
        }
        task.resume()
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
