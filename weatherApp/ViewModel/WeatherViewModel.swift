//
//  WeatherViewModel.swift
//  weatherApp
//
//  Created by Андрій on 18.10.2024.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    let weatherManager = WeatherManager()
    private var cancellables = Set<AnyCancellable>()
    
    var weatherData: ResponseBody? {
        willSet {
            print("toot")
            objectWillChange.send()
        }
    }
    @Published var isNight = false
    
    func fetchWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        weatherManager.getCurrentWeather(latitude: latitude, longtitude: longtitude)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.weatherData = nil
                }
            }, receiveValue: { [weak self] value in
                self?.weatherData = value
                let currentTime = value.dt
                let sunriseTime = value.sys.sunrise
                let sunsetTime = value.sys.sunset
                
                if currentTime > sunriseTime && currentTime < sunsetTime {
                    self?.isNight = false
                } else {
                    self?.isNight = true
                }
            })
            .store(in: &cancellables)
    }
}
