import UIKit

class CurrencyCell: UITableViewCell {
	
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var symbol: UILabel!
	@IBOutlet weak var hideSwitch: UISwitch!
	
	override func prepareForReuse() {
		
	}
}
