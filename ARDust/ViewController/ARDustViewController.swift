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
    private let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var cancelButton: UIButton! {
        didSet {
            let cancelImage = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
            self.cancelButton.setImage(cancelImage, for: .normal)
        }
    }
    
    var scene = SCNScene()
    
    var pm10ValueNode = SCNNode()
    var pm25ValueNode = SCNNode()
    
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
        
        let fineDustText: String = "미세먼지: \(String(describing: appDelegate.airDataList[0].airPollutionData.pm10Value!))"
        let ultraFineDustText: String = "초미세먼지: \(String(describing: appDelegate.airDataList[0].airPollutionData.pm25Value!))"
        let pm10ValueText = SCNText(string: fineDustText, extrusionDepth: 1)
        let material = SCNMaterial()
        material.diffuse.contents = self.setTextColor()
        pm10ValueText.materials = [material]
        
        pm10ValueNode.position = SCNVector3(0, 0.02, -0.6)
        pm10ValueNode.scale = SCNVector3(0.005,0.005,0.005)
        pm10ValueNode.geometry = pm10ValueText
        
        let pm25ValueText = SCNText(string: ultraFineDustText, extrusionDepth: 1)
        let material2 = SCNMaterial()
        material2.diffuse.contents = self.setTextColor()
        pm25ValueText.materials = [material2]
        
        pm25ValueNode.position = SCNVector3(0, 0.08, -0.6)
        pm25ValueNode.scale = SCNVector3(0.005,0.005,0.005)
        pm25ValueNode.geometry = pm25ValueText
        
        
        
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
        scene.rootNode.addChildNode(pm10ValueNode)
        scene.rootNode.addChildNode(pm25ValueNode)
        scene.rootNode.addChildNode(fineDustNode)
        scene.rootNode.addChildNode(ultraFineDust)
        sceneView.showsStatistics = false
        sceneView.scene = scene
    }
    
    func setTextColor() -> UIColor {
        return appDelegate.airDataList[0].airPollutionData.pollutionStateColor
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
