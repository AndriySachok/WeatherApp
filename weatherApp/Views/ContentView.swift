//
//  ContentView.swift
//  weatherApp
//
//  Created by Андрій on 17.03.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var isNight = false
    
    
    @State var weather: ResponseBody?
    
    var body: some View {
        let weatherManager = WeatherManager(isNight: $isNight)
        
        VStack {
            if let location = locationManager.location {
                if let weather = weather {
                    WeatherView(weather: weather, isNight: $isNight)
                    
                    
                } else {
                    LoadingView()
                        .task{
                            do{
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longtitude: location.longitude)
                            } catch{
                                print("Error getting weather", error)
                            }
                        }
                }
            } else {
                if(locationManager.isLoading){
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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

struct BackgroundView: View {
    var isNight: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue,
                                                   isNight ? .gray : Color("LightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .ignoresSafeArea(.all)
    }
}

struct CityTextView: View {
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundColor(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: 180, height: 180)
            
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(.bottom, 40)
    }
}

