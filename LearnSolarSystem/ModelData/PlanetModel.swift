//
//  PlanetModel.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 19/05/24.
//

import Foundation
import RealityKit
import Combine
import UIKit

class PlanetModel {
    var planetPosition: Int
    var planetName: String
    var planetDesc: String
    var planetScaleSize: Float
    var planetDistanceScale: Float
    var planetRotationTime: String
    var planetOrbitTime: String?
    
    var modelEntity: ModelEntity!
    var planetOrbitAnimationDuration: Double?
    
    var cancellables: Set<AnyCancellable>!
    
    init(planetPosition: Int, planetName: String, planetDesc: String, planetRotationTime: String, planetOrbitTime: String?, planetOrbitAnimationDuration: Double?, planetScaleSize: Float, planetDistanceScale: Float){
        self.planetPosition = planetPosition
        self.planetName = planetName
        self.planetDesc = planetDesc
        self.planetRotationTime = planetRotationTime
        self.planetOrbitTime = planetOrbitTime
        self.planetScaleSize = planetScaleSize
        self.planetDistanceScale = planetDistanceScale
        
        self.planetOrbitAnimationDuration = planetOrbitAnimationDuration
        self.cancellables = Set<AnyCancellable>()
    }
    
    func loadModelEntity(completion: @escaping (ModelEntity?) -> Void) {
        // if the 3d model already loaded, return the loaded 3d model
        if self.modelEntity != nil {
            completion(self.modelEntity)
            return
        }
        
        // else start load
        let entityLoadRequest = ModelEntity.loadModelAsync(named: planetName + ".usdz")
        
        entityLoadRequest.sink { completionResult in
            switch completionResult {
                case .finished:
                    break
                case .failure(let failure):
                    print("[DEBUG]: Failed to load model entity :\(self.planetName) with error: \(failure.localizedDescription)")
                    completion(nil)
            }
        } receiveValue: { planetEntity in
            print("[DEBUG]: planet \(self.planetName) loaded")
            self.modelEntity = planetEntity
            self.modelEntity.name = self.planetName
            self.modelEntity.generateCollisionShapes(recursive: true) // so that the object can be tapped
            self.translateAndScaleModelEntity()
            completion(self.modelEntity)
        }
        .store(in: &cancellables)
    }
    
    func loadModelEntity() -> ModelEntity? {
        print("[DEBUG]: loading planet: \(self.planetName)")
        do {
            let entity = try ModelEntity.loadModel(named: self.planetName + ".usdz")
            self.modelEntity = entity
            self.modelEntity.name = self.planetName
            self.modelEntity.generateCollisionShapes(recursive: true) // so that the object can be tapped
            self.translateAndScaleModelEntity()
            
            return self.modelEntity
            
        } catch {
            print("[DEBUG]: Failed to load model entity: \(self.planetName) with error: \(error.localizedDescription)")
        }
        
        return nil
        
    }
    
    func addOrbitAnimation(){
        if let duration = planetOrbitAnimationDuration {
            let animationDefinition = OrbitAnimation(
                duration: duration,
                axis: [0, 1, 0],
                startTransform: self.modelEntity.transform,
                bindTarget: .transform
            ).repeatingForever()
            
            let animationResource = try! AnimationResource.generate(with: animationDefinition)
            self.modelEntity.playAnimation(animationResource)
        }
    }
    
    // positioning the modelENtity
    func translateAndScaleModelEntity() {
        self.modelEntity.transform.translation.z = 0 - self.planetDistanceScale
        self.modelEntity.transform.scale = SIMD3(x: self.planetScaleSize, y: self.planetScaleSize, z: self.planetScaleSize)
    }
}
