import Foundation

class Client: NSObject {
	
	static let shared = Client()
	
	enum TimePeriod: String {
		case day, week, month
	}
	
	let errorApi = NSError(domain: "LionShare", code: 400, userInfo: nil)
	var timePeriod: TimePeriod = .day
	
	func getPrices(callback: @escaping ([Price]?, NSError?) -> Void) {
		
		let request = URLRequest(url: URL(string: "https://api.lionshare.capital/api/prices?period=\(timePeriod)")!)
		
		httpGet(request: request) { (response, error) -> Void in
			if let error = error {
				callback(nil, error)
				return
			}
			
			guard let result = response as? [String: AnyObject],
				let data = result["data"] as? [String: AnyObject] else {
				callback(nil, self.errorApi)
				return
			}
		
			var prices: [Price] = []
			for aPrice in data {
				
				let price = Price()
				price.id = aPrice.key

				if let values = aPrice.value as? [Double] {
					price.prices = values
				}
				
				prices.append(price)
			}
			callback(prices, nil)
		}
	}
	
	func httpGet(request: URLRequest!, callback: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
		let session = URLSession.shared
		let task = session.dataTask(with: request){ (data, response, error) -> Void in
			if error != nil {
				callback(nil, error as NSError?)
				return
			}
			
			guard let data = data else {
				callback(nil, self.errorApi)
				return
			}
				
			if data.isEmpty {
				callback(nil, self.errorApi)
			}
			do {
				let object:Any? = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				callback(object as AnyObject?, nil)
			} catch let caught {
				callback(nil, caught as NSError?)
			}
		}
		task.resume()
	}
}
