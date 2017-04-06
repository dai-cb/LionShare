import Foundation
import UIKit

class TabBarController: UITabBarController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for vc in self.viewControllers! {
			vc.tabBarItem.title = nil
			vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
		}
	}
}
