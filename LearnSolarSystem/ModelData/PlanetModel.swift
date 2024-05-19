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
    var planetName: String
    var planetDesc: String
    var planetRotationTime: String
    var planetOrbitTime: String?
    
    var modelEntity: ModelEntity!
    var planetOrbitAnimationDuration: Double?
    
    var cancellables: Set<AnyCancellable>!
    
    init(planetName: String, planetDesc: String, planetRotationTime: String, planetOrbitTime: String?, planetOrbitAnimationDuration: Double?){
        self.planetName = planetName
        self.planetDesc = planetDesc
        self.planetRotationTime = planetRotationTime
        self.planetOrbitTime = planetOrbitTime
        
        self.planetOrbitAnimationDuration = planetOrbitAnimationDuration
    }
    
    func loadModelEntity(completion: @escaping (ModelEntity?) -> Void) {
        let entityLoadRequest = ModelEntity.loadModelAsync(named: planetName + ".usdz")
        
        entityLoadRequest.sink { completion in
            switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print("Failed to load model entity :\(self.planetName) with error: \(failure.localizedDescription)")
            }
        } receiveValue: { modelEntity in
            self.modelEntity = modelEntity
            self.modelEntity.name = self.planetName
            self.modelEntity.generateCollisionShapes(recursive: true) // so that the object can be tapped
        }
        .store(in: &cancellables)
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
}
