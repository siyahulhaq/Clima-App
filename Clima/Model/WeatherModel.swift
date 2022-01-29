//
//  WeatherModel.swift
//  Clima
//
//  Created by Siyahul Haq on 28/01/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let weatherId: Int
    let tempurature: Float
    let city: String
    
    var wetherTempString: String {
        return String(format: "%0.1f", tempurature)
    }
    
    var weatherIcon: String {
        switch weatherId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
        
    }
}
