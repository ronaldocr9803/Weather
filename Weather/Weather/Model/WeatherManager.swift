//
//  WeatherManager.swift
//  Weather
//
//  Created by APPLE on 2/17/2 R.
//  Copyright © 2 Reiwa APPLE. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    //let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lang=vi&appid=aed5cad1fbbc0d61bb4f3e7f160826b3&units=metric"
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?lang=vi&appid=aed5cad1fbbc0d61bb4f3e7f160826b3&units=metric"
    var delegate: WeatherManagerDelegate?
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        //print(urlString)
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. Create URL
        if let url = URL(string: urlString) {
            //2. Create URL session
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    //print(error!)
                    return // exit out of the function and don't continue
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        //                        let weatherVC = WeatherViewController()
                        //                        weatherVC.didUpdateWeather(weather: weather)
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        //inside closure need self
                    }
                }
                
            }
            
            //4. Start the task
            task.resume()
            
            
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let cityName = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
            //            print(weather.conditionName)
            //            print(weather.temperatureString)
            return weather
        } catch {
            //print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
    
}

