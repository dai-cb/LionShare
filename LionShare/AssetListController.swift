
import UIKit

class AssetListController: UIViewController,
	UITableViewDataSource,
	UITableViewDelegate,
	UITextFieldDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	
	fileprivate var currencies = [Currency]()
	
	var areAllSelectedOnLaunch: Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Currency.loadCurrencies()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		currencies = Currency.currencies
		
		var total = 0
		for currency in currencies {
			guard let isHidden =  currency.isHidden else { continue }
			
			if !isHidden {
				total += 1
			}
		}
		
		if total == 0 {
			areAllSelectedOnLaunch = false
		} else if total == currencies.count {
			areAllSelectedOnLaunch = true
		}
		
		print("total = \(total)")
		print("currencies = \(currencies.count)")
		
		tableView.reloadData()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		//Currency.save()
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 44
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		}
		return currencies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "assetCell") as? AssetCell else {
			return UITableViewCell()
		}
		
		if indexPath.section == 0 {
			cell.name.text = "Select All"
			cell.dot.isHidden = true
			cell.addSwitch.tag = -1
			cell.addSwitch.isOn = !areAllSelectedOnLaunch
			return cell
		}
		
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
		
		if addSwitch.tag == -1 {
			for assetCell in tableView.visibleCells {
				guard let cell = assetCell as? AssetCell else { return }
				cell.addSwitch.setOn(addSwitch.isOn, animated: true)
			}
			
			for currency in currencies {
				currency.isHidden = addSwitch.isOn
			}
			Currency.save()
			Currency.loadCurrencies()
			currencies = Currency.currencies
			
			return
		}
		
		let currency = currencies[addSwitch.tag]
		currency.isHidden = !addSwitch.isOn
		
		Currency.save()
	}
}
