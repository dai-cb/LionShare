
import UIKit

class PricesViewController: UIViewController,
							UITableViewDataSource,
							UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	
	let currencies = Currency.currencies
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBarItem = UITabBarItem(title: "Prices", image: nil, selectedImage: nil)
		
		tableView.backgroundColor = UIColor.black
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		fetchPrices()
	}
	
	fileprivate func fetchPrices() {
		
		// fetch timerange
		let request = URLRequest(url: URL(string: "https://api.lionshare.capital/api/prices?period=day")!)
		Client.shared.getPrices(request: request) { (prices) in
			
			if let prices = prices {
				
				for price in prices {
					for currency in self.currencies {
						if price.id == currency.symbol {
							currency.price = price
						}
					}
				}
			}
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currencies.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell") as? PriceCell else {
			return UITableViewCell()
		}
		
		let currency = currencies[indexPath.row]
		
		cell.currencyCode.text = currency.symbol
		
		guard let price = currency.price,
			let prices = price.prices,
			let last = prices.last else {
				return UITableViewCell()
		}

		cell.price.text = CurrencyFormatter.sharedInstance.formatAmount(amount: last, currency: "USD")
		
		cell.price.textColor = UIColor(netHex:currency.colour!)
		
		let (difference, sign) = price.difference()
		
		cell.difference.text = difference
		
		cell.difference.textColor = sign == .plus ? UIColor.green : UIColor.red
		
		// handle random colour if no colour set
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = UIColor.black
	}
	
	override var prefersStatusBarHidden: Bool {
		get {
			return true
		}
	}
}

extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(netHex:Int) {
		self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
	}
}
