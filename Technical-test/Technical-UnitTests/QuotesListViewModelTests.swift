//
//  QuotesListViewModel.swift
//  Technical-UnitTests
//
//  Created by Adriana Epure on 01.05.2023.
//

import XCTest
@testable import Technical_test


final class QuotesListViewModelTests: XCTestCase{
	var didFetchExpectation: XCTestExpectation = XCTestExpectation(description: "Quotes array gets populated with fetched results")
	var showErrorExpectation: XCTestExpectation = XCTestExpectation(description: "Failed to fetch quotes")
	var dataManager: DataManager!
	var market: Market!
	
	override func setUp(){
		super.setUp()
		dataManager = DataManager()
		market = Market()
	}
	
	override func tearDown() {
		super.tearDown()
	}
	
	func testInitialization(){
		
		//Initialize QuotesListViewModel
		let quotesListViewModel = QuotesListViewModel(dataManager: dataManager, market: market)
		
		XCTAssertNotNil(quotesListViewModel.dataManager, "The data manager should not be null")
		XCTAssertNotNil(quotesListViewModel.market, "The market should not be null")
		
	}
	func testFetchQuotes(){
		
		let quotesListViewModel = QuotesListViewModel(dataManager: dataManager, market: market)
		quotesListViewModel.delegate = self
		quotesListViewModel.fetchQuotes()
		wait(for: [didFetchExpectation], timeout: 5) // expectation boiler plate
		XCTAssertNotEqual(0, quotesListViewModel.quotes.count)
	}
	
	func testFavorites(){
		let initialFavoritesCount = market.quotes?.count ?? 0
		let quotesListViewModel = QuotesListViewModel(dataManager: dataManager, market: market)
		
		XCTAssertEqual(0, initialFavoritesCount)
		
		quotesListViewModel.delegate = self
		quotesListViewModel.fetchQuotes()
		wait(for: [didFetchExpectation], timeout: 5)
		
		quotesListViewModel.updateFavorite(quote: nil) /// update with nil quote
													
		let emptyFavoritesUpdateCount = market.quotes?.count ?? 0
		XCTAssertEqual(initialFavoritesCount, emptyFavoritesUpdateCount)
		
		if let firstQuote = quotesListViewModel.quotes.first {
			quotesListViewModel.updateFavorite(quote: firstQuote) /// adds to favorites
			XCTAssertTrue(firstQuote.isFavorite)
			
			let addedFavoritesUpdateCount = market.quotes?.count ?? 0
			XCTAssertEqual(initialFavoritesCount + 1, addedFavoritesUpdateCount)
			
			quotesListViewModel.updateFavorite(quote: firstQuote) /// removes from favorites
			XCTAssertFalse(firstQuote.isFavorite)
			
			let removedFavoritesUpdateCount = market.quotes?.count ?? 0
			XCTAssertEqual(addedFavoritesUpdateCount - 1, removedFavoritesUpdateCount)
			
			let emptyQuote = Quote() /// quote without a market reference
			XCTAssertFalse(emptyQuote.isFavorite)
		}
	}

}

extension QuotesListViewModelTests: QuotesListViewModelDelegate {
	
	func finishedFetchingData() {
		didFetchExpectation.fulfill()
	}
	
	func showError(description: String) {
		
	}
}
