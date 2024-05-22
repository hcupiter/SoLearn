//
//  PlanetDetailsDataView.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 21/05/24.
//

import SwiftUI

struct PlanetDetailsDataView: View {
    var planetTapped: PlanetModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("\(planetTapped.planetName)")
                    .padding(.top, 16)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                
                Text("\(planetTapped.planetDesc)")
                    .font(.body)
                    .foregroundStyle(Color.secondary)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 16)
                
                Divider()
                
                VStack(alignment: .leading, content: {
                    Text("Planet Rotation")
                        .font(.title2)
                    Text("\(planetTapped.planetRotationTime)")
                        .foregroundStyle(Color.blue)
                })
                .padding(.vertical, 16)
                
                if let planetOrbitTime = planetTapped.planetOrbitTime {
                    VStack(alignment: .leading, content: {
                        Text("Planet Orbit Time")
                            .font(.title2)
                        Text("\(planetOrbitTime)")
                            .foregroundStyle(Color.blue)
                    })
                }
            }
            .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    PlanetDetailsDataView(planetTapped: PlanetData.planets[3])
}
