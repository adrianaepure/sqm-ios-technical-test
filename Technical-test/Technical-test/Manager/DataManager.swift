//
//  DataManager.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation


protocol DataManagerService{
	func fetchQuotes(completionHandler: @escaping (Result<[Quote], DataManagerError>) -> Void)
}
class DataManager {
    
    private static let path = "https://www.swissquote.ch/mobile/iphone/Quote.action?formattedList&formatNumbers=true&listType=SMI&addServices=true&updateCounter=true&&s=smi&s=$smi&lastTime=0&&api=2&framework=6.1.1&format=json&locale=en&mobile=iphone&language=en&version=80200.0&formatNumbers=true&mid=5862297638228606086&wl=sq"
    
	private let session: URLSession
	/**
	 Initialize a new DataManager with the provided session
	 - Parameters:
		- session: provided URLSession; default is the shared URLSession
	 */
	init(session: URLSession = URLSession.shared) {
		self.session = session
	}
}

//MARK: Methods
extension DataManager{
	/**
	 Performs a HTTP request and returns a result, parsing data based on T generic type
	 */
	func fetch<T: Decodable>(path: String, completionHandler: @escaping (Result<T, DataManagerError>) -> Void){
		//Create URL from path
		guard let url = URL(string: DataManager.path) else {
			completionHandler(.failure(.invalidUrl))
			return
		}
		let task = session.dataTask(with: url) { data, response, error in
			if let error = error {
				completionHandler(.failure(DataManagerError.custom(description: error.localizedDescription)))
			}
			
			guard let data = data else {
				completionHandler(.failure(.missingData))
				return
			}
			
			do{
				//Parse JSON Data using T type
				let result = try JSONDecoder().decode(T.self, from: data)
				completionHandler(.success(result))
				
			}catch {
				completionHandler(.failure(.decodingError))
			}
			
		}
		task.resume()
	}
}

//MARK: DataManagerService protocol method implementation
extension DataManager: DataManagerService{
	/**
	 Fetches quotes array from the give path
	 */
	func fetchQuotes(completionHandler: @escaping (Result<[Quote], DataManagerError>) -> Void) {
		fetch(path: DataManager.path) { (result: Result<[Quote], DataManagerError>) in
			completionHandler(result)
		}
	}
	
	
}
