//
//  DetailViewController.swift
//  ARDust
//
//  Created by youngjun goo on 26/05/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit
import Hero

class DetailViewController: UIViewController {
    
    private let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    @IBOutlet weak var blueView: UIView!
    
    @IBOutlet weak var grayView: UIView! {
        didSet {
            self.grayView.layer.cornerRadius = 10
            self.grayView.clipsToBounds = true
        }
    }
    @IBOutlet weak var whiteView: UIView! {
        didSet {
            self.whiteView.layer.cornerRadius = 10
            self.whiteView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let dateString = dateFormatter.string(from: date)
            self.timeLabel.text = dateString
        }
    }
    
    @IBOutlet weak var locationLabel: UILabel! {
        didSet {
            self.locationLabel.text = "\(appDelegate.airDataList[0].locationName)은 지금 "
        }
    }
    
    @IBOutlet weak var stateLabel: UILabel! {
        didSet {
            self.stateLabel.text = appDelegate.airDataList[0].airPollutionData.pollutionState
            self.stateLabel.textColor = appDelegate.airDataList[0].airPollutionData.pollutionStateColor
        }
    }
    
    @IBOutlet weak var dustStackView: UIStackView!
    @IBOutlet weak var fineDustStackView: UIStackView!
    @IBOutlet weak var pm10Value: UILabel!
    @IBOutlet weak var pm25Vlaue: UILabel!
    @IBOutlet weak var so2Value: UILabel!   // 이황산가스
    @IBOutlet weak var coValue: UILabel!    // 일산화탄소
    @IBOutlet weak var o3Value: UILabel!    // 오존
    @IBOutlet weak var no2Value: UILabel!   // 이산화질소
    
    private var swipeGesture = UISwipeGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeDismissButton))
        self.swipeGesture.numberOfTouchesRequired = 1
        self.swipeGesture.direction = .down
        self.blueView.addGestureRecognizer(self.swipeGesture)
        self.blueView.isUserInteractionEnabled = true
        
        self.hero.isEnabled = true
        self.dustStackView.hero.id = "dust"
        self.fineDustStackView.hero.id = "fineDust"
        self.blueView.hero.id = "ironMan"
        self.grayView.hero.id = "batMan"
        whiteView.hero.modifiers = [.translate(y:100)]
        
        setUpInfoView()
        // Do any additional setup after loading the view.
    }
    
    func setUpInfoView() {
        self.pm10Value.text = appDelegate.airDataList[0].airPollutionData.pm10Value
        self.pm25Vlaue.text = appDelegate.airDataList[0].airPollutionData.pm25Value
        self.so2Value.text = appDelegate.airDataList[0].airPollutionData.so2Value
        self.coValue.text = appDelegate.airDataList[0].airPollutionData.coValue
        self.o3Value.text = appDelegate.airDataList[0].airPollutionData.o3Value
        self.no2Value.text = appDelegate.airDataList[0].airPollutionData.no2Value
        self.blueView.backgroundColor = appDelegate.airDataList[0].airPollutionData.pollutionStateColor
    }

    // Swipe 시 dismiss 수행
    @objc func swipeDismissButton() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
