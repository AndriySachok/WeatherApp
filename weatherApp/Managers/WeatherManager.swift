//
//  WeatherManager.swift
//  weatherApp
//
//  Created by Андрій on 18.03.2024.
//

import Foundation
import CoreLocation
import SwiftUI

class WeatherManager {
    @Binding var isNight: Bool
    
    init(isNight: Binding<Bool>){
        _isNight = isNight
    }
    
    func getCurrentWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) async throws -> ResponseBody {
        let apiKey: String = "9b38b321dd6cde72709c44c8a9c4e5f7"

        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longtitude)&appid=\(apiKey)&units=metric")
        else {fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else {fatalError("Error fetching weather data")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        let currentTime = Date(timeIntervalSince1970: TimeInterval(decodedData.dt))
        let sunriseTime = Date(timeIntervalSince1970: TimeInterval(decodedData.sys.sunrise))
        let sunsetTime = Date(timeIntervalSince1970: TimeInterval(decodedData.sys.sunset))
        
        if currentTime > sunriseTime && currentTime < sunsetTime {
            isNight = false
           } else {
               isNight = true
           }
        
        return decodedData
    }
}

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    var dt: Int
    var sys: SysResponse
    
    struct CoordinatesResponse: Decodable{
        var lon: Double
        var lat: Double
    }
    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }
    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
    struct SysResponse: Decodable {
        var country: String
        var sunrise: Int
        var sunset: Int
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
