//
//  CustomCaseTableViewCell.swift
//  MedCaser
//
//  Created by Tingbo Chen on 1/4/16.
//  Copyright © 2016 Tingbo Chen. All rights reserved.
//

import UIKit

class CustomCaseTableViewCell: UITableViewCell {

    @IBOutlet weak var caseNameLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        resetButton.layer.cornerRadius = 10
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
