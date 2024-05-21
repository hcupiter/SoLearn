//
//  ARView_ViewModel.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 19/05/24.
//

import Foundation

class ARView_ViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var isPaused: Bool = false
    @Published var arViewContainer: ARViewContainer!
    
    func setArViewContainer(arViewContainer: ARViewContainer){
        self.arViewContainer = arViewContainer
    }
    
    func scalePlanets(scaleValue: Float){
        arViewContainer.scaleEntities(scaleValue: scaleValue)
    }
    
    func startOrPauseAnimation(){
        if isPaused {
            resumeAllAnimation()
            isPaused = false
        }
        else {
            stopAllAnimation()
            isPaused = true
        }
    }
    
    func resumeAllAnimation(){
        if let arViewContainer = arViewContainer {
            arViewContainer.resumeAnimations()
            print("[DEBUG]: animation resumed")
        }
        else {
            print("[DEBUG]: ERROR arViewContainer isn't initialized yet!")
        }
    }
    
    func stopAllAnimation(){
        if let arViewContainer = arViewContainer {
            arViewContainer.pauseAnimations()
            print("[DEBUG]: animation paused")
        }
        else {
            print("[DEBUG]: ERROR arViewContainer isn't initialized yet!")
        }
       
    }
    
}



struct PlanetData {
    static var planets = [
        PlanetModel(
            planetPosition: 1,
            planetName: "Sun",
            planetDesc: "A giant ball of hot gas at the center of our solar system. It holds most of the solar system's mass and provides light and warmth to the planets. The sun is famous for being a star, the source of light and energy for our solar system",
            planetRotationTime: "It took 25 earth days for the sun to finish a rotation",
            planetOrbitTime: nil,
            planetOrbitAnimationDuration: nil,
            planetScaleSize: 3,
            planetDistanceScale: 0.5
        ),
        PlanetModel(
            planetPosition: 1,
            planetName: "Mercury",
            planetDesc: "The smallest planet and closest to the Sun. It has no atmosphere and is covered in craters. Mercury is one of the fastest planet in our solar system",
            planetRotationTime: "It took 58 earth days for mercury to finish a rotation (a day in mercury is longer than a year in mercury!)",
            planetOrbitTime: "It took 88 earth day to orbit the sun.",
            planetOrbitAnimationDuration: 10,
            planetScaleSize: 0.05,
            planetDistanceScale: 0.2
        ),
        PlanetModel(
            planetPosition: 2,
            planetName: "Venus",
            planetDesc: "Hottest planet, even hotter than Mercury! It has a thick atmosphere of mostly carbon dioxide and is shrouded in thick clouds. Venus is famous for being Earth's twin in size, but with a very different environment.",
            planetRotationTime: "It took 243 earth days for venus to finish a rotation",
            planetOrbitTime: "Venus took 225 earth days to finish orbiting the sun",
            planetOrbitAnimationDuration: 12.78,
            planetScaleSize: 0.1,
            planetDistanceScale: 0.25
        ),
        PlanetModel(
            planetPosition: 3,
            planetName: "Earth",
            planetDesc: "The only planet in our solar system known to support life. It has a thin atmosphere and a liquid water surface. It's our planet where we live!",
            planetRotationTime: "Earth took 24 hours to finish a rotation",
            planetOrbitTime: "Earth took 365.25 days (1 year) to finish orbitting the sun!",
            planetOrbitAnimationDuration: 20.74,
            planetScaleSize: 0.1,
            planetDistanceScale: 0.30
        ),
        PlanetModel(
            planetPosition: 4,
            planetName: "Mars",
            planetDesc: "The Red Planet! Nicknamed for its reddish iron oxide dust. It has a thin atmosphere and two moons, Phobos and Deimos. Mars is the most likely candidate for finding life beyond Earth.",
            planetRotationTime: "It took 24.6 hours for mars to finish a rotation",
            planetOrbitTime: "Did you know that 1 year in Mars equals 687 Earth Days",
            planetOrbitAnimationDuration: 39.06,
            planetScaleSize: 0.09,
            planetDistanceScale: 0.35
        ),
        PlanetModel(
            planetPosition: 5,
            planetName: "Jupiter",
            planetDesc: "The largest planet by far, a gas giant with a swirling atmosphere and a Great Red Spot, a giant storm bigger than Earth. Jupiter is famous for being a giant with many moons, including the four large Galilean moons (Io, Europa, Ganymede, and Callisto).",
            planetRotationTime: "It took only 9 hours for Jupiter to finish a rotation!",
            planetOrbitTime: "Jupiter finish orbiting the sun in 11.86 years.",
            planetOrbitAnimationDuration: 245.91,
            planetScaleSize: 0.5,
            planetDistanceScale: 0.40
        ),
        PlanetModel(
            planetPosition: 6,
            planetName: "Saturn",
            planetDesc: "Another gas giant known for its iconic rings made of ice and rock. It also has many moons, including the large moon Titan with a thick atmosphere. Saturn is famous for its stunning rings, which are visible even with a small telescope.",
            planetRotationTime: "It took 10 hours for Saturn to finish a rotation",
            planetOrbitTime: "Saturn finish orbiting the sun in 29.4 years!",
            planetOrbitAnimationDuration: 609.71,
            planetScaleSize: 0.3,
            planetDistanceScale: 0.45
        ),
        PlanetModel(
            planetPosition: 7,
            planetName: "Uranus",
            planetDesc: "An ice giant with a strange tilt on its axis, making it appear to roll on its side. It has a faint ring system and many moons.",
            planetRotationTime: "A day in Uranus is only took 17 earth hours!",
            planetOrbitTime: "Uranus took 84 earth years to finish rotating the sun!",
            planetOrbitAnimationDuration: 1741.36,
            planetScaleSize: 0.1,
            planetDistanceScale: 0.55
        ),
        PlanetModel(
            planetPosition: 8,
            planetName: "Neptune",
            planetDesc: "The farthest planet from the Sun, another ice giant with strong winds and a dark blue color. It has a large storm system, the Great Dark Spot.",
            planetRotationTime: "It took 16-19 earth hours for neptune to finish a rotation",
            planetOrbitTime: "Neptune took 165 earth years to finish rotating the sun!",
            planetOrbitAnimationDuration: 3422.44,
            planetScaleSize: 0.09,
            planetDistanceScale: 0.6
        ),
    ]
    
    static func findPlanetByName(planetName: String) -> PlanetModel? {
        return planets.first(where: { $0.planetName == planetName})
    }
}
