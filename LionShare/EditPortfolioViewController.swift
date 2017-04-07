
import UIKit

class EditPortfolioViewController: PortfolioViewController,
								   UITableViewDataSource,
								   UITableViewDelegate,
								   UITextFieldDelegate {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var totalAmountLabel: UILabel!
	@IBOutlet weak var zeroStateView: UIView!
	
	var textFieldInUse: UITextField?
//	let numberToolbar = UIToolbar()

	override func viewDidLoad() {
		super.viewDidLoad()
	
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		tableView.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
		
		edgesForExtendedLayout = UIRectEdge()
		
		UIBarButtonItem.appearance().tintColor = UIColor(red: 254/255 , green: 115/255, blue: 0, alpha: 1)
		
//		numberToolbar.barStyle = UIBarStyle.blackTranslucent
//		numberToolbar.items = [
//			UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
//			UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addAmount))
//		]
//		
//		numberToolbar.sizeToFit()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		totalAmountLabel.text = Portfolio.shared.totalNative
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		NotificationCenter.default.removeObserver(self)
	}
	
	func keyboardWillShow(notification:NSNotification){
		var userInfo = notification.userInfo!
		var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		keyboardFrame = self.view.convert(keyboardFrame, from: nil)
		
		var contentInset = tableView.contentInset
		contentInset.bottom = keyboardFrame.size.height - 50
		tableView.contentInset = contentInset
	}
	
	func keyboardWillHide(notification:NSNotification) {
		tableView.contentInset = UIEdgeInsets.zero
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return currencies.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell") as? CurrencyCell else {
			return UITableViewCell()
		}
		
		let currency = currencies[indexPath.row]
		
		guard let name = currency.name,
			let colour = currency.colour else {
				return UITableViewCell()
		}
		
		if let amount = currency.portfolioAmount {
			cell.textField.text = "\(amount)"
		}
		
		cell.name.text = name
		cell.textField.delegate = self
		cell.textField.tag = indexPath.row
		
		cell.dot.backgroundColor = UIColor(hex:colour)
		cell.symbol.text = currency.symbol
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		
		saveAmountFrom(textField: textField)
		
		textFieldInUse = nil
		
		tableView.reloadData()
	}
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
		textFieldInUse = textField
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func saveAmountFrom(textField: UITextField) {
		
		let currency = currencies[textField.tag]
		
		if let amountText = textField.text,
			let amount = Double(amountText) {
			currency.portfolioAmount = amount
		}
		
		Currency.save()
	}
	
	func addAmount() {
		if let textField = textFieldInUse {
			saveAmountFrom(textField: textField)
			textField.resignFirstResponder()
		}
	}
	
	@IBAction func savePressed(_ sender: Any) {
		if let textField = textFieldInUse {
			saveAmountFrom(textField: textField)
		}
		
		Portfolio.shared.update()
		totalAmountLabel.text = Portfolio.shared.totalNative
		
		self.performSegue(withIdentifier: "edit_to_show", sender: self)
	}
	
	@IBAction func zeroStateButtonPressed(_ sender: Any) {
	
		UIView.animate(withDuration: 0.7, animations: { 
			self.zeroStateView.alpha = 0
		}) { (finished) in
			self.zeroStateView.removeFromSuperview()
			UserDefaults.standard.set(true, forKey: "firstRun")
			UserDefaults.standard.synchronize()
		}
	}
}
