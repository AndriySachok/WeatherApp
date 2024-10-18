//
//  WeatherDayView.swift
//  weatherApp
//
//  Created by Андрій on 17.10.2024.
//

import SwiftUI

struct WeatherDayView: View {
    var parameter: String
    var imageName: String
    var value: String
    
    var body: some View {
        VStack{
            Text(parameter)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.white)
            
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
            
            Text(value)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white)
        }
    }
}
