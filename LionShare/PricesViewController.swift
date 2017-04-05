import UIKit
import LionShareKit

class PricesViewController: UIViewController,
							UITableViewDataSource,
							UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	
	fileprivate var displayCurrencies = [Currency]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Currency.loadCurrencies()
		
		tabBarItem = UITabBarItem(title: "Prices", image: nil, selectedImage: nil)
		
		tableView.backgroundColor = UIColor.black
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		displayCurrencies = Currency.displayCurrencies
		
		fetchPrices()
	}
	
	fileprivate func fetchPrices() {
		Client.shared.getPrices() { (prices, error) in
			defer {
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
			
			if let error = error {
				print("error = \(error)")
				return
			}
			
			guard let prices = prices  else {
				return
			}
			
			for price in prices {
				for currency in Currency.currencies {
					if price.id == currency.symbol {
						currency.price = price
					}
				}
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return displayCurrencies.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell") as? PriceCell else {
			return UITableViewCell()
		}
		
		let currency = displayCurrencies[indexPath.row]
		
		cell.currencyCode.text = currency.symbol
		
		guard let price = currency.price,
			let prices = price.prices,
			let last = prices.last,
			let colour = currency.colour else {
				return UITableViewCell()
		}

		cell.price.text = CurrencyFormatter.sharedInstance.formatAmount(amount: last, currency: "USD")
		
		let (difference, sign) = price.difference()
		
		cell.difference.text = difference
		
		cell.difference.textColor = sign == .plus ? Constants.greenPositiveColour : Constants.redNegativeColour
		
		cell.dot.backgroundColor = UIColor(netHex:colour)
		cell.chart.lineColour = UIColor(netHex:colour)
		cell.chart.prices = prices
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = UIColor.black
	}
}
