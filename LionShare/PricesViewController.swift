
import UIKit

class PricesViewController: UIViewController,
							UITableViewDataSource,
							UITableViewDelegate {

	@IBOutlet weak var tableView: UITableView!
	
	var prices: [Price]?
	
	let colours = ["BTC": 0xFF7300,
	               "ETH": 0x8C01FF,
	               "LTC": 0xB4B4B4,
	               "REP": 0xEC3766,
	               "ZEC": 0xF0AD4E,
	               "LSK": 0x38E6B2,
	               "XMR": 0xCF4900,
	               "ETC": 0x4FB858,
	               "XRP": 0x27A2DB,
	               "DASH": 0x1E73BE,
	               "STR": 0x08B5E5,
	               "MAID": 0x5592D7,
	               "FCT": 0x417BA4,
	               "XEM": 0xFABE00,
	               "STEEM": 0x4BA2F2,
	               "DOGE": 0xF2A51F,
	               "SDC": 0xE2213D,
	               "BTS": 0x00A9E0,
	               "GAME": 0x7CBF3F,
	               "ARDR": 0x1162A1,
	               "DCR": 0x47ACD7,
	               "SJCX": 0x0014FF,
	               "SC": 0x009688,
	               "IOS": 0x84D0F4]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBarItem = UITabBarItem(title: "Prices", image: nil, selectedImage: nil)
		
		tableView.backgroundColor = UIColor.black
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		fetchPrices()
	}
	
	fileprivate func fetchPrices() {
		
		// fetch timerange
		
		let request = URLRequest(url: URL(string: "https://api.lionshare.capital/api/prices?period=day")!)
		Client.shared.getPrices(request: request) { (prices) in
			
			if let prices = prices {
				self.prices = prices
			}
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		guard let prices = prices else {
			return 0
		}
		
		return prices.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell") as? PriceCell else {
			return UITableViewCell()
		}
		
		guard let prices = prices else {
			return UITableViewCell()
		}
		
		let price = prices[indexPath.row]
		
		cell.currencyCode.text = price.id
		
		print(price.difference())
		
		if let prices = price.prices,
			let price = prices.last {
			cell.price.text = "\(price)"
		}
		
		for colour in colours {
			if colour.key == price.id {
				cell.price.textColor = UIColor(netHex:colour.value)
			}
		}
		
		cell.difference.text = price.difference()
		
		// handle random colour if no colour set
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = UIColor.black
	}
	
	override var prefersStatusBarHidden: Bool {
		get {
			return true
		}
	}
}


extension UIColor {
	convenience init(red: Int, green: Int, blue: Int) {
		assert(red >= 0 && red <= 255, "Invalid red component")
		assert(green >= 0 && green <= 255, "Invalid green component")
		assert(blue >= 0 && blue <= 255, "Invalid blue component")
		
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
	}
	
	convenience init(netHex:Int) {
		self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
	}
}
