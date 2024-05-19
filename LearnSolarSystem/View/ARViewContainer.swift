//
//  ARViewContainer.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 19/05/24.
//

import Foundation
import RealityKit
import SwiftUI
import ARKit

struct ARViewContainer: UIViewRepresentable {
    
    let arView = ARView(frame: .zero)
    
    // Create initial horizontal plane anchor for the content
    let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
    
    func makeUIView(context: Context) -> ARView {
        arView.debugOptions = [.showWorldOrigin]
        putDebugBox()
        configureArView()
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func addAnchor(){
        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)
    }
    
    func configureArView(){
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        config.environmentTexturing = .automatic
        
        // check if device has lidar
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
    }
    
    func putDebugBox(){
        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .red, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])
        
        model.transform.translation.y = 1
        
        // put to anchor
        anchor.children.append(model)
    }
    
}
