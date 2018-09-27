//
//  StateListCell.swift
//  PieDistrictDemo
//
//  Created by Anoop on 21/04/18.
//  Copyright © 2018 Anoop. All rights reserved.
//

import UIKit

class StateListCell: UITableViewCell {

    @IBOutlet weak var areaLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var capitalLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
