import Foundation
import UIKit

class TabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let vcs = self.viewControllers else { return }
		
		// Remove tabBarItem titles and adjust icons accordingly
		for vc in vcs {
			vc.tabBarItem.title = nil
			vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
		}
	}
}
