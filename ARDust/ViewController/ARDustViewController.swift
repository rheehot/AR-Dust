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
    
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            self.cancelButton.backgroundColor = UIColor.yellow
            self.cancelButton.layer.cornerRadius = 10
            self.cancelButton.clipsToBounds = true
        }
    }
    
    var scene = SCNScene()
    
    // 미세먼지 SCNNode
    var fineDustNode: SCNNode = {
        let dustNode = SCNNode()
        let particleSystem = SCNParticleSystem(named: "dust.scnassets/dustParticle", inDirectory: nil)
        dustNode.addParticleSystem(particleSystem!)
        return dustNode
    }()
    
    // 초 미세먼지 SCNNode
    var ultraFineDust: SCNNode = {
        let dustNode = SCNNode()
        let particleSystem = SCNParticleSystem(named: "dust.scnassets/ultraFineDust", inDirectory: nil)
        dustNode.addParticleSystem(particleSystem!)
        return dustNode
    }()
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        if let scene = SCNScene(named: "dust.scnassets/scene.scn") {
            self.scene = scene
        } else {
            print("scn file is empty")
        }
        // particle system
        self.setUpSceneView()
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
    
    func setUpSceneView() {
        scene.rootNode.addChildNode(fineDustNode)
        scene.rootNode.addChildNode(ultraFineDust)
        sceneView.scene = scene
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
