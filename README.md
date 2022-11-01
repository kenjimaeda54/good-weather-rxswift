# Good Weather
Pequena aplicação consumindo [weather api](https://openweathermap.org/api)

# Motivacao
Aprender a utilizar o RxCocoa para requisições em API


## Feature
- Usei o RxCocoa para controlar o evento do textInputField, assim não preciso usar métodos do delegate
- Primeiro exemplo esta a propriedade controlEvent, responsável por retornar o texto, apos cicla no botão do teclado
- Caso eu utilize o value como no último exemplo. Cada letra digitada sera disparado um evento 


```swift
txtInputCity.rx.controlEvent(.editingDidEndOnExit).asObservable().map {self.txtInputCity.text}.subscribe(onNext:{ city in
			guard let cityFetch = city else {return}
			
			if cityFetch.isEmpty {
				self.displayWeather(nil)
			}else {
				self.fetchWeather(cityFetch)
			}
			
		}).disposed(by: disposed)
		
//metodo abaixo sempre sera feito uma nova requisicao na api
				txtInputCity.rx.value.subscribe(onNext:{ city in
					guard let cityFetch = city else {return}
		
					if cityFetch.isEmpty {
						self.displayWeather(nil)
					}else {
						self.fetchWeather(cityFetch)
					}
	
				}).disposed(by: disposed)
				
```
##
- Para realizar requisições com o RxCocoa podemos realizar  o bind como no primeiro exemplo ou capturando erros como no segundo exemplo
- Cao utilize o segundo exemplo, precisa melhora código da extensão URLRequest, comparando o código de reposta da url
- Para intervalos o melhor método de comparação, utiliza  o operador [~=](https://betterprogramming.pub/what-is-the-operator-in-swift-7f6bc7623023) 
- No terceiro exemplo estou substituindo  o bind por driver

```swfit
    //primerio exemplo
		let search = URLRequest.load(resource).observe(on: MainScheduler.instance).catchAndReturn(Weather.empty)

		search.map { weather in

			//precisa retornar uma string
			guard let weatherMain = weather else {return ""}
			return "\(weatherMain.main.humidity)💦"

		}.bind(to: labelHumitidy.rx.text).disposed(by: disposed)

		search.map { weather in

			//precisa retornar uma string
			guard let weatherMain = weather else {return ""}
			return "\(weatherMain.main.temp)℃"

		}.bind(to: labelTemperature.rx.text).disposed(by: disposed)
   
	//===================================
	
	//segundo exemplo
 //mudei o codigo do response 
 static func load<T>(_ resource: Resource<T>) -> Observable<T> {
	  //diferenca que usa resource ao inves de [resource]
		//possui uma tapla no retorno de OBSERVABLE
		Observable.just(resource.url).flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
			  let url = URLRequest(url: url)
			return URLSession.shared.rx.response(request: url)
			
		}.map { response,data in
		 
			//operador ~= vai compapar == em cada setenca
			//https://betterprogramming.pub/what-is-the-operator-in-swift-7f6bc7623023
			
			if 200..<300 ~= response.statusCode {
				return try JSONDecoder().decode(T.self, from: data)
			}else {
				throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
			}
			
		}.asObservable()
		
	}
	
	// no controller 
	 let search =	URLRequest.load(resource)
			.retry(3) // ira recuperar 3 vezes e apos isto vai gerar erro
			.observe(on: MainScheduler.instance)
			.catch { error in
			print(error.localizedDescription)
			return Observable.just(Weather.empty)
		}.asDriver(onErrorJustReturn: Weather.empty)
		
		search.map { "\($0.main.humidity)💦" }.drive(labelHumitidy.rx.text).disposed(by: disposed)
		
		search.map {  "\($0.main.temp)℃" }.drive(labelTemperature.rx.text).disposed(by: disposed)
		
   
	//===================================
	//terceiro exemplo
			let search = URLRequest.load(resource).observe(on: MainScheduler.instance).asDriver(onErrorJustReturn: Weather.empty)

		search.map { weatherMain in
			guard let weather = weatherMain else {return ""}
			return "\(weather.main.humidity)💦"
		}.drive(labelHumitidy.rx.text).disposed(by: disposed)

		search.map { weatherMain in
			guard let weather = weatherMain else {return ""}
			return "\(weather.main.temp)℃"
		}.drive(labelTemperature.rx.text).disposed(by: disposed)

```






