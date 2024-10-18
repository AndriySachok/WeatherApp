//
//  WeatherView.swift
//  weatherApp
//
//  Created by Андрій on 18.03.2024.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    var weather: ResponseBody
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.setLocalizedDateFormatFromTemplate("MMMM d, h:mm a")
        return formatter
    }()
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: weatherViewModel.isNight)
            VStack {
                Text(weather.name + ", " + weather.sys.country)
                    .font(.system(size: 32, weight: .medium, design: .default))
                    .foregroundColor(.white)
                    .padding()

                Text("Today, \(dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(weather.dt))))")
                    .fontWeight(.light)
                    .foregroundColor(.white)
                
                
                MainWeatherStatusView(imageName: imageSelector(),
                                      temperature: Int(weather.main.temp))
                
                HStack(spacing: 20){
                    WeatherDayView(parameter: "Feels like", imageName: "thermometer.medium", value: weather.main.feelsLike.roundDouble() + "°" )
                    WeatherDayView(parameter: "Wind", imageName: "wind", value: weather.wind.speed.roundDouble() + "m/s")
                    WeatherDayView(parameter: "Humidity", imageName: "humidity.fill", value: weather.main.humidity.roundDouble() + "%")
                    WeatherDayView(parameter: "Max temp", imageName: "thermometer.sun", value: weather.main.tempMax.roundDouble() + "°")
                }
                Spacer()
                
                Button{
                    weatherViewModel.isNight.toggle()
                } label: {
                    WeatherButtonView(title: "Change day time",
                                      bgColor: .white,
                                      fgColor: .blue)
                }
                
                Spacer()
            }
        }
    }
    private func imageSelector() -> String {
        switch weather.weather.first?.main {
        case "Clouds":
            return weatherViewModel.isNight ? "cloud.moon" : "cloud.sun.fill"
        case "Rain":
            return weatherViewModel.isNight ? "cloud.moon.rain" : "cloud.sun.rain"
        case "Snow":
            return weatherViewModel.isNight ? "cloud.snow.fill" : "cloud.snow"
        default:
            return weatherViewModel.isNight ? "moon.stars" : "sun.max"
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}
