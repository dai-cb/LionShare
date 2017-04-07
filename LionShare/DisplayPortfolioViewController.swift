import UIKit

class DisplayPortfolioViewController: PortfolioViewController,
	UITableViewDataSource,
	UITableViewDelegate {
	
	@IBOutlet weak var pieChart: PieChart!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var totalAmountLabel: UILabel!
	@IBOutlet weak var totalDifferenceLabel: UILabel!
	
	var portfolioCurrencies = [Currency]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		Currency.loadCurrencies()
		
		portfolioCurrencies = Currency.portfolioCurrencies
		
		buildPie(currencies: portfolioCurrencies)
		
		edgesForExtendedLayout = UIRectEdge()
		
		tableView.backgroundColor = UIColor.black
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		
		tableView.reloadData()
		
		totalAmountLabel.text = "\(Portfolio.shared.totalUSDAmount)"
	}
	
	func buildPie(currencies: [Currency]) {
	
		var slices: [PieChart.Slice] = []
		
		for currency in currencies {

			guard let amount = currency.portfolioAmount,
				let colour = currency.colour else { continue }
			
			var price = 0.0
			if let latest = currency.price?.latest {
				price = latest
			} else if let
				last = currency.price?.prices?.last {
				price = last
			}
			
			var slice = PieChart.Slice()
			slice.value = CGFloat(amount * price)
			slice.color = UIColor(hex: colour)
			slices.append(slice)
		}
		
		pieChart.activeSlice = 0
		pieChart.slices = slices
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return portfolioCurrencies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "portfolioCell") as? PortfolioCell else {
			return UITableViewCell()
		}

		let currency = portfolioCurrencies[indexPath.row]
		
		guard let name = currency.name,
			let colour = currency.colour,
			let symbol = currency.symbol,
			let portfolio = currency.portfolioAmount else {
				return UITableViewCell()
		}
		cell.name.text = name
		cell.dot.backgroundColor = UIColor(hex:colour)
		cell.crytpoTotal.text = "\(portfolio) \(symbol)"
		
		var price = 0.0
		if let latest = currency.price?.latest {
			price = latest
		} else if let
			last = currency.price?.prices?.last {
			price = last
		}
		
		cell.nativeTotal.text = "\(price * portfolio)"
		
		return cell
	}

	@IBAction func chartPressed(sender: UIControl) {
		pieChart.animate()
	}
	
	@IBAction func editPressed(_ sender: Any) {
		performSegue(withIdentifier: "show_to_edit", sender: self)
	}
}
