//
//  CityWeatherViewController.swift
//  jujuTest
//
//  Created by Лилия on 7/29/19.
//  Copyright © 2019 ITEA. All rights reserved.
//

import UIKit

class CityWeatherViewController: UIViewController {

    @IBOutlet weak var kyivButton: UIButton!
    @IBOutlet weak var londonButton: UIButton!
    @IBOutlet weak var newYorkButton: UIButton!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var atmosphericPressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    var nameCityId: String = ""
    
    let hostURL = "https://api.openweathermap.org/data/2.5/weather?id="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.2592076957, green: 0.2122660577, blue: 0.5007198453, alpha: 1)
        title = "Current weather data"
        
        designButton(button: kyivButton)
        kyivButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        designButton(button: newYorkButton)
        newYorkButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]

        londonButton.layer.borderColor = #colorLiteral(red: 0.2578665642, green: 0.2113707515, blue: 0.5, alpha: 1)
        londonButton.clipsToBounds = true
        londonButton.layer.borderWidth = 1
        
    }
    
    func designButton(button: UIButton) {
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.2578665642, green: 0.2113707515, blue: 0.5, alpha: 1)
    }
    
    func request() {
        
        if nameCityId != "" {
            
            if let url = URL(string: "\(hostURL)\(nameCityId)") {
                var request = URLRequest(url: url)
                
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = ["X-Api-Key": "c2dcf8ffb5cdc3f8977bfd2ae7ea4738"]
                
                let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                    guard let data = data else {
                        return
                    }
                    do {
                        let list = ApiModel()
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

                            if let main = json["main"] as? [String: Any] {
                                if let temp = main["temp"] as? Double {
                                    list.temp = temp
                                }
                                if let pressure = main["pressure"] as? Int {
                                    list.pressure = pressure
                                }
                                if let humidity = main["humidity"] as? Int {
                                    list.humidity = humidity
                                }
                            }
                            
                            if let wind = json["wind"] as? [String: Any] {
                                if let speed = wind["speed"] as? Double {
                                    list.speed = speed
                                }
                                if let deg = wind["deg"] as? Double {
                                    list.deg = deg
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            let tempCelsius = (list.temp ?? 0) - 273.15
                            let format = NSString(format: "%.2f", tempCelsius)
                            self.temperatureLabel.text = "\(format) °C"
                            self.atmosphericPressureLabel.text = "\(list.pressure ?? 0) hPa"
                            self.humidityLabel.text = "\(list.humidity ?? 0) %"
                            self.windSpeedLabel.text = "\(list.speed ?? 0) meter/sec"
                            self.windDirectionLabel.text = "\(list.deg ?? 0) °"
                        }
                    }
                    catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                }
                task.resume()
            }
        }
    }
    
    
    @IBAction func didTapShowKyivWeather(_ sender: Any) {
        nameCityId = "703448"
        request()
        
        selectedButton(button: kyivButton)
        notSelectedButton(button1: londonButton, button2: newYorkButton)
    }
    
    @IBAction func didTapShowLondonWeather(_ sender: Any) {
        nameCityId = "2643743"
        request()
        
        selectedButton(button: londonButton)
        notSelectedButton(button1: kyivButton, button2: newYorkButton)
    }
    
    @IBAction func didTapShowNewYorkWeather(_ sender: Any) {
        nameCityId = "5128581"
        request()
        
        selectedButton(button: newYorkButton)
        notSelectedButton(button1: kyivButton, button2: londonButton)
    }
    
    func selectedButton(button: UIButton) {
        button.backgroundColor = #colorLiteral(red: 0.2592076957, green: 0.2122660577, blue: 0.5007198453, alpha: 1)
        button.setTitleColor(.white, for: .normal)
    }
    
    func notSelectedButton(button1: UIButton, button2: UIButton) {
        button1.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button1.setTitleColor(#colorLiteral(red: 0.2592076957, green: 0.2122660577, blue: 0.5007198453, alpha: 1), for: .normal)
        button2.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button2.setTitleColor(#colorLiteral(red: 0.2592076957, green: 0.2122660577, blue: 0.5007198453, alpha: 1), for: .normal)
    }
}
