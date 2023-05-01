//
//  DataManagerError.swift
//  Technical-test
//
//  Created by Adriana Epure on 01.05.2023.
//

import Foundation

/**
 Custom Data Manager Errors
 */
enum DataManagerError : Error {
	case invalidUrl
	case networkError
	case missingData
	case decodingError
	case custom(description: String)
}
