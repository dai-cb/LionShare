
import Foundation

class CurrencyFormatterOptions: NSObject {
	var addCurrencySymbol = true
	var showPositivePrefix = false
	var showNegativePrefix = true
	var locale: NSLocale? = nil
	var allowTruncation = false
}

class CurrencyFormatter: NSObject {
	
	static let sharedInstance = CurrencyFormatter()
	
	let formatter = NumberFormatter()
	let stringFromNumberFormatter = NumberFormatter()
	let truncatingFormatter = NumberFormatter()
	let percentFormatter = NumberFormatter()
	
	let currencies = [
		"USD": "$",
		"EUR": "€",
		"JPY": "¥",
		"GBP": "₤",
		"CAD": "$",
		"KRW": "₩",
		"CNY": "¥",
		"AUD": "$",
		"BRL": "R$",
		"IDR": "Rp",
		"MXN": "$",
		"SGD": "$",
		"CHF": "Fr."
	]
	
	override init() {
		
		// Setup non standard formatters
		truncatingFormatter.usesSignificantDigits = true
		truncatingFormatter.maximumSignificantDigits = 5
		truncatingFormatter.minimumSignificantDigits = 0
		truncatingFormatter.maximumFractionDigits = 8
		truncatingFormatter.minimumFractionDigits = 2
		truncatingFormatter.locale = nil
		truncatingFormatter.minimumIntegerDigits = 1
		
		stringFromNumberFormatter.locale = Locale(identifier: "en_US")
		stringFromNumberFormatter.minimumIntegerDigits = 1
		stringFromNumberFormatter.maximumFractionDigits = 8
		
		percentFormatter.minimumIntegerDigits = 1
		percentFormatter.maximumFractionDigits = 2
	}
	
	func stringFromNumber(amount: Double) -> String {
		return stringFromNumberFormatter.string(from: NSNumber(value: amount))!
	}
	
	func formatAmountString(amount: String,
	                        currency: String,
	                        options: CurrencyFormatterOptions? = nil) -> String {
		return formatAmount(amount: (amount as NSString).doubleValue, currency: currency, options: options)
	}
	
	func formatAmount(amount: Double,
	                  currency: String,
	                  options: CurrencyFormatterOptions? = nil) -> String {
		
		var formatOptions = CurrencyFormatterOptions()
		
		if let options = options {
			formatOptions = options
		}
		
		let amount = amount
		let currency = currency
		
		if let locale = formatOptions.locale {
			formatter.locale = locale as Locale!
			formatter.usesGroupingSeparator = true
		} else {
			formatter.locale = Locale(identifier: "en_US")
		}
		
		formatter.minimumIntegerDigits = 1
		formatter.maximumFractionDigits = 8
		
		// TODO: Fix currency hack
		if currency == "USD" {
			formatter.maximumFractionDigits = 2
		}
		
		formatter.minimumFractionDigits = 2
		
		if formatOptions.allowTruncation == true {
			return formatTruncating(amount: amount, currency: currency, options: formatOptions)
		}
		
		return formatSymbolAndPrefix(amount: amount, currency: currency, numFormatter: formatter, options: formatOptions)
	}
	
	private func formatTruncating(amount: Double,
	                              currency: String,
	                              options: CurrencyFormatterOptions) -> String {
		
		formatter.currencySymbol = ""
		
		let tempOutput = formatter.string(from: NSNumber(value: amount))!
		let dotIndex = tempOutput.range(of: ".")?.lowerBound
		let currentNumberOfFractionDigits = dotIndex == nil ? 0 : (tempOutput.substring(from: dotIndex!).characters.count - 1)
		
		if options.allowTruncation && (currentNumberOfFractionDigits > 2) {
			return formatSymbolAndPrefix(amount: amount, currency: currency, numFormatter: truncatingFormatter, options: options)
		}
		
		return formatSymbolAndPrefix(amount: amount, currency: currency, numFormatter: formatter, options: options)
	}
	
	private func formatSymbolAndPrefix(amount: Double,
	                                   currency: String,
	                                   numFormatter: NumberFormatter, options: CurrencyFormatterOptions) -> String {
		var output = ""
		output = formatSymbol(amount: amount, currency: currency, numFormatter: numFormatter, options: options)
		output = formatPrefix(amount: amount, output: output, options: options)
		return output
	}
	
	private func formatSymbol(amount: Double,
	                          currency: String,
	                          numFormatter: NumberFormatter,
	                          options: CurrencyFormatterOptions) -> String {
		var output = ""
		if options.addCurrencySymbol {
			if let currencyCode = currencies[currency] {
				numFormatter.numberStyle = .currency
				numFormatter.currencySymbol = currencyCode
				output = numFormatter.string(from: NSNumber(value: amount))!
			} else {
				if currency.characters.count > 0 {
					numFormatter.numberStyle = .decimal
					output = "\(numFormatter.string(from: NSNumber(value: amount))!) \(currency)"
				} else {
					numFormatter.numberStyle = .decimal
					output = "\(numFormatter.string(from: NSNumber(value: amount))!)"
				}
			}
		} else {
			numFormatter.numberStyle = .decimal
			output = numFormatter.string(from: NSNumber(value: amount))!
		}
		return output
	}
	
	fileprivate func formatPrefix(amount: Double,
	                              output: String,
	                              options: CurrencyFormatterOptions) -> String {
		var formattedOutput = output
		if options.showPositivePrefix && amount > 0 {
			formattedOutput = formatter.plusSign + formattedOutput
		}
		if options.showNegativePrefix == false && amount < 0 {
			formattedOutput = formattedOutput
				.substring(from: formattedOutput.characters.index(formattedOutput.startIndex, offsetBy: 1))
		}
		return formattedOutput
	}
}
