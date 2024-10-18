//
//  WeatherManager.swift
//  weatherApp
//
//  Created by Андрій on 18.03.2024.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

class WeatherManager {
    
    func getCurrentWeather(latitude: CLLocationDegrees, longtitude: CLLocationDegrees) -> AnyPublisher<ResponseBody, Error> {
        let apiKey: String = Env.key ?? ""

        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longtitude)&appid=\(apiKey)&units=metric")
        else {fatalError("Missing URL")}
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: ResponseBody.self, decoder: JSONDecoder())
            .catch { error -> AnyPublisher<ResponseBody, Error> in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
