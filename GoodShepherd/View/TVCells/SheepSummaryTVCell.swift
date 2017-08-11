//
//  SheepSummaryTVCell.swift
//  GoodShepherd
//
//  Created by Term on 8/10/17.
//  Copyright © 2017 Term. All rights reserved.
//

import UIKit

class SheepSummaryTVCell: UITableViewCell {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var attendanceStatusLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
