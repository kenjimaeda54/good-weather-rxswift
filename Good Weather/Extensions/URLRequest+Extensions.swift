//
//  URLRequest+Extensions.swift
//  Good Weather
//
//  Created by kenjimaeda on 31/10/22.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
	let url: URL
}


extension URLRequest  {
	
	//catpure o erro
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
	
	// nao caputre o erro
//	static func load<T>(_ resource: Resource<T>) -> Observable<T?> {
//
//		Observable.from([resource.url]).flatMap { url -> Observable<Data> in
//			let urlRequest = URLRequest(url: url)
//			return URLSession.shared.rx.data(request: urlRequest)
//		}.map { data -> T? in
//			return try? JSONDecoder().decode(T.self, from: data)
//		}.asObservable()
//
//	}
//
}
