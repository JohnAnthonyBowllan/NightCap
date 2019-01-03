//
//  CustomCell.swift
//  STEM1.0
//
//  Created by STEM_Innovation on 7/28/17.
//  Copyright © 2017 Melody Cheung. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
