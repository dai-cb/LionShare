import Foundation

class Price: NSObject {
	
	enum Sign {
		case plus, minus
	}
	
	var id: String?
	var prices: [Double]?
	var latest: Double?

	func difference() -> (String, Double, Sign) {
		
		guard let prices = self.prices,
			let first = prices.first,
			let last = prices.last else {
			return ("", 0.0, .plus)
		}
		
		if latest == nil || latest == 0.0 {
			latest = last
		}
		
		let percent = ((1/(first / latest!)) - 1) * 100
		
		let diff = latest! - first
		
		var sign: Sign = .plus
		
		if percent < 0 {
			sign = .minus
		}
		
		let percentString = "\(CurrencyFormatter.sharedInstance.percentFormatter.string(from: NSNumber(value: percent))!)%"
		
		return (percentString, diff, sign)
	}
}
