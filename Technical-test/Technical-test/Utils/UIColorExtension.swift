//
//  UIColorExtension.swift
//  Technical-test
//
//  Created by Adriana Epure on 01.05.2023.
//

import UIKit


extension UIColor{
	static func colorWith(name: String?) -> UIColor{
		guard let name = name else { return .black}
		switch name {
		case "green":
			return UIColor.green
		case "red":
			return UIColor.red
		default:
			return UIColor.black
		}
	}
}
