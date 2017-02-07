import Foundation

class Client: NSObject {
	
	static let shared = Client()
	
//	func getPrice(request: NSMutableURLRequest, callback: (String?) -> Void) {
//		httpGet(request){
//			(response, error) -> Void in
//			if error != nil {
//				print(error)
//			} else {
//				if error != nil {
//					// ignore
//				} else {
//					guard let result = response as? [String: AnyObject] else {
//						// ignore
//						return
//					}
//					guard let price = result["price"] as? String else {
//						// ignore
//						return
//					}
//					callback(price)
//				}
//			}
//		}
//	}
//	
//	func getStats(request: NSMutableURLRequest, callback: (open: String?, volume: String?) -> Void) {
//		httpGet(request){
//			(response, error) -> Void in
//			if error != nil {
//				print(error)
//			} else {
//				if error != nil {
//					// ignore
//				} else {
//					guard let result = response as? [String: AnyObject] else {
//						// ignore
//						return
//					}
//					guard let open = result["open"] as? String else {
//						// ignore
//						return
//					}
//					guard let volume = result["volume"] as? String else {
//						// ignore
//						return
//					}
//					callback(open: open, volume: volume)
//				}
//			}
//		}
//	}
//	
	func getPrices(request: URLRequest , callback: @escaping ([Price]?) -> Void) {
		httpGet(request: request) { (response, error) -> Void in
			if error != nil {
				print(error!)
				return
			}
			
			guard let result = response as? [String: AnyObject] else {
				// ignore
				return
			}
			
			guard let data = result["data"] as? [String: AnyObject] else {
				// ignore
				return
			}
						
			var prices: [Price] = []
			for aPrice in data {
				
				let price = Price()
				price.id = aPrice.key
				
				//print(aPrice.value)
				
//				for p in aPrice.value as! Array<String> {
//					print(p)
//				}
				
				
//				for p in aPrice.value {
//					price.prices
//				}
				
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
