
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

		edgesForExtendedLayout = UIRectEdge()
		
		UIBarButtonItem.appearance().tintColor = UIColor(red: 254/255 , green: 115/255, blue: 0, alpha: 1)
		
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		navigationItem.backBarButtonItem?.accessibilityLabel = "Back"
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
		return 44
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if section == 0 {
			return 44
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if section != 0 {
			return nil
		}
		
		let blankView = UIView()
		blankView.backgroundColor = UIColor.black
		return blankView
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
			cell.name.text = "Select"
			cell.dot.isHidden = true
			cell.addSwitch.isHidden = true
			cell.allButton.isHidden = false
			cell.noneButton.isHidden = false
			return cell
		}
		
		let currency = currencies[indexPath.row]

		guard let name = currency.name,
			let isHidden =  currency.isHidden,
			let colour = currency.colour else {
				return UITableViewCell()
		}
		
		cell.name.text = name
		cell.addSwitch.isHidden = false
		cell.addSwitch.isOn = !isHidden
		cell.addSwitch.tag = indexPath.row
		cell.dot.backgroundColor = UIColor(hex:colour)
		cell.dot.isHidden = false
		cell.allButton.isHidden = true
		cell.noneButton.isHidden = true
		
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
	
	@IBAction func allButtonPressed(_ button: UIButton) {
		selectAllCells(true)
	}
	
	@IBAction func noneButtonPressed(_ button: UIButton) {
		selectAllCells(false)
	}
	
	func selectAllCells(_ isSelectAll:Bool) {
		for assetCell in tableView.visibleCells {
			guard let cell = assetCell as? AssetCell else { return }
			cell.addSwitch.setOn(isSelectAll, animated: true)
		}
		
		for currency in currencies {
			currency.isHidden = !isSelectAll
		}
		Currency.save()
		Currency.loadCurrencies()
		currencies = Currency.currencies
	}
}
