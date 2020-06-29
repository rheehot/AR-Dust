//
//  ViewController.swift
//  ARDust
//
//  Created by youngjun goo on 16/03/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var testLabel: UILabel?
    @IBOutlet weak var weatherView: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherView?.clipsToBounds
        self.weatherView?.layer.cornerRadius = 20
        self.weatherView?.layer.masksToBounds = true
    }
}

