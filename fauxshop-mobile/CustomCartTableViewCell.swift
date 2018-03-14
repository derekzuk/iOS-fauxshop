//
//  CustomCartTableViewCell.swift
//  fauxshop-mobile
//
//  Created by Derek Zuk on 3/13/18.
//  Copyright © 2018 Derek Zuk. All rights reserved.
//

import UIKit

class CustomCartTableViewCell: UITableViewCell {

    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
