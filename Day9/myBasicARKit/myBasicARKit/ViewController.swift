//
//  ViewController.swift
//  myBasicARKit
//
//  Created by Amnuay M on 10/9/17.
//  Copyright © 2017 Amnuay M. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let scene = SCNScene()

    @IBAction func addDurianMethod() {
        //Create Scene for Durian
        let durianScene = SCNScene(named: "art.scnassets/durian/durian.scn")!
        
        //Create Node to put in 3D Model
        let durianNode = durianScene.rootNode.childNode(withName: "Durian", recursively: true)!
        
        //Specify location of Node and Add durianNode into the Scene
        durianNode.position = SCNVector3.init(0, 0, -0.6)
        scene.rootNode.addChildNode(durianNode)
        
        //SEt the scene to the view
        sceneView.scene = scene
    }
    
    @IBAction func addDog() {
        let dogScene = SCNScene(named: "art.scnassets/dog/Dog.scn")!
        let dogNode = dogScene.rootNode.childNode(withName: "Dog", recursively: true)!
        dogNode.position = SCNVector3.init(0.5, -1, -0.6)
        scene.rootNode.addChildNode(dogNode)
        
        sceneView.scene = scene
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
//        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
