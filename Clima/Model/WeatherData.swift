//
//  WeatherData.swift
//  Clima
//
//  Created by Riyan Pahuja on 8/2/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData : Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main : Codable {
    let temp : Double
}

struct Weather : Codable {
    let id: Int
}
