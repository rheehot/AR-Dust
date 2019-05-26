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
    
    @IBAction func tapDismissButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hero.isEnabled = true
        self.blueView.hero.id = "ironMan"
        self.grayView.hero.id = "batMan"
        whiteView.hero.modifiers = [.translate(y:100)]
        // Do any additional setup after loading the view.
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
