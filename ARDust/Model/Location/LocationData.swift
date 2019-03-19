//
//  LocationData.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation
import CoreData

struct LocationData {
    var locationName: String?       // 위치명
    var latitude: Double?           // 위도
    var longitude: Double?          // 경도
    var registerDate: Date?
    var objectID: NSManagedObjectID?
}
