import UIKit
class AssetCell: UITableViewCell {
	
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var dot: UIView!
	@IBOutlet weak var addSwitch: UISwitch!
	@IBOutlet weak var allButton: UIButton!
	@IBOutlet weak var noneButton: UIButton!
	
	override func prepareForReuse() {
		
	}
}
