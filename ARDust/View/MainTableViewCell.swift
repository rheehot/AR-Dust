//
//  MainTableViewCell.swift
//  ARDust
//
//  Created by youngjun goo on 24/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit


class TableViewCellContents {
    var airData: AirData
    
    init(data: AirData) {
        self.airData = data
    }
}

class MainTableViewCell: UITableViewCell {
    
    private var airPollution : AirPollutionData?
    
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var pm10Label: UILabel!      //미세먼지
    @IBOutlet weak var pm25Label: UILabel!      //초미세먼지
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(_ content: TableViewCellContents) {
        
        print(content.airData as Any)
        self.locationName.text = content.airData.locationName
        self.airPollution = content.airData.airPollutionData
        
        prepareCell()        
    }
    
    private func prepareCell() {
        self.pm10Label.text = self.airPollution?.pm10Value
        self.pm25Label.text = self.airPollution?.pm25Value
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
