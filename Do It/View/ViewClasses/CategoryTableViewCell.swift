//
//  CategoryTableViewCell.swift
//  Do It
//
//  Created by Michael Miles on 11/21/18.
//  Copyright © 2018 Michael Miles. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var soonestTaskLabel: UILabel!
    @IBOutlet weak var dateOfSoonTaskLabel: UILabel!
    @IBOutlet weak var timeOfSoonTaskLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
