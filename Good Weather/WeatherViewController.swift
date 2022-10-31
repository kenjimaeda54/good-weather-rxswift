//
//  ViewController.swift
//  Good Weather
//
//  Created by kenjimaeda on 31/10/22.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UIViewController {
	
	//MARK: -  IBOutlet
	@IBOutlet weak var labelHumitidy: UILabel!
	@IBOutlet weak var labelTemperature: UILabel!
	@IBOutlet weak var txtInputCity: UITextField!
	
	//MARK: - Vars
	let disposed = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		txtInputCity.layer.borderColor = UIColor(ciColor: .black).cgColor
		txtInputCity.layer.borderWidth = 0.5
		txtInputCity.layer.cornerRadius = 3
		
		txtInputCity.rx.value.subscribe(onNext:{ city in
			guard let cityFetch = city else {return}
			
			if cityFetch.isEmpty {
				self.displayWeather(nil)
			}else {
				self.fetchWeather(cityFetch)
			}
			
		}).disposed(by: disposed)
		
	}
	
	private func fetchWeather(_ city: String) {
		
		guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: Weather.urlRequest(cityEncoded)) else {return}
		
		let resource =  Resource<Weather>(url: url)
		URLRequest.load(resource)
			.catchAndReturn(Weather.empty)
			.observe(on: MainScheduler.instance)
			.subscribe(onNext:{[self] weather in
				displayWeather(weather?.main)
		}).disposed(by: disposed)
		
	}
	
	private func displayWeather(_ weather: Main?) {
		
		if let weather = weather  {
			labelHumitidy.text = "\(weather.humidity)💦"
			labelTemperature.text = "\(weather.temp)℃"
		}else {
			labelHumitidy.text = "🚫"
			labelTemperature.text =  "🙈"
			
		}
		
	}
	
}

