//
//  Coordinator.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 19/05/24.
//

import Foundation
import RealityKit
import SwiftUI

class Coordinator: NSObject {
    var parent: ARViewContainer
    
    init(_ parent: ARViewContainer){
        self.parent = parent
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        guard let arView = sender.view as? ARView else { return }
        
        // handle the tap on the entity
        let tapLocation = sender.location(in: arView)
        if let modelEntity = arView.entity(at: tapLocation) {
            // handle logic on the tapped entity
            print("[DEBUG] Tapped on entity: \(modelEntity.name)")
            parent.runPlanetTapEvent(planetName: modelEntity.name)
        }
    }
}
