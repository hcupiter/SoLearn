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
    
    @ObservedObject var viewModel: ARView_ViewModel
    
    // Create initial horizontal plane anchor for the content
    let anchor = AnchorEntity()
    
    func makeUIView(context: Context) -> ARView {
        // for debugging
        arView.debugOptions = .showWorldOrigin
        
        setupTapGestureRecognizer(context: context)
        
        loadAssets()
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
        print("[DEBUG]: Anchor added to the scene")
    }
    
    // overided function to communicate with SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func loadAssets(){
        // load sun first
        let sunModel: PlanetModel = PlanetData.planets[0]
        sunModel.loadModelEntity(completion: { modelEntity in
            if let sunEntity = modelEntity {
                anchor.children.append(sunEntity)
                
                // load all planets async
                loadAllPlanetsAsync(completion: { planetList in
                    for planet in planetList {
                        if let p = planet {
                            sunEntity.children.append(p)
                        }
                    }
                    print("[DEBUG]: All planets assets successfully put in place")
                    print("[DEBUG]: ending isLoading status: \(self.viewModel.isLoading)")
                })
            }
        })
    }
    
    func loadAllPlanetsAsync(completion: @escaping ([ModelEntity?]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var planets: [ModelEntity?] = Array(repeating: nil, count: PlanetData.planets.count - 1)
        
        for i in stride(from: 1, to: PlanetData.planets.count, by: 1) {
            dispatchGroup.enter()
            
            let planet = PlanetData.planets[i]
            planet.loadModelEntity(completion: { modelEntity in
                if let planetEntity = modelEntity {
                    planets.insert(planetEntity, at: planet.planetPosition - 1)
                    planet.addOrbitAnimation() // add orbit animation
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            print("[DEBUG]: All planets assets loaded")
            completion(planets)
        }
    }
    
    mutating func setViewModel(viewmodel: ARView_ViewModel){
        self.viewModel = viewmodel
    }
    
    func addDebugBox(){
        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .green, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.transform.translation.y = 0.05
        
        anchor.children.append(model)
    }
    
    static func dismantleUIView(_ uiView: ARView, coordinator: Coordinator) {
        uiView.session.pause()
    }
}
