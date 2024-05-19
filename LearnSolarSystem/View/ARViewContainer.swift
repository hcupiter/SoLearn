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
    let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
    
    func makeUIView(context: Context) -> ARView {
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func addAnchor(){
        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)
    }
    
}
