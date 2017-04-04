
import UIKit

class EditPortfolioViewController: PortfolioViewController,
								   UITableViewDataSource,
								   UITableViewDelegate,
								   UITextFieldDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	@IBAction func savePressed(_ sender: Any) {
		// Save
		performSegue(withIdentifier: "edit_to_show", sender: self)
	}
		
	@IBAction func cancelPressed(_ sender: Any) {
		performSegue(withIdentifier: "edit_to_show", sender: self)
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBarItem = UITabBarItem(title: "Portfolio", image: nil, selectedImage: nil)
		
		tableView.backgroundColor = UIColor.black
	}
	
	override func viewDidAppear(_ animated: Bool) {
	
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currencies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell") as? CurrencyCell else {
			return UITableViewCell()
		}
		
		let currency = currencies[indexPath.row]
		
		if let amount = currency.amount {
			cell.textField.text = "\(amount)"
		}
		
		cell.name.text = currency.name
		cell.textField.delegate = self
		cell.textField.tag = indexPath.row
		
		cell.symbol.text = currency.symbol
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = UIColor.black
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		let currency = currencies[textField.tag]
		
		if let amountText = textField.text,
			let amount = Double(amountText) {
				currency.amount = amount
		}
		
		Currency.save()
		
		tableView.reloadData()
	}
	
	override var prefersStatusBarHidden: Bool {
		get {
			return true
		}
	}
}
