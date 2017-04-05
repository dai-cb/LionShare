import Foundation

class Price: NSObject {
	
	enum Sign {
		case plus, minus
	}
	
	var id: String?
	var prices: [Double]?
	
	func difference() -> (String, Sign) {
		
		guard let prices = self.prices else {
			return ("", .plus)
		}
		
		//print("prices = \(prices)")
		
		let percent = ((1/(prices.first! / prices.last!)) - 1) * 100
		
		var sign: Sign = .plus
		
		if percent < 0 {
			sign = .minus
		}
		
		let percentString = "\(CurrencyFormatter.sharedInstance.percentFormatter.string(from: NSNumber(value: percent))!)%"
		
		return (percentString, sign)
	}
}
