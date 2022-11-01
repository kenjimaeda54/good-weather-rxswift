# Good Weather
Pequena aplicacao consumidno [weather api](https://openweathermap.org/api)


# Motivacao
Aprender a utlizar o RxCocoa para requisicoes em API

## Feature
- Usei o RxCocoa para controlar o evento do textInputField,assim nao preciso usar metodos delegate


```swfit
txtInputCity.rx.controlEvent(.editingDidEndOnExit).asObservable().map {self.txtInputCity.text}.subscribe(onNext:{ city in
			guard let cityFetch = city else {return}
			
			if cityFetch.isEmpty {
				self.displayWeather(nil)
			}else {
				self.fetchWeather(cityFetch)
			}
			
		}).disposed(by: disposed)




```
