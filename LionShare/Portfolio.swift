import Foundation

open class Portfolio: NSObject {
	
	open static let shared = Portfolio()
	
	var totalNative = ""
	var totalDifference = ""
	
	func update() {
		
		var totalAmount = 0.0
		var totalDiff = 0.0
		
		print("update")
		
		for currency in Currency.displayCurrencies {
			
			guard let price = currency.price,
				let last = price.prices?.last,
				let portfolioAmount = currency.portfolioAmount else { return }
			
			if portfolioAmount == 0.0 {
				return
			}
			
			var latest = last
			if let priceLatest = price.latest,
				priceLatest > 0.0 {
				latest = priceLatest
			}
			
			totalAmount += Double(portfolioAmount * latest)
			
			totalNative = CurrencyFormatter.sharedInstance.formatAmount(amount: totalAmount, currency: "USD")
			
			let (_, diff, _) = price.difference()
			
			print("yo = \(diff)")
			
			totalDiff += diff
			
			totalDifference = CurrencyFormatter.sharedInstance.formatAmount(amount: totalDiff, currency: "USD")
			
			print("totalDiff = \(totalDiff)")
		}
	}
}
