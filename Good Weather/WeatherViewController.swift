//
//  ViewController.swift
//  Good Weather
//
//  Created by kenjimaeda on 31/10/22.
//

import UIKit

class WeatherViewController: UIViewController {

	@IBOutlet weak var labelHumitidy: UILabel!
	@IBOutlet weak var labelCity: UILabel!
	@IBOutlet weak var txtInputCity: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		txtInputCity.layer.borderColor = UIColor(ciColor: .black).cgColor
		txtInputCity.layer.borderWidth = 0.5
		txtInputCity.layer.cornerRadius = 3
		
	}


}

