//
//  LoadingView.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 20/05/24.
//

import SwiftUI

struct LoadingView: View {
    @Binding var isLoading: Bool
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            if isLoading {
                Text("Loading...")
            }
        }
        .onChange(of: isLoading) { oldValue, newValue in
            dismiss()
        }
    }
}

#Preview {
    LoadingView(isLoading: .constant(true))
}
