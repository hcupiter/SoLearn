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
    @State private var scaleValue: Double = 1
    
    var body: some View {
        // put arview to content view
        ZStack (alignment: .bottom) {
            ARViewContainer(viewModel: viewmodel)
            HStack {
                Button(action: {
                    viewmodel.isPaused.toggle()
                }, label: {
                    Image(systemName: viewmodel.isPaused ? "pause.fill" : "play.fill")
                        .foregroundColor(.black) // Set the icon color to black
                        .frame(width: 50, height: 50) // Adjust the frame to control the button size
                        .background(Color.white) // Set the background color to white
                        .clipShape(Circle()) // Make the background a circle
                })
                .padding(.bottom, 40)
            }
            
            VStack (alignment: .trailing) {
                Spacer()
                VerticalSlider(sliderValue: $scaleValue)
            }
            .frame(maxWidth: .infinity)

        }
        .opacity(isLoading ? 0 : 1)
        .overlay(content: {
            if isLoading {
                LoadingView(isLoading: $isLoading)
                    .opacity(isLoading ? 1 : 0)
            }
        })
        .ignoresSafeArea()
        .onChange(of: viewmodel.isLoading) { oldValue, newValue in
            self.isLoading = newValue
            print("[DEBUG]: ContentView loading status: \(isLoading)")
        }
        
    }
}



#Preview {
    ContentView()
}
