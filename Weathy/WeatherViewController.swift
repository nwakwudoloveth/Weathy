//
//  WeatherViewController.swift
//  Weathy
//
//  Created by Loveth Nwakwudo on 12/5/21.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController, UITextFieldDelegate {
    
    var timer = Timer()
   
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
         timer = Timer.scheduledTimer(timeInterval: 60, target: self,
        selector: #selector (updateLabel), userInfo: nil, repeats: true)
            
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @objc func updateLabel(){
    let dateformatter = DateFormatter()
        dateformatter.dateStyle = .full
        dateformatter.timeStyle = . short
    let present = Date()
    datelabel.text = "\(dateformatter.string(from:present))"

    }
    
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Enter City Name"
            return false
        }
}
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
           weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
        
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    
   
        
        func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.weatherImage.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.descriptionLabel.text = weather.descripsion
            self.updateLabel()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
extension WeatherViewController: CLLocationManagerDelegate {
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
