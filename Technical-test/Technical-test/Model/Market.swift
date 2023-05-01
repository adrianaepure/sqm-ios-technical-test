//
//  Market.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 30.04.21.
//

import Foundation


class Market: Decodable {
    var marketName:String = "SMI"
    var quotes:[Quote]? = []
}

extension Market{
	/**
	 Checks if the given `quote` is found in `quotes` array
	 
	 - Parameters:
		- `quote`
	 
	 - Returns:- `true` when the quote was added to market favorites;  `false` when the quote wasn't added or removed from market favorites
	 */
	func isQuoteInFavorites(_ quote: Quote)->Bool{
		return quotes?.contains(where: {$0.name == quote.name}) ?? false
	}
	
	/**
	 Updates `quotes` array with the given `quote`
	 
	 - Parameters:
	 - `quote`
	 */
	
	func updateFavorites(with quote: Quote){
		if !(quotes?.contains(where: {$0.name == quote.name}) ?? false) {
			quotes?.append(quote)
		}else{
			quotes?.removeAll(where: {$0.name == quote.name})
		}
	}
}
