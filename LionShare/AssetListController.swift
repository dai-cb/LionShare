
import UIKit

class AssetListController: UIViewController,
	UITableViewDataSource,
	UITableViewDelegate,
	UITextFieldDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	fileprivate var currencies = [Currency]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Currency.loadCurrencies()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		currencies = Currency.currencies
		tableView.reloadData()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//Currency.save()
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//		if indexPath.section == 0 && indexPath.row == 0 {
//			return 88
//		}
		return 44
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//		if section == 0 {
//			return 1
//		}
		return currencies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "assetCell") as? AssetCell else {
			return UITableViewCell()
		}
		
//		if indexPath.section == 0 {
//			cell.name.text = "Select All"
//			cell.dot.isHidden = true
//			return cell
//		}
		
		let currency = currencies[indexPath.row]

		guard let name = currency.name,
			let isHidden =  currency.isHidden,
			let colour = currency.colour else {
				return UITableViewCell()
		}
		
		cell.name.text = name
		cell.addSwitch.isOn = !isHidden
		cell.addSwitch.tag = indexPath.row
		cell.dot.backgroundColor = UIColor(hex:colour)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = UIColor.black
	}
	
	@IBAction func switchValueChanged(_ addSwitch: UISwitch) {
		
		let currency = currencies[addSwitch.tag]
		
		currency.isHidden = !addSwitch.isOn
		
		Currency.save()
	}
}
