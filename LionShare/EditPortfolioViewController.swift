
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
		
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBarItem = UITabBarItem(title: "Portfolio", image: nil, selectedImage: nil)
		
		tableView.backgroundColor = UIColor.black
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
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
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
