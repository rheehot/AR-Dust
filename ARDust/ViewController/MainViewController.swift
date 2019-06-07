//
//  ViewController.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit
import SpriteKit
import CoreLocation


class MainViewController: UIViewController {
    
    
    // MARK:- Properties
    var airData: AirData?   // Test 용
    private var airPollution: AirPollutionData?
    var locationData = LocationData()
    private var dataSource = [TableViewCellContents]()
    private var locationManager =  CLLocationManager()
    private let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    private var locationRequestCompletion = false
    private let manager = CLLocationManager()
    private var tapGesture = UITapGestureRecognizer()
    
    private var skView: SKView!
    
    // MARK:- IBOutlet
    @IBOutlet weak var arButton: UIButton!
    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var pm10Label: UILabel!      //미세먼지
    @IBOutlet weak var pm25Label: UILabel!      //초미세먼지
    @IBOutlet weak var pollutionStateLabel: UILabel!
    @IBOutlet weak var networkSpinner: UIActivityIndicatorView!

    @IBOutlet weak var dustStackView: UIStackView! {
        didSet {
            self.dustStackView?.hero.id = "dust"
            self.dustStackView.layer.cornerRadius = 10
            self.dustStackView.clipsToBounds = true
        }
    }
    @IBOutlet weak var fineDustStackView: UIStackView! {
        didSet {
            self.fineDustStackView?.hero.id = "fineDust"
            self.fineDustStackView.layer.cornerRadius = 10
            self.fineDustStackView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var blueView: UIView! {
        didSet {
            self.blueView?.hero.id = "ironMan"
            self.blueView?.layer.cornerRadius = 10
            self.blueView.clipsToBounds = true
        }
    }
    @IBOutlet weak var grayView: UIView! {
        didSet {
            self.grayView?.hero.id = "batMan"
            self.grayView.layer.cornerRadius = 10
            self.grayView.clipsToBounds = true
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
    
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.openDetailVC))
        self.tapGesture.numberOfTapsRequired = 1
        self.blueView.addGestureRecognizer(self.tapGesture)
        self.blueView.isUserInteractionEnabled = true
    
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
            locationManager.requestLocation()
        }
        
    }
    
    func setUpDustInfoView() {
        self.locationName.text = dataSource[0].airData.locationName + "의 공기는"
        self.pm10Label.text = self.airPollution?.pm10Value
        self.pm25Label.text = self.airPollution?.pm25Value
        self.pollutionStateLabel.text = self.airPollution?.pollutionState
        self.blueView.backgroundColor = self.airPollution?.pollutionStateColor
    }
    
    func setUpDustScene(pollutionState: String) {
        let scene = DustScene(size: CGSize(width: 1050, height: 1920))
        scene.scaleMode = .fill
        scene.addEmitter(pollutionState: pollutionState)
        skView = self.behindView as? SKView
        skView.presentScene(scene)
    }
    
    @objc func openDetailVC() {
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            present(detailVC, animated: true, completion: nil)
        }
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
        if let _ = locations.first, !locationRequestCompletion {
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
                            self.airPollution = self.dataSource[0].airData.airPollutionData
                            self.setUpDustInfoView()
                            self.setUpDustScene(pollutionState: self.airPollution!.pollutionState)
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
