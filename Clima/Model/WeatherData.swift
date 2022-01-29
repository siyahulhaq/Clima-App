//
//  WeatherData.swift
//  Clima
//
//  Created by Siyahul Haq on 28/01/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable{
    let temp: Float
}

struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
