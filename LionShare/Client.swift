import Foundation

class Client: NSObject {
	
	static let shared = Client()
	
	enum TimePeriod: String {
		case day, week, month
	}
	
	var timePeriod: TimePeriod = .day
	
	func getPrices(callback: @escaping ([Price]?) -> Void) {
		
		let request = URLRequest(url: URL(string: "https://api.lionshare.capital/api/prices?period=\(timePeriod)")!)
		
		httpGet(request: request) { (response, error) -> Void in
			if error != nil {
				print(error!)
				return
			}
			
			guard let result = response as? [String: AnyObject],
				let data = result["data"] as? [String: AnyObject] else {
				//TODO: Add errors
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
			callback(prices)
		}
	}
	
	func httpGet(request: URLRequest!, callback: @escaping (_ response: AnyObject?, _ error: Error?) -> Void) {
		let session = URLSession.shared
		let task = session.dataTask(with: request){
			(data, response, error) -> Void in
			if error != nil {
				callback(nil, error)
				return
			}
			
			let error = NSError(domain: "LionShare", code: 400, userInfo: nil)
			
			guard let data = data else {
				callback(nil, error)
				return
			}
				
			if data.isEmpty {
				callback(nil, error)
			}
			do {
				let object:Any? = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
				callback(object as AnyObject?, nil)
			} catch let caught {
				callback(nil, caught)
			}
		}
		task.resume()
	}
}
