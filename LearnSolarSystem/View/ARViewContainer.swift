//
//  ARViewContainer.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 19/05/24.
//

import Foundation
import RealityKit
import SwiftUI
import UIKit

struct ARViewContainer: UIViewRepresentable {
    
    let arView = ARView(frame: .zero)
    
    // Create initial horizontal plane anchor for the content
    let anchor = AnchorEntity()
    
    func makeUIView(context: Context) -> ARView {
        // for debugging
        arView.debugOptions = .showWorldOrigin
        
        setupTapGestureRecognizer(context: context)
        
        loadPlanets()
        addAnchor()
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func setupTapGestureRecognizer(context: Context){
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)
    }
    
    func addAnchor(){
        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)
    }
    
    // overided function to communicate with SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func loadPlanets(){
        
    }
    
    func addDebugBox(){
        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .green, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.transform.translation.y = 0.05
        
        anchor.children.append(model)
    }
}
