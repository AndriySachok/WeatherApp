//
//  ContentView.swift
//  weatherApp
//
//  Created by Андрій on 17.03.2024.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @ObservedObject var weatherViewModel = WeatherViewModel()
    @State private var isNight = false
    @State private var isDragging = false
    
    
    var body: some View {
        VStack {
            if isDragging { AnimatedLoadView(animationName: "paper_plane_around_globe", loopMode: .loop) }
            
            if let location = locationManager.location {
                if let weather = weatherViewModel.weatherData {
                    WeatherView(weather: weather)
                        .environmentObject(weatherViewModel)
                    
                } else {
                    LoadingView()
                        .onAppear {
                            Task {
                                weatherViewModel.fetchWeather(latitude: location.latitude, longtitude: location.longitude)
                            }
                            
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
            
        }
        .gesture(
            DragGesture()
                .onChanged({ _ in
                    isDragging = true
                })
                .onEnded { _ in
                    guard let location = locationManager.location else {
                        print("Location not available")
                        return
                    }
                    
                    weatherViewModel.fetchWeather(latitude: location.latitude, longtitude: location.longitude)
                    isDragging.toggle()
                }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

