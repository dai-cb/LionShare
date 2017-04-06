import UIKit
class AssetCell: UITableViewCell {
	
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var dot: UIView!
	@IBOutlet weak var addSwitch: UISwitch!
	
	override func prepareForReuse() {
		
	}
}
