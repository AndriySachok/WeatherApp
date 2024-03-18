//
//  WeatherView.swift
//  weatherApp
//
//  Created by Андрій on 18.03.2024.
//

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    @Binding var isNight: Bool
    
    var body: some View {
        ZStack {
            BackgroundView(isNight: isNight)
            VStack{
                CityTextView(cityName: weather.name + ", " + weather.sys.country)
                Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                    .fontWeight(.light)
                    .foregroundColor(.white)
                
                
                if weather.weather.first(where: { $0.main == "Clouds" }) != nil {
                    MainWeatherStatusView(imageName: isNight ? "cloud.moon" : "cloud.sun.fill",
                                          temperature: Int(weather.main.temp))
                } else if weather.weather.first(where: { $0.main == "Rain" }) != nil{
                    MainWeatherStatusView(imageName: isNight ? "cloud.moon.rain" : "cloud.sun.rain",
                                          temperature: Int(weather.main.temp))
                } else if weather.weather.first(where: { $0.main == "Snow" }) != nil{
                    MainWeatherStatusView(imageName: isNight ? "cloud.snow.fill" : "cloud.snow",
                                          temperature: Int(weather.main.temp))
                } else {
                    MainWeatherStatusView(imageName: isNight ? "moon.stars" : "sun.max",
                                          temperature: Int(weather.main.temp))
                }
                
                HStack(spacing: 20){
                    WeatherDayView(parameter: "Feels like", imageName: "thermometer.medium", value: weather.main.feelsLike.roundDouble() + "°" )
                    WeatherDayView(parameter: "Wind", imageName: "wind", value: weather.wind.speed.roundDouble() + "m/s")
                    WeatherDayView(parameter: "Humidity", imageName: "humidity.fill", value: weather.main.humidity.roundDouble() + "%")
                    WeatherDayView(parameter: "Max temp", imageName: "thermometer.sun", value: weather.main.tempMax.roundDouble() + "°")
                }
                Spacer()
                
                Button{
                    isNight.toggle()
                } label: {
                    WeatherButtonView(title: "Change day time",
                                      bgColor: .white,
                                      fgColor: .blue)
                }
                Spacer()
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather, isNight: Binding.constant(false))
    }
}
