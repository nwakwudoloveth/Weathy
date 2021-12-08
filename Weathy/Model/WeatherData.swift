//
//  WeatherData.swift
//  Weathy
//
//  Created by Loveth Nwakwudo on 12/5/21.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

