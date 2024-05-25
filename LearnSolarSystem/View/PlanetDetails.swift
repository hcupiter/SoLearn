//
//  PlanetDetails.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 21/05/24.
//

import SwiftUI
import SceneKit
import RealityKit

struct PlanetDetails: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ARView_ViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                if geometry.size.width > geometry.size.height {
                    // Landscape orientation
                    HStack(alignment: .center) {
                        if let planetTapped = viewModel.planetTapped {
                            PlanetDetails3D(planet: planetTapped)
                                .frame(width: geometry.size.width * 0.55, height: geometry.size.height)
                            PlanetDetailsDataView(planetTapped: planetTapped)
                                .padding(.vertical, 40)
                        }
                    }
                } else {
                    // Portrait orientation
                    VStack(alignment: .leading) {
                        if let planetTapped = viewModel.planetTapped {
                            PlanetDetails3D(planet: planetTapped)
                                .frame(height: geometry.size.height * 0.5)
                            PlanetDetailsDataView(planetTapped: planetTapped)
                        }
                    }
                    .ignoresSafeArea()
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                
                Button(action: {
                    dismiss()
                    viewModel.planetTapped = nil
                    viewModel.planetTappedEvent = false
                    
                    if viewModel.isPaused == false {
                        viewModel.resumeAllAnimation()
                    }
                    
                }, label: {
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .clipShape(Circle())
                })
                .padding([.top, .leading], 40)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PlanetDetails(viewModel: ARView_ViewModel())
}
