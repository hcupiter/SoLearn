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
                .opacity(isLoading ? 1 : 1)
//            LoadingView(isLoading: $isLoading)
//                .opacity(isLoading ? 1 : 0)
//                .ignoresSafeArea()
        }
        .onChange(of: viewmodel.isLoading) { oldValue, newValue in
            self.isLoading = newValue
            print("[DEBUG]: ContentView loading status: \(isLoading)")
        }
    }
}

#Preview {
    ContentView()
}
