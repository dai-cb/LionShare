import Foundation
import UIKit

open class Constants: NSObject {
	
	open static let shared = Constants()
	
	static let greenPositiveColour = UIColor( red: CGFloat(49/255.0), green: CGFloat(202/255.0), blue: CGFloat(65/255.0), alpha: CGFloat(1.0))
	static let redNegativeColour = UIColor( red: CGFloat(248/255.0), green: CGFloat(44/255.0), blue: CGFloat(44/255.0), alpha: CGFloat(1.0))
}

extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(hex:Int) {
		self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
	}
}
