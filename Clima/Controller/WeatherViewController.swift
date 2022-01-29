//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchLabel: UITextField!
    
    var weatherManager = WeatherManager()
    var weather: WeatherModel?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchLabel.delegate = self
        weatherManager.deligate = self
    }
    
    @IBAction func getCurrentLocationWeather(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func onSearchPressed(_ sender: Any) {
        searchLabel.endEditing(true)
    }
    
}

// Mark: -

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.getWeatherApi(weatherManager.getCoordinateWeatherUrl(lat: lat, lon: lon))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// Mark: -

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter a city name"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        weatherManager.getWeatherApi(weatherManager.getCityWeatherURL(textField.text!))
        
    }
}


// Mark: -

extension WeatherViewController: WeatherManagerDeligate {
    func onUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel) {
        self.weather = weather
        updateUI()
    }
    
    func failedUpdatingWeatherWithError(error: Error) {
        print(error)
    }
    
    func updateUI() {
        if weather != nil {
            DispatchQueue.main.async {
                self.temperatureLabel.text = self.weather?.wetherTempString ?? ""
                self.cityLabel.text = self.weather?.city
                self.conditionImageView.image = UIImage(systemName: self.weather?.weatherIcon ?? "")
            }
        }
    }
}
