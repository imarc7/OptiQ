//
//  PlaceTableViewCell.swift
//  OptiQ
//
//  Created by Marc Ibrahim on 11/16/18.
//  Copyright © 2018 Marc Ibrahim. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var placeLogoImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
