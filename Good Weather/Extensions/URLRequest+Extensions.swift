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
	
	static func load<T>(_ resource: Resource<T>) -> Observable<T?> {
		
		Observable.from([resource.url]).flatMap { url -> Observable<Data> in
			let urlRequest = URLRequest(url: url)
			return URLSession.shared.rx.data(request: urlRequest)
		}.map { data -> T? in
			return try? JSONDecoder().decode(T.self, from: data)
		}.asObservable()
		
	}
	
}
