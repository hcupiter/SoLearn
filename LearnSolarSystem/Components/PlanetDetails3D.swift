//
//  PlanetDetails3D.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 21/05/24.
//

import Foundation
import SwiftUI
import SceneKit

struct PlanetDetails3D: UIViewRepresentable {
    var planet: PlanetModel
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.backgroundColor = .black
        
        if let scene = SCNScene(named: planet.planetName + ".usdz") {
            view.scene = scene
            addCameraNode(to: scene)
            addSpinAnimation(to: scene)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        
    }
    
    func addCameraNode(to scene: SCNScene) {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        // Position the camera 45 degrees from the top
        let distance: Float = 10.0
        let angle: Float = .pi / 4 // 45 degrees in radians
        let yPosition = distance * sin(angle)
        let zPosition = distance * cos(angle)
        
        cameraNode.position = SCNVector3(x: 0, y: yPosition, z: zPosition)
        cameraNode.look(at: SCNVector3Zero)
        
        scene.rootNode.addChildNode(cameraNode)
    }
    
    func addSpinAnimation(to scene: SCNScene) {
        if let node = scene.rootNode.childNodes.first {
            let spin = CABasicAnimation(keyPath: "rotation")
            spin.fromValue = SCNVector4(x: 0, y: 1, z: 0, w: 0)
            spin.toValue = SCNVector4(x: 0, y: 1, z: 0, w: Float.pi * 2)
            spin.duration = 10 // duration in seconds
            spin.repeatCount = .infinity
            node.addAnimation(spin, forKey: "spin around")
        }
    }
}

struct PlanetDetails3D_Previews: PreviewProvider {
    static var previews: some View {
        PlanetDetails3D(planet: PlanetData.planets[3])
    }
}
