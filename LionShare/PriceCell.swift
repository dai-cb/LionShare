import UIKit

class PriceCell: UITableViewCell {
	
	@IBOutlet weak var currencyCode: UILabel!
	@IBOutlet weak var price: UILabel!
	@IBOutlet weak var difference: UILabel!
	@IBOutlet weak var dot: UIView!
	@IBOutlet weak var chart: ChartView!

}

