
import Foundation

class Price: NSObject {
	
	var id: String?
	var prices: [Double]?
	
	func difference() -> String {
		
		guard let prices = self.prices else {
			return ""
		}
		
		let percent = ((1/(prices.first! / prices.last!)) - 1) * 100
		
		let percentString = "\(CurrencyFormatter.sharedInstance.percentFormatter.string(from: NSNumber(value: percent))!)%"
		
		return percentString
	}
	
}
