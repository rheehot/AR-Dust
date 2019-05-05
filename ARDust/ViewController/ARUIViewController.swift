//
//  ARUIViewController.swift
//  ARDust
//
//  Created by youngjun goo on 03/05/2019.
//  Copyright © 2019 youngjun goo. All rights reserved.
//

import UIKit
import ARKit
import SceneKit


class ARUIViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate  {
    // MARK: - IBOutlet
    @IBOutlet var sceneView: ARSCNView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
