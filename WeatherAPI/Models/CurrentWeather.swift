//
//  CurrentWeather.swift
//  WeatherAPI
//
//  Created by liga.griezne on 11/11/2023.
//

import Foundation

struct CurrentWeather:Codable{
    let location: Location
    let current: Current
}
