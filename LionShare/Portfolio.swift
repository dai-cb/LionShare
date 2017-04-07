import Foundation

open class Portfolio: NSObject {
	
	open static let shared = Portfolio()
	
	var totalUSDAmount: Double = 0.0
	
	func update() {
		
		totalUSDAmount = 0.0
		
		for currency in Currency.displayCurrencies {
			
			print("*** currency = \(String(describing: currency.symbol))")
			
			guard let price = currency.price,
				let last = price.prices?.last,
				let portfolioAmount = currency.portfolioAmount else { return }
			
			if portfolioAmount == 0.0 {
				return
			}
			
			
			print("last = \(last)")
			print("portfolioAmount = \(portfolioAmount)")
			
			var latest = last
			if let priceLatest = price.latest,
				priceLatest > 0.0 {
				latest = priceLatest
			}
			
			print("latest = \(latest)")
			
			totalUSDAmount += Double(portfolioAmount * latest)
			
			print("totalUSDAmount = \(totalUSDAmount)")
		}
	}
}
