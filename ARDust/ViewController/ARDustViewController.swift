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


class ARDustViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate  {
    // MARK: - IBOutlet
    @IBOutlet var sceneView: ARSCNView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        sceneView.showsStatistics = true
        
        let scene = SCNScene(named: "dust.scnassets/scene.scn")!
        let particleNode = SCNNode()
        let particleSystem = SCNParticleSystem(named: "dust.scnassets/dustParticle", inDirectory: nil)
        
        particleNode.addParticleSystem(particleSystem!)
        scene.rootNode.addChildNode(particleNode)
        
        sceneView.scene = scene
        


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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
