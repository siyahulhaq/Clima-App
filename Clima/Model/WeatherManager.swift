//
//  WeatherManager.swift
//  Clima
//
//  Created by Siyahul Haq on 27/01/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDeligate {
    func onUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func failedUpdatingWeatherWithError(error: Error)
}

struct WeatherManager {
    let baseWeatherUrl = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = Datas.apiKey
    let units = "metric"
    
    var deligate: WeatherManagerDeligate?
    
    func getCityWeatherURL (_ city: String) -> String {
        return "\(baseWeatherUrl)?appid=\(apiKey)&q=\(city)&units=\(units)"
    }
    
    func getCoordinateWeatherUrl (lat: Double, lon: Double) -> String {
        return "\(baseWeatherUrl)?appid=\(apiKey)&lat=\(lat)&lon=\(lon)&units=\(units)"
    }
    
    func getWeatherApi(_ url: String) {
        let url = URL(string: url)
        
        if let safeUrl = url {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: safeUrl, completionHandler: {(data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJson(safeData) {
                        deligate?.onUpdateWeather(self, weather: weather)
                    }
                }
            });
            
            task.resume()
        }
    }
    
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let weather = WeatherModel(weatherId: decodedData.weather[0].id, tempurature: decodedData.main.temp, city: decodedData.name)
            return weather
        } catch {
            print(error)
            return nil
        }
    }
    
}
