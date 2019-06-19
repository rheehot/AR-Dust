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
    
    
    var startValue = 0
    var startValue2 = 0
    
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
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var arButton: UIButton!
    @IBOutlet weak var behindView: UIView!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var pm10Label: UILabel!      //미세먼지
    @IBOutlet weak var pm25Label: UILabel!      //초미세먼지
    @IBOutlet weak var pollutionStateLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let dateString = dateFormatter.string(from: date)
            
            self.timeLabel.text = dateString
        }
    }

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
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        appDelegate.shouldSupportAllOrientation = false
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
        self.grayView.addGestureRecognizer(self.tapGesture)
        self.grayView.isUserInteractionEnabled = true
    
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
    
    @objc func handleUpdate() {
        guard let endPm10Value = Int(self.airPollution!.pm10Value!) else {
            return
        }
        guard let endPm25Value = Int(self.airPollution!.pm25Value!) else {
            return
        }
        self.pm10Label.text = "\(startValue)"
        startValue += 1
        
        if startValue > endPm10Value {
            startValue = endPm10Value
        }
        
        self.pm25Label.text = "\(startValue2)"
        startValue2 += 1
        
        if startValue2 > endPm25Value {
            startValue2 = endPm25Value
        }
        
    }
    
    func setUpDustInfoView() {
        let displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink.add(to: .main, forMode: .default)
        displayLink.preferredFramesPerSecond = 30
        self.locationName.text = dataSource[0].airData.locationName + "의 공기는"
        self.pollutionStateLabel.text = self.airPollution?.pollutionState
        self.blueView.backgroundColor = self.airPollution?.pollutionStateColor
    }
    
    func setUpDustScene(pollutionState: String) {
        let scene = DustScene(size: CGSize(width: 1050, height: 1920))
        scene.pollutionState = pollutionState
        scene.scaleMode = .fill
        skView = self.behindView as? SKView
        skView.presentScene(scene)
    }
    
    @objc func openDetailVC() {
        if let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
            present(detailVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapShareButton(_ sender: UIButton) {
        // 앱 screen 샷을 찍어 공유하기 기능 구현
        var image: UIImage?
        var screenImages = [UIImage]()
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
        guard let currentContext = UIGraphicsGetCurrentContext() else { return }
        view.layer.render(in: currentContext)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let screenImage = image else { return }
        screenImages.append(screenImage)
        
        // 공유하기 activity
        let shareScreen = UIActivityViewController(activityItems: screenImages, applicationActivities: nil)
        let popoverPresentationController = shareScreen.popoverPresentationController
        popoverPresentationController?.permittedArrowDirections = .any
        present(shareScreen, animated: true, completion: nil)
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

