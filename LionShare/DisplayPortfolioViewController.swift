import UIKit

class DisplayPortfolioViewController: PortfolioViewController {
	
	@IBOutlet weak var pieChart: PieChart!
	
	var portfolioCurrencies = [Currency]()
	
	@IBAction func editPressed(_ sender: Any) {
		performSegue(withIdentifier: "show_to_edit", sender: self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
			
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		Currency.loadCurrencies()
		
		portfolioCurrencies = Currency.portfolioCurrencies
		
		buildPie(currencies: portfolioCurrencies)
	}
	
	func buildPie(currencies: [Currency]) {
	
		print("currencies = \(currencies)")
		
		var slices: [PieChart.Slice] = []
		
		for currency in currencies {

			guard let amount = currency.portfolioAmount,
				let colour = currency.colour else { continue }
			
			var slice = PieChart.Slice()
			slice.value = CGFloat(amount)
			slice.color = UIColor(hex: colour)
			slices.append(slice)
		}
		
		pieChart.activeSlice = 0
		pieChart.slices = slices
	}
	
	@IBAction func chartPressed(sender: UIControl) {
		pieChart.animate()
	}
}
