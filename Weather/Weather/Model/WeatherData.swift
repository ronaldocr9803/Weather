//
//  WeatherData.swift
//  Weather
//
//  Created by APPLE on 2/17/2 R.
//  Copyright © 2 Reiwa APPLE. All rights reserved.
//

import Foundation

struct WeatherData:Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main:Codable {
    let temp: Double
}
struct Weather: Codable {
    let id: Int
    let description: String
    let icon: String
}
