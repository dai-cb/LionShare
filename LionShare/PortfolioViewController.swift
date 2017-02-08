
import UIKit

class PortfolioViewController: UIViewController,
							   UITableViewDataSource,
							   UITableViewDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	let currencies = Currency.currencies
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBarItem = UITabBarItem(title: "Portfolio", image: nil, selectedImage: nil)
		
		tableView.backgroundColor = UIColor.black
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		tableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currencies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell") as? CurrencyCell else {
			return UITableViewCell()
		}
		
		let currency = currencies[indexPath.row]
		
		cell.name.text = currency.name
		
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

