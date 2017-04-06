import UIKit
import LionShareKit
import Starscream

class PricesViewController: UIViewController,
							UITableViewDataSource,
							UITableViewDelegate,
							WebSocketDelegate {

	@IBOutlet weak var tableView: UITableView!
	
	fileprivate let currencyFormatterOptions = CurrencyFormatterOptions()
	
	fileprivate var displayCurrencies = [Currency]()
	
	let socket = WebSocket(url: URL(string: "wss://lionsharecapital.herokuapp.com/")!)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		socket.delegate = self
		
		tabBarItem.imageInsets = UIEdgeInsets(top: 5.5, left: 0, bottom: -5.5, right: 0)
		tabBarItem.title = nil
		
		tableView.backgroundColor = UIColor.black
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		
		currencyFormatterOptions.allowTruncation = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		Currency.loadCurrencies()
		
		displayCurrencies = Currency.displayCurrencies
		
		fetchPrices {
			self.startSocket()
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		stopSocket()
	}
	
	func startSocket() {
		socket.connect()
	}
	
	func stopSocket() {
		socket.disconnect(forceTimeout: -1)
	}
	
	func websocketDidConnect(socket: WebSocket) {
		print("websocket is connected")
	}
	
	func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
		print("websocket is disconnected: \(String(describing: error?.localizedDescription))")
	}
	
	func websocketDidReceiveMessage(socket: WebSocket, text: String) {
		//print("got some text: \(text)")
		
		guard let latest = convert(text: text),
			let symbol = latest["cryptoCurrency"] as? String,
			let price = latest["price"] as? Double else {
			return
		}
	
		var index:Int?
		for currency in displayCurrencies {
			if symbol == currency.symbol {
				currency.price?.latest = price
				index = displayCurrencies.index(of: currency)
			}
		}
		
		guard let row = index else { return }
		
		let indexPath = IndexPath(row: row, section: 0)
		
		tableView.reloadRows(at: [indexPath], with: .none)
		
		guard let cell = tableView.cellForRow(at: indexPath) as? PriceCell else { return }
		
		hideElements(cell, hide: true)
		
		UIView.animate(withDuration: 0.7) {
			self.hideElements(cell, hide: false)
		}
	}
	
	fileprivate func hideElements(_ cell: PriceCell, hide: Bool) {
		cell.dot.alpha = hide ? 0 : 1
		cell.price.alpha = hide ? 0 : 1
		cell.difference.alpha = hide ? 0 : 1
	}
	
	func convert(text: String) -> [String: Any]? {
		if let data = text.data(using: .utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
			} catch {
				print(error.localizedDescription)
			}
		}
		return nil
	}
	
	func websocketDidReceiveData(socket: WebSocket, data: Data) {
		//ignore.
	}
	
	fileprivate func fetchPrices(callback: @escaping ()  -> Void) {
		Client.shared.getPrices() { (prices, error) in
			defer {
				DispatchQueue.main.async {
					self.tableView.reloadData()
					callback()
				}
			}
			
			if let error = error {
				print("error = \(error)")
				return
			}
			
			guard let prices = prices  else {
				return
			}
			
			for price in prices {
				for currency in Currency.currencies {
					if price.id == currency.symbol {
						currency.price = price
					}
				}
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return displayCurrencies.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "priceCell") as? PriceCell else {
			return UITableViewCell()
		}
		
		let currency = displayCurrencies[indexPath.row]
		
		cell.currencyCode.text = currency.symbol
		
		guard let price = currency.price,
			let prices = price.prices,
			let last = prices.last,
			let colour = currency.colour else {
				return UITableViewCell()
		}
	
		var latest: Double = last
		if let priceLatest = price.latest {
			latest = priceLatest
		}
		
		cell.price.text = CurrencyFormatter.sharedInstance.formatAmount(amount: latest, currency: "USD", options: currencyFormatterOptions)
		
		let (difference, sign) = price.difference()
		
		cell.difference.text = difference
		
		cell.difference.textColor = sign == .plus ? Constants.greenPositiveColour : Constants.redNegativeColour
		
		cell.dot.backgroundColor = UIColor(hex:colour)
		cell.chart.lineColour = UIColor(hex:colour)
		cell.chart.prices = prices
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		cell.backgroundColor = UIColor.black
	}
}
