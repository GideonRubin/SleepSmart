//
//  HistoryChartTableViewCell.swift
//  SleepSmart
//
//  Created by Gidi Rubin on 17/6/20.
//  Copyright © 2020 Gidi Rubin. All rights reserved.
//

import UIKit
import Charts

    //Current challenge progress table view cell
class HistoryChartTableViewCell: UITableViewCell {

    //Outlets for table cell
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var challengeChart: LineChartView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
