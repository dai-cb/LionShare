
import UIKit

class DisplayPortfolioViewController: UIViewController {
	
	@IBAction func editPressed(_ sender: Any) {
		performSegue(withIdentifier: "show_to_edit", sender: self)
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override var prefersStatusBarHidden: Bool {
		get {
			return true
		}
	}
}

