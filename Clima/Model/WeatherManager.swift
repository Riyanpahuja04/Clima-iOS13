//
//  NewController.swift
//  Clima
//
//  Created by Riyan Pahuja on 8/2/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherManager {
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?appid=446eeeb34067701a8c27b898e65a5353&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherUrl)&q=\(cityName)"
        print("Final Url: \(urlString)")
        performRequest(with : urlString)
        
    }
    
    func fetchWeather(latitude:  CLLocationDegrees, longitude:  CLLocationDegrees){
        let latAndLong = "&lat=\(latitude)&lon=\(longitude)"
        let urlString = weatherUrl + latAndLong
        performRequest(with: urlString)
    }
    
    func performRequest(with url: String){
        if let url = URL(string: url){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJson(safeData) {
                        DispatchQueue.main.async {
                            delegate?.didUpdateWeather(self, weather: weather)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temprature: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}
