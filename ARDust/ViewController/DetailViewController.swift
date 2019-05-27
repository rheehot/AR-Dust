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
    
    @IBOutlet weak var pm10Value: UILabel!
    @IBOutlet weak var pm25Vlaue: UILabel!
    @IBOutlet weak var so2Value: UILabel!   // 이황산가스
    @IBOutlet weak var coValue: UILabel!    // 일산화탄소
    @IBOutlet weak var o3Value: UILabel!    // 오존
    @IBOutlet weak var no2Value: UILabel!   // 이산화질소
    
    
    
    @IBAction func tapDismissButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(appDelegate.airDataList)
        
        self.hero.isEnabled = true
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
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
