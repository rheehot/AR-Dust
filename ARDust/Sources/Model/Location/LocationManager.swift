//
//  LocationManager.swift
//  ARDust
//
//  Created by youngjun goo on 01/04/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class LocationManager {
    
    private lazy var manageContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        return managedContext
    }()
    
    // CoreData 에 저장되어있는 객체를 불러오는 메서드
    func fetch() -> [LocationData] {
        var locationList = [LocationData]()
        // Location Model Object 선언
        let fetchRequest : NSFetchRequest<LocationMO> = LocationMO.fetchRequest()
        
        let dateSortList = NSSortDescriptor(key: "regdate", ascending: true)
        
        fetchRequest.sortDescriptors = [dateSortList]
        do {
            let result = try manageContext.fetch(fetchRequest)
            
            for managerObj in result {
                var data = LocationData()
                data.locationName = managerObj.locationName
                data.longitude = managerObj.longitude
                data.latitude = managerObj.latitude
                data.registerDate = managerObj.regdate
                data.objectID = managerObj.objectID
                
                locationList.append(data)
            }
        } catch {
            
        }
        return locationList
    }
    
    func insert(_ data: LocationData) {
        
        guard let managerObj = NSEntityDescription.insertNewObject(forEntityName: "Location", into: manageContext) as? LocationMO else {
            return
        }
        
        managerObj.locationName = data.locationName
        if let longtitude = data.longitude, let latitude = data.latitude {
            managerObj.longitude = longtitude
            managerObj.latitude = latitude
        }
        managerObj.regdate = data.registerDate
        
        do {
            try manageContext.save()
        } catch {
            manageContext.rollback()
        }
        
    }
    
    func delete(_ data: NSManagedObject) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manageContext = appDelegate.persistentContainer.viewContext
        
        manageContext.delete(data)
        
        do {
            try manageContext.save()
        } catch {
            manageContext.rollback()
        }
    }
}
