//
//  ARViewContainer.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 19/05/24.
//

import Foundation
import RealityKit
import ARKit
import SwiftUI
import UIKit

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: ARView_ViewModel
    
    // Create initial horizontal plane anchor for the content
    let anchor = AnchorEntity()
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // for debugging
        // arView.debugOptions = .showWorldOrigin
        
        configureArView(arView: arView)
        setupTapGestureRecognizer(arView: arView, context: context)
        
        addAnchor(arView: arView)
        loadAssets(arView: arView)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func configureArView(arView: ARView) {
        arView.automaticallyConfigureSession = false
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        arView.session.run(config)
    }
    
    func setupTapGestureRecognizer(arView: ARView, context: Context) {
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)
    }
    
    func addAnchor(arView: ARView) {
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
                            // Add orbit line for each planet
                            if let orbitLine = createOrbitLine(radius: Float(p.transform.translation.x)) {
                                sunEntity.addChild(orbitLine)
                            }
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
                    planets[planet.planetPosition - 1] = planetEntity
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
    
    func createOrbitLine(radius: Float) -> ModelEntity? {
        let orbit = ModelEntity()
        let segments = 100
        let angle = (2 * Float.pi) / Float(segments)
        var points: [SIMD3<Float>] = []
        
        for i in 0..<segments {
            let x = cos(Float(i) * angle) * radius
            let z = sin(Float(i) * angle) * radius
            points.append(SIMD3(x, 0, z))
        }
        
        var previousPoint = points.last!
        for point in points {
            let length = lengthBetween(point1: previousPoint, point2: point)
            let line = MeshResource.generateBox(size: [0.0005, 0.0005, length])
            let material = SimpleMaterial(color: .white, isMetallic: false)
            let lineEntity = ModelEntity(mesh: line, materials: [material])
            lineEntity.position = SIMD3((previousPoint.x + point.x) / 2, 0, (previousPoint.z + point.z) / 2)
            lineEntity.look(at: point, from: lineEntity.position, relativeTo: nil)
            orbit.addChild(lineEntity)
            previousPoint = point
        }
        
        return orbit
    }
    
    func lengthBetween(point1: SIMD3<Float>, point2: SIMD3<Float>) -> Float {
        return simd_length(point1 - point2)
    }
    
    func addDebugBox() {
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
    
    func scaleEntities(scaleValue: Float) {
        if let sunEntity = anchor.children.first(where: { $0.name == "Sun" }) {
            let sunModel = PlanetData.findPlanetByName(planetName: "Sun")
            if sunModel != nil {
                PlanetModel.scaleModelEntity(planetEntity: sunEntity as! ModelEntity, scaleValue: scaleValue)
            }
            
            for child in sunEntity.children {
                let planetModel = PlanetData.findPlanetByName(planetName: child.name)
                if planetModel != nil {
                    PlanetModel.scaleModelEntity(planetEntity: child as! ModelEntity, scaleValue: scaleValue)
                }
            }
            print("[DEBUG]: planet were scaled")
        }
    }
    
    // notified content view a tap event
    func runPlanetTapEvent(planetName: String) {
        viewModel.handlePlanetTapEvent(planetName: planetName)
    }
    
    static func dismantleUIView(_ uiView: ARView, coordinator: Coordinator) {
        uiView.session.pause()
    }
    
    func setArViewContainer() -> ARViewContainer {
        return self
    }
    
    // overridden function to communicate with SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

