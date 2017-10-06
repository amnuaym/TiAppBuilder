//
//  RestaurantTableViewCell.swift
//  RateMyRestaurant
//
//  Created by Worasit Choochaiwattana on 11/25/2559 BE.
//  Copyright © 2559 Worasit Choochaiwattana. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgRestaurant: UIImageView!
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblRestaurantLocation: UILabel!
    @IBOutlet weak var lblRatingScore: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
