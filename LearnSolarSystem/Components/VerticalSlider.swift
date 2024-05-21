//
//  VerticalSlider.swift
//  LearnSolarSystem
//
//  Created by Hans Arthur Cupiterson on 21/05/24.
//

import SwiftUI

struct VerticalSlider: View {
    @Binding var sliderValue: Float

    var body: some View {
        VStack {
            Image(systemName: "plus")
            Slider(value: $sliderValue, in: 0.1...2.0) {
                Text("Scale: \(sliderValue, specifier: "%.1f")")
            }
            .rotationEffect(.degrees(-90))
            .frame(width: 200, height: 300)
            .padding(.horizontal, -50)
            Image(systemName: "minus")
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    VerticalSlider(sliderValue: .constant(1))
}
