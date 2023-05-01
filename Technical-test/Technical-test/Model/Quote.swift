//
//  Quote.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation

/**
 Define Quote
 */
struct Quote: Decodable{
    var symbol:String?
    var name:String?
    var currency:String?
    var readableLastChangePercent:String?
    var last:String?
    var variationColor:String?
    weak var myMarket:Market?	
	/**
	 - Returns:
		- `true` when the quote was added to market favorites
		- `false` when the quote wasn't added or removed from market favorites
	 */
	var isFavorite: Bool{
		return myMarket?.isQuoteInFavorites(self) ?? false
	}
}
