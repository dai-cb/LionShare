
import UIKit

class PortfolioViewController: UIViewController {
	
	let currencies = Currency.currencies
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBarItem = UITabBarItem(title: "Portfolio", image: nil, selectedImage: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		performSegue(withIdentifier: "segue_edit", sender: self)
	}
	
	override var prefersStatusBarHidden: Bool {
		get {
			return true
		}
	}
}

