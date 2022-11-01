//
//  WeatherUrl.swift
//  Good Weather
//
//  Created by kenjimaeda on 31/10/22.
//

import Foundation

extension Weather {
	
	static func urlRequest(_ city: String) -> String  {
		return "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=0f71147fe73f64e20493b89e3e439636&units=metric"
	}
	
	//precisa retornar um elemento,devido a isso, criei uma variavel
	//e instanciei o Weather
	static var empty: Weather {
		return  Weather(main: Main(temp: 0.0, humidity: 0.0))
	}
	
}
