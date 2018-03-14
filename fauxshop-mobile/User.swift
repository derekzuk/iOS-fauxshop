//
//  User.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/13/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import Foundation

struct User: Decodable {

    let id: Int
    let login: String
//    let firstName: String -- these values can be null and it causes problems when we decode the json
//    let lastName: String
    let email: String
//    let imageUrl: String
    let activated: Bool
    let langKey: String
    let createdBy: String
    let createdDate: String
    let lastModifiedBy: String
    let lastModifiedDate: String
    let authorities: [String]
}
