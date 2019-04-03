//
//  ViewController.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit
import CoreLocation


class MainViewController: UIViewController {
    
    var airData: AirData?   // Test 용
    var locationData = LocationData()
    private var dataSource = [TableViewCellContents]()
    private var locationManager =  CLLocationManager()
    private let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    private var locationRequestCompletion = false
    private let manager = CLLocationManager()
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.allowsSelection = true  
            tableView.separatorStyle = .none
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    @objc private func reloadData() {
        
        locationRequestCompletion = false
        manager.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            locationManager.requestLocation()
        }
        
        // Do any additional setup after loading the view.
    }

    
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // .requestLocation will only pass one location to the locations array
        // hence we can access it by taking the first element of the array
        
        
        print(locations)
        if let location = locations.first, !locationRequestCompletion {
            locationRequestCompletion = true
            getCurrentLocation(locations.first!) { (isSuccess, data) in
                if isSuccess, let currentLocation = data {
                    Request().getAirDataList(currentLocation) { (isSuccess, data, error) in
                        if isSuccess, let airDataList = data as? [AirData] {
                            print("성공")
                            self.airData = airDataList.first
                            self.appDelegate.airDataList = airDataList
                            self.dataSource.removeAll()
                            for airData in airDataList {
                                self.dataSource.append(TableViewCellContents(data:airData))
                            }
                            print(self.dataSource[0].airData.airPollutionData as Any)
                            self.tableView.reloadData()
                        } else {
                            print("AirData request 실패 ")
                            print(error?.localizedDescription as Any)
                            if let errorDescription = error?.errorDescription {
                                print(errorDescription)
                            }
                        }
                        
                    }
                } else {
                    print("실패")
                }
            }
        }
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell") as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        cell.updateCell(dataSource[indexPath.row])
        
        return cell
    }
    
    
}
