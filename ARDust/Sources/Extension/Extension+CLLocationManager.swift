//
//  Extension+CLLocationManager.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import CoreLocation

extension CLLocationManagerDelegate {
    
    func getCurrentLocation(_ location: CLLocation, completion: @escaping (Bool, LocationData?) -> Void) {
      
        let geoCoder = CLGeocoder()
        
        if #available(iOS 12.0, *) {
            geoCoder.reverseGeocodeLocation(location, preferredLocale: Locale.init(identifier: "KR")) { (placemarks, error) in
                guard let placemark = placemarks?.first, error == nil else {
                    completion(false, nil)
                    return
                }
                if let currentLocation = self.createCurrentLocationData(location, placemark: placemark) {
                    completion(true, currentLocation)
                    return
                } else {
                    print("geocoder 실패")
                    completion(false, nil)
                }
               
            }
        } else {

            UserDefaults.standard.set(["KR"], forKey: "AppleLanguages")
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                UserDefaults.standard.removeObject(forKey: "AppleLanguages")
                guard let placemark = placemarks?.first, error == nil else {
                    completion(false, nil)
                    return
                }
                if let currentLocationData = self.createCurrentLocationData(location, placemark: placemark) {
                    completion(true, currentLocationData)
                    return
                }
                completion(false, nil)
            }
        }
    }
    
    private func createCurrentLocationData(_ location: CLLocation, placemark: CLPlacemark) -> LocationData? {
        print(placemark)
        if let locality = placemark.locality,
            let subLocality = placemark.subLocality {
            let locationName = locality + " " + subLocality
            var currentLocationData = LocationData()
            currentLocationData.locationName = locationName
            currentLocationData.latitude = location.coordinate.latitude
            currentLocationData.longitude = location.coordinate.longitude
            currentLocationData.registerDate = Date()
            print(currentLocationData)
            return currentLocationData
        } else {
            print("현재 위치 데이터 생성 실패")
        }
        return nil
    }
}
