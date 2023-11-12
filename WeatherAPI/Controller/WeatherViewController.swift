//
//  WeatherViewController.swift
//  WeatherAPI
//
//  Created by liga.griezne on 12/11/2023.
//

import UIKit
import Alamofire

class WeatherViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelLikeTempLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var textFieldButton: UIButton!
    
    let apiKey:String = "5e7db7bf64msh3cca0bae2b7abb8p17c4f2jsn78d5baee4ecb"
    let apiHost:String = "weatherapi-com.p.rapidapi.com"
    let apiUrl:String = "https://weatherapi-com.p.rapidapi.com/current.json"
    let city: String = "London"
    var currentWeather:CurrentWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeatherData(for: city)
    }
    func loadWeatherData(for city: String){
        let headers: [String: String] = ["X-RapidAPI-Key": apiKey, "X-RapidAPI-Host": apiHost]
        let params: [String: String] = ["q": city]
        AF.request(apiUrl, method: .get, parameters: params, headers: HTTPHeaders(headers)).responseDecodable(of: CurrentWeather.self) { response in
            switch response.result {
            case .success(let value):
                self.currentWeather = value
                DispatchQueue.main.async {
                    self.updateWeatherData(notEmpty: true)
                    self.updateBackgroundImage()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.updateWeatherData(notEmpty: false)
                }
            }
        }
    }
    func updateBackgroundImage() {
       if let temperature = currentWeather?.current.tempC {
           var imageName: String

           if temperature < 10 {
               imageName = "tempAppDarkCold"
           } else if temperature >= 10 && temperature < 20 {
               imageName = "tempAppDarkWarm"
           } else {
               imageName = "tempAppDarkHot"
           }
           view.subviews.forEach { $0.removeFromSuperview() }
           view.addSubview(cityLabel)
           view.addSubview(tempLabel)
           view.addSubview(feelLikeTempLabel)
           view.addSubview(cityTextField)
           view.addSubview(textFieldButton)
           print("temperature: \(temperature), imaga name \(imageName)")

           if let image = UIImage(named: imageName) {
                       let imageView = UIImageView(image: image)
                       imageView.contentMode = .scaleAspectFill
                       imageView.frame = view.bounds
                       view.addSubview(imageView)
                       view.sendSubviewToBack(imageView)
           }
       } else {
           self.view.backgroundColor = UIColor.white
       }
   }
    func updateWeatherData(notEmpty: Bool) {
        if notEmpty {
            let weather = currentWeather
            cityLabel.text = weather?.location.name
            tempLabel.text = "\(weather?.current.tempC ?? 0)°C"
            feelLikeTempLabel.text = "Feels like \(weather?.current.feelslikeC ?? 0)°C"
        } else {
            cityLabel.text = "City not found"
            tempLabel.text = "N/A"
            feelLikeTempLabel.text = "N/A"
        }
    }
    @IBAction func cityButtonTapped(_ sender: Any) {
        if let city = cityTextField.text, !city.isEmpty {
                  loadWeatherData(for: city)
              }
          }
    }


