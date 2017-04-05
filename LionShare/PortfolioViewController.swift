import UIKit

class PortfolioViewController: UIViewController {
	
	let currencies = Currency.currencies
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBarItem = UITabBarItem(title: "Portfolio", image: nil, selectedImage: nil)
		
		navigationItem.hidesBackButton = true
	}
}

