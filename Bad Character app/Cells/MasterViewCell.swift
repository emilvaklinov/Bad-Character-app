//
//  MasterViewCell.swift
//  Bad Character app
//
//  Created by Emil Vaklinov on 04/08/2020.
//  Copyright © 2020 Emil Vaklinov. All rights reserved.
//

import UIKit

class MasterViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
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
