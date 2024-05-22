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
    @State private var rocketOpacity: Double = 0.0
    
    var body: some View {
        VStack {
            if isLoading {
                ZStack {
                    Color.blue.ignoresSafeArea()
                    ForEach(0..<50) { _ in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 2, height: 2)
                            .position(
                                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                            )
                    }
                    VStack {
                        Image("rocket")
                            .resizable()
                            .frame(width: 100, height: 150)
                            .scaledToFill()
                            .opacity(rocketOpacity)
                            .onAppear(){
                                withAnimation(.easeInOut(duration: 1).repeatForever()) {
                                    rocketOpacity = 1
                                }
                            }
                        Text("Loading...")
                            .font(.title3)
                            .foregroundStyle(Color.white)
                    }
                }
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
