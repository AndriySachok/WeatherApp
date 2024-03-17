//
//  WeatherButton.swift
//  weatherApp
//
//  Created by Андрій on 17.03.2024.
//

import SwiftUI

struct WeatherButtonView: View {
    var title: String
    var bgColor: Color
    var fgColor: Color
    
    var body: some View {
        Text(title)
            .frame(width: 280, height: 50)
            .background(bgColor)
            .foregroundColor(fgColor)
            .font(.system(size: 20, weight: .bold, design: .default))
            .cornerRadius(10)
    }
}
