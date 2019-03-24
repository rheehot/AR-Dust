//
//  MainTableViewCell.swift
//  ARDust
//
//  Created by youngjun goo on 24/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    var airData: AirData?
    
    @IBOutlet weak var pm10Label: UILabel!     {
        didSet {
            pm10Label.text = airData?.airPollutionData.pm10Value
        }
    }     //미세먼지
    @IBOutlet weak var pm25Label: UILabel!   {
        didSet {
            pm25Label.text = airData?.airPollutionData.pm25Value
        }
    }       //초미세먼지

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
