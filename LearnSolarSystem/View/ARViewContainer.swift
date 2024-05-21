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
    @ObservedObject var viewModel: ARView_ViewModel
    
    // Create initial horizontal plane anchor for the content
    let anchor = AnchorEntity()
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // for debugging
        arView.debugOptions = .showWorldOrigin
        
        setupTapGestureRecognizer(arView: arView, context: context)
        
        addAnchor(arView: arView)
        loadAssets(arView: arView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func setupTapGestureRecognizer(arView: ARView, context: Context){
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)
    }
    
    func addAnchor(arView: ARView){
        // Add the horizontal plane anchor to the scene
        arView.scene.anchors.append(anchor)
        print("[DEBUG]: Anchor added to the scene")
    }
    
    // Load Assets
    func loadAssets(arView: ARView) {
        DispatchQueue.main.async {
            self.viewModel.isLoading = true
        }
        
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
                    DispatchQueue.main.async {
                        self.viewModel.isLoading = false
                        self.viewModel.setArViewContainer(arViewContainer: self.setArViewContainer())
                        print("[DEBUG]: arViewContainer has been set to the view model")
                        print("[DEBUG]: All planets assets successfully put in place")
                        print("[DEBUG]: ending isLoading status: \(self.viewModel.isLoading)")
                    }

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
                    // add orbit animation
                    PlanetModel.addOrbitAnimation(planetEntity: planetEntity, planetOrbitAnimationDuration: planet.planetOrbitAnimationDuration)
                    dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: .main) {
            print("[DEBUG]: All planets assets loaded")
            completion(planets)
        }
    }
    
    func addDebugBox(){
        // Create a cube model
        let mesh = MeshResource.generateBox(size: 0.1, cornerRadius: 0.005)
        let material = SimpleMaterial(color: .green, roughness: 0.15, isMetallic: true)
        let model = ModelEntity(mesh: mesh, materials: [material])
        model.transform.translation.y = 0.05
        
        anchor.children.append(model)
    }
    
    // ANIMATION
    func pauseAnimations() {
        if let sunEntity = anchor.children.first(where: { $0.name == "Sun" }) {
            for child in sunEntity.children {
                let planetModel = PlanetData.findPlanetByName(planetName: child.name)
                if let planetModel = planetModel {
                    PlanetModel.stopOrbitAnimation(planetEntity: child as! ModelEntity, planetOrbitAnimationDuration: planetModel.planetOrbitAnimationDuration)
                }
            }
            print("[DEBUG]: All planet animations paused")
        }
    }
    
    func resumeAnimations() {
        if let sunEntity = anchor.children.first(where: { $0.name == "Sun" }) {
            for child in sunEntity.children {
                let planetModel = PlanetData.findPlanetByName(planetName: child.name)
                if let planetModel = planetModel {
                    PlanetModel.addOrbitAnimation(planetEntity: child as! ModelEntity, planetOrbitAnimationDuration: planetModel.planetOrbitAnimationDuration)
                }
            }
            print("[DEBUG]: All planet animations resumed")
        }
    }
    
    func scaleEntities(scaleValue: Float){
        if let sunEntity = anchor.children.first(where: { $0.name == "Sun" }) {
            let sunModel = PlanetData.findPlanetByName(planetName: "Sun")
            if let sunModel = sunModel {
                PlanetModel.scaleModelEntity(planetEntity: sunEntity as! ModelEntity, baseScaleValue: sunModel.planetScaleSize, scaleValue: scaleValue)
            }
            
            for child in sunEntity.children {
                let planetModel = PlanetData.findPlanetByName(planetName: child.name)
                if let planetModel = planetModel {
                    PlanetModel.scaleModelEntity(planetEntity: child as! ModelEntity, baseScaleValue: planetModel.planetScaleSize, scaleValue: scaleValue)
                }
            }
            print("[DEBUG]: planet were scaled")
        }
    }
    
    
    
    static func dismantleUIView(_ uiView: ARView, coordinator: Coordinator) {
        uiView.session.pause()
    }
    
    func setArViewContainer() -> ARViewContainer {
        return self
    }
    
    // overided function to communicate with SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
