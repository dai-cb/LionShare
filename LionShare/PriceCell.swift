
import UIKit

class PriceCell: UITableViewCell {
	
	@IBOutlet weak var currencyCode: UILabel!
	@IBOutlet weak var price: UILabel!
	@IBOutlet weak var difference: UILabel!
	
	//@IBOutlet var icon: UIImageView!
	
	override func prepareForReuse() {
		//code.text = ""
	}
}

