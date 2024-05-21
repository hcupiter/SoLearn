//
//  PlanetDetails3D.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 21/05/24.
//

import Foundation
import SwiftUI
import SceneKit

struct PlanetDetails3D: UIViewRepresentable {
    var planet: PlanetModel
    
    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = SCNScene(named: planet.planetName + ".usdz")
        view.backgroundColor = .black
        
        return view
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        
    }
}

struct PlanetDetails3D_Previews: PreviewProvider {
    static var previews: some View {
        PlanetDetails3D(planet: PlanetData.planets[3])
    }
}
