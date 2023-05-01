//
//  QuotesListViewModel.swift
//  Technical-test
//
//  Created by Adriana Epure on 01.05.2023.
//

import Foundation

protocol QuotesListViewModelDelegate: AnyObject{
	func finishedFetchingData()
	func showError(description: String)
}

/**
 Holds the business logic for the `QuotesListViewController`
 
 */
class QuotesListViewModel{
	
	let dataManager: DataManager
	let market: Market
	weak var delegate: QuotesListViewModelDelegate?
	lazy var quotes: [Quote] = [] /// array of fetched quotes
	
	/**
	 Initialize a new QuotesListViewModel with the `DataManager` and `Market`
	 - Parameters:
	 - `dataManager`: injected manager used for accessing the network layer
	 - `market`: user market object for storing favorite quotes array
	 */
	init(dataManager: DataManager, market: Market) {
		self.dataManager = dataManager
		self.market		 = market
	}
}

//MARK: QuotesListViewModel methods
extension QuotesListViewModel{
	/**
	 Updates the list of favorite quotes from the user's market
	 - Parameters:
	 - `quote`: quote to update in the market favorites list
	 */
	func updateFavorite(quote: Quote?){
		guard let quote = quote else { return}
		market.updateFavorites(with: quote)
	}
	
	/**
	 Fetches the quotes from the API
	 */
	func fetchQuotes(){
		dataManager.fetchQuotes {[weak self] result in
			switch result {
			case .success(var quotes):
				for index in quotes.indices {
					quotes[index].myMarket = self?.market /// keep reference to the market object
				}
				self?.quotes = quotes /// update the list of fetched quotes
				self?.delegate?.finishedFetchingData()
			case .failure(let error):
				self?.delegate?.showError(description: error.localizedDescription)
			}
		}
	}
	
}
