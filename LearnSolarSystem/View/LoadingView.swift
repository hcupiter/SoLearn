//
//  LoadingView.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 20/05/24.
//

import SwiftUI

struct LoadingView: View {
    @ObservedObject var viewmodel: ARView_ViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            if viewmodel.isLoading {
                Text("Loading...")
            }
        }
        .onReceive(viewmodel.$isLoading, perform: { _ in
            if viewmodel.isLoading == false {
                dismiss()
            }
        })
    }
}

#Preview {
    LoadingView(viewmodel: ARView_ViewModel())
}
