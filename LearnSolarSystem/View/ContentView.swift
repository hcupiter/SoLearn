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
    
    var body: some View {
        // put arview to content view
        ZStack {
            ARViewContainer(viewModel: viewmodel)
                .ignoresSafeArea()
        }
        .onReceive(viewmodel.$isLoading, perform: { _ in
            isLoading = viewmodel.isLoading
        })
    }
}

#Preview {
    ContentView()
}
