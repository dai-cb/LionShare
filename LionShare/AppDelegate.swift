import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		Fabric.with([Crashlytics.self])
		
		UIApplication.shared.statusBarStyle = .lightContent
		
		let attr = NSDictionary(object: UIFont(name: "SFMono-Regular", size: 13.0)!, forKey: NSFontAttributeName as NSCopying)
		UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
		
		return true
	}
}
