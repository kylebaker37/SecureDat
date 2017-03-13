//
//  RoommatesTableViewCell.swift
//  SecureDat
//
//  Created by Markus Notti on 3/12/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class RoommatesTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var atHomeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
