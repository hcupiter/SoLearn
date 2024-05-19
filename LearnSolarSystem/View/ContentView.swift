//
//  ContentView.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 15/05/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @StateObject private var arview_viewmodel = ARView_ViewModel(arViewContainer: ARViewContainer())
    
    var body: some View {
        // put arview to content view
        arview_viewmodel.arViewContainer.ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
