//
//  HistoryTableViewCell.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 7/6/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit

//Past challenge list items
class HistoryTableViewCell: UITableViewCell {

    //Outlets for previous challenge cell for referencing in main VC
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var hoursText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
