//
//  StudentTableViewCell.swift
//  RateMyStudentDB
//
//  Created by Amnuay M on 9/11/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
