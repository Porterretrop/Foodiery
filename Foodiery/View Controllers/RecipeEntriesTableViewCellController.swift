//
//  RecipeEntriesTableViewCellController.swift
//  Foodiery
//
//  Created by Porter Wang on 2020/6/16.
//  Copyright © 2020 C323 SU2020. All rights reserved.
//

import UIKit

class RecipeEntriesTableViewCellController: UITableViewCell {

    // View Objects linked.
    @IBOutlet var recipeTitleLabel: UILabel!
    @IBOutlet var recipeDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
