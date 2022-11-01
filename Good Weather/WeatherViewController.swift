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
		
		//aqui estou controlando o evento do text field
		txtInputCity.rx.controlEvent(.editingDidEndOnExit).asObservable().map {self.txtInputCity.text}.subscribe(onNext:{ city in
			guard let cityFetch = city else {return}
			
			if cityFetch.isEmpty {
				self.displayWeather(nil)
			}else {
				self.fetchWeather(cityFetch)
			}
			
		}).disposed(by: disposed)
		
		//metodo abaixo sempre sera feito uma nova requisicao na api
		//		txtInputCity.rx.value.subscribe(onNext:{ city in
		//			guard let cityFetch = city else {return}
		//
		//			if cityFetch.isEmpty {
		//				self.displayWeather(nil)
		//			}else {
		//				self.fetchWeather(cityFetch)
		//			}
		//
		//		}).disposed(by: disposed)
		
	}
	
	private func fetchWeather(_ city: String) {
		
		guard let cityPercentEncoding = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: Weather.urlRequest(cityPercentEncoding)) else {return}
		
		//precisa do tipo porque instanciamos reouser como T
		let resource = Resource<Weather>(url: url)
		
		//com observe e possivel realizar requisicoes conforme usuario digita
		//assim gera uma experiencia mais agradavel
		
		//para capturar o erro e necessario criar um elemento que sera
		//responsavel para ser exibido caso ocorra erro
		//		URLRequest.load(resource)
		//			.observe(on: MainScheduler.instance)
		//			.catchAndReturn(Weather.empty)
		//			.subscribe(onNext: {[self]weather in
		//				displayWeather(weather?.main)
		//			}).disposed(by: disposed)
		
		//pode usar o rx cocoa usando bind
//		let search = URLRequest.load(resource).observe(on: MainScheduler.instance).catchAndReturn(Weather.empty)
//
//		search.map { weather in
//
//			//precisa retornar uma string
//			guard let weatherMain = weather else {return ""}
//			return "\(weatherMain.main.humidity)💦"
//
//		}.bind(to: labelHumitidy.rx.text).disposed(by: disposed)
//
//		search.map { weather in
//
//			//precisa retornar uma string
//			guard let weatherMain = weather else {return ""}
//			return "\(weatherMain.main.temp)℃"
//
//		}.bind(to: labelTemperature.rx.text).disposed(by: disposed)
//
		
		//usanmdo driver e recuperando o error
	 let search =	URLRequest.load(resource)
			.retry(3) // ira recuperar 3 vezes e apos isto vai gerar erro
			.observe(on: MainScheduler.instance)
			.catch { error in
			print(error.localizedDescription)
			return Observable.just(Weather.empty)
		}.asDriver(onErrorJustReturn: Weather.empty)
		
		search.map { "\($0.main.humidity)💦" }.drive(labelHumitidy.rx.text).disposed(by: disposed)
		
		search.map {  "\($0.main.temp)℃" }.drive(labelTemperature.rx.text).disposed(by: disposed)
		
		//usando driver
//
//		let search = URLRequest.load(resource).observe(on: MainScheduler.instance).asDriver(onErrorJustReturn: Weather.empty)
//
//		search.map { weatherMain in
//			guard let weather = weatherMain else {return ""}
//			return "\(weather.main.humidity)💦"
//		}.drive(labelHumitidy.rx.text).disposed(by: disposed)
//
//		search.map { weatherMain in
//			guard let weather = weatherMain else {return ""}
//			return "\(weather.main.temp)℃"
//		}.drive(labelTemperature.rx.text).disposed(by: disposed)
		
		
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

