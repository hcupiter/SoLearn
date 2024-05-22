//
//  ContentView.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 15/05/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @StateObject private var viewmodel = ARView_ViewModel()
    @State private var isLoading: Bool = true
    @State private var scaleValue: Float = 1
    @State private var scaleTimer: Timer?
    
    @State private var isOpeningPlanetDetails: Bool = false
    
    var body: some View {
        // put arview to content view
        ZStack (alignment: .center) {
            ARViewContainer(viewModel: viewmodel)
            VStack {
                Spacer()
                Button(action: {
                    viewmodel.startOrPauseAnimation()
                }, label: {
                    Image(systemName: viewmodel.isPaused ? "play.fill" : "pause.fill")
                        .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                        .background(Color.white)
                        .clipShape(Circle())
                })
                .padding(.bottom, 40)
            }
            VerticalSlider(sliderValue: $scaleValue)
                .onChange(of: scaleValue) { oldValue, newValue in
                    viewmodel.scalePlanets(scaleValue: newValue - oldValue)
                }
        }
        .opacity(isLoading || isOpeningPlanetDetails ? 0 : 1)
        .overlay(content: {
            if isLoading {
                LoadingView(isLoading: $isLoading)
                    .opacity(isLoading ? 1 : 0)
            }
            
            if isOpeningPlanetDetails {
                PlanetDetails(viewModel: viewmodel)
                    .ignoresSafeArea()
            }
            
        })
        .ignoresSafeArea()
        .onChange(of: viewmodel.planetTappedEvent, { oldValue, newValue in
            if viewmodel.planetTapped == nil {
                isOpeningPlanetDetails = false
            } else {
                isOpeningPlanetDetails = true
                viewmodel.stopAllAnimation()
            }
        })
        .onChange(of: viewmodel.isLoading) { oldValue, newValue in
            self.isLoading = newValue
            print("[DEBUG]: ContentView loading status: \(isLoading)")
        }
        .preferredColorScheme(.dark)
        
    }
}



#Preview {
    ContentView()
}
