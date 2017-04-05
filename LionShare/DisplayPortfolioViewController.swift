import UIKit

class DisplayPortfolioViewController: UIViewController {
	
	@IBOutlet weak var pieChart: PieChart!
	
	@IBAction func editPressed(_ sender: Any) {
		performSegue(withIdentifier: "show_to_edit", sender: self)
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
				
		var error = PieChart.Slice()
		error.value = 100
		error.color = UIColor.blue
		
		var zero = PieChart.Slice()
		zero.value = 1000
		zero.color = UIColor.red
		
		var win = PieChart.Slice()
		win.value = 500
		win.color = UIColor.orange
		
		pieChart.activeSlice = 2
		pieChart.slices = [error, zero, win]
	}
	
	@IBAction func chartPressed(sender: UIControl) {
		pieChart.animate()
	}
}
