//
//  Cart.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/13/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import Foundation

struct Cart: Decodable {
    
    let cartId: Int
    let id: Int
    let cartItemQuantity: Int
    let cartItemTotalPrice: Double
    let productsId: Int
    let productsQuantity: Int
    let productsModel: String
    let productsImage: String
    let productsImageMobile: String
    let productsPrice: Int
    let productsDateAdded: String
    let productsLastModified: String
    let productsDateAvailable: String
    let productsWeight: Int
    let productsStatus: Bool
    let productsTaxClassId: Int
    let manufacturersId: Int
    let productsDescription: String
    let productsName: String
    let productsURL: String
    let productsViewed: Int
}
