import Foundation

class Currency: NSObject, NSCoding {
	
	static var currencies = [
		
		Currency(name: "Bitcoin", symbol: "BTC", colour: 0xFF7300),
		Currency(name: "Ethereum", symbol: "ETH", colour: 0x8C01FF),
		Currency(name: "Litecoin", symbol: "LTC", colour: 0xB4B4B4),
		Currency(name: "Augur", symbol: "REP", colour: 0xEC3766),
		Currency(name: "ZCash", symbol: "ZEC", colour: 0xF0AD4E),
		Currency(name: "Lisk", symbol: "LSK", colour: 0x38E6B2),
		Currency(name: "Monero", symbol: "XMR", colour: 0xCF4900),
		Currency(name: "Ethereum Classic", symbol: "ETC", colour: 0x4FB858),
		Currency(name: "Ripple", symbol: "XRP", colour: 0x27A2DB),
		Currency(name: "Dash", symbol: "DASH", colour: 0x1E73BE),
		Currency(name: "Stellar", symbol: "STR", colour: 0x08B5E5),
		Currency(name: "MaidSafeCoin", symbol: "MAID", colour: 0x5592D7),
		Currency(name: "Factom", symbol: "FCT", colour: 0x417BA4),
		Currency(name: "NEM", symbol: "XEM", colour: 0xFABE00),
		Currency(name: "Steem", symbol: "STEEM", colour: 0x4BA2F2),
		Currency(name: "Dogecoin", symbol: "DOGE", colour: 0xF2A51F),
		Currency(name: "ShadowCash", symbol: "SDC", colour: 0xE2213D),
		Currency(name: "BitShares", symbol: "BTS", colour: 0x00A9E0),
		Currency(name: "GameCredits", symbol: "GAME", colour: 0x7CBF3F),
		Currency(name: "Ardor", symbol: "ARDR", colour: 0x1162A1),
		Currency(name: "Decred", symbol: "DCR", colour: 0x47ACD7),
		Currency(name: "Storjcoin X", symbol: "SJCX", colour: 0x0014FF),
		Currency(name: "Siacoin", symbol: "SC", colour: 0x009688),
		Currency(name: "I/O Coin", symbol: "IOC", colour: 0x84D0F4)
	]
	
	static var displayCurrencies: [Currency] {
		get {
			var temp = [Currency]()
			for currency in Currency.currencies {
				if currency.display == true {
					temp.append(currency)
				}
			}
			return temp
		}
	}
	
	static var savedCurrencies = [Currency]()
	
	var name: String?
	var symbol: String?
	var colour: Int?
	var price: Price?
	var amount: Double?
	var display: Bool!
	
	override init() {
		super.init()
	}

	public convenience init(name: String,
	                        symbol: String,
	                        colour: Int,
	                        amount: Double? = 0.0,
	                        display: Bool = true) {
		self.init()
		
		self.name = name
		self.symbol = symbol
		self.colour = colour
		self.amount = amount
		self.display = display
	}
	
	required public init(coder aDecoder: NSCoder) {

		name = aDecoder.decodeObject(forKey: "name") as! String?
		symbol = aDecoder.decodeObject(forKey: "symbol") as! String?
		colour = aDecoder.decodeObject(forKey: "colour") as! Int?
		amount = aDecoder.decodeObject(forKey: "amount") as! Double?
		display = aDecoder.decodeObject(forKey: "display") as! Bool!
		
		super.init()
	}
	
	func encode(with aCoder: NSCoder) {
		
		aCoder.encode(name, forKey: "name")
		aCoder.encode(symbol, forKey: "symbol")
		aCoder.encode(colour, forKey: "colour")
		aCoder.encode(amount, forKey: "amount")
		aCoder.encode(display, forKey: "display")
	}
	
	static func save() {
		let data  = NSKeyedArchiver.archivedData(withRootObject: Currency.currencies)
		let defaults = UserDefaults.standard
		defaults.set(data, forKey:"currencies" )
	}
	
	static func loadCurrencies() {
		if let data = UserDefaults.standard.object(forKey: "currencies") as? Data {
			let savedCurrencies = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Currency]
			print("custom = \(savedCurrencies)")
			
			for c in savedCurrencies {
				print("c = \(c.name!)")
				print("c = \(c.amount!)")
			}
			
			//Currency.currencies = savedCurrencies
		}
	}
}