
import UIKit

class SettingsViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBarItem = UITabBarItem(title: "Settings", image: nil, selectedImage: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	override var prefersStatusBarHidden: Bool { get { return true } }
}

