//
//  StationTableViewCell.swift
//  MapTesting
//
//  Created by Camilo Rivas on 20-02-18.
//  Copyright © 2018 Camilo Rivas. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var communeLabel: UILabel!
    @IBOutlet weak var gas93PriceLabel: UILabel!
    @IBOutlet weak var gas95PriceLabel: UILabel!
    @IBOutlet weak var gas97PriceLabel: UILabel!
    var station : Station?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
