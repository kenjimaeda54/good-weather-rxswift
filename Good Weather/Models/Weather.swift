//
//  Weather.swift
//  Good Weather
//
//  Created by kenjimaeda on 31/10/22.
//

import Foundation


struct Weather: Decodable  {
	let main: Main
}

//quando vier dados quebrados o ideal e ser double
struct Main: Decodable {
	let temp: Double
	let humidity: Double
}
