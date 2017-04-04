import UIKit

class SettingsViewController: UIViewController {
	
	@IBOutlet weak var timeSegmentedControl: UISegmentedControl!
	
	@IBAction func timeSegmentedControlAction(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			Client.shared.timePeriod = .day
		case 1:
			Client.shared.timePeriod = .week
		case 2:
			Client.shared.timePeriod = .month
		default:
			break
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBarItem = UITabBarItem(title: "Settings", image: nil, selectedImage: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override var prefersStatusBarHidden: Bool { get { return true } }
}
