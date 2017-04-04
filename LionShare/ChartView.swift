import UIKit
import Foundation

protocol ChartsViewDatasource {
	//func numberOfPoints(_ chart: ChartView) -> Int
	func chart(_ chart: ChartView, valueForPoint index: Int) -> CGFloat
}

@IBDesignable class ChartView: UIView {
	
	var prices: [Double] = [] {
		didSet {
			reloadData()
		}
	}
	
	var graphSize = CGSize.zero
	var maxAmount: CGFloat = 0
	var minAmount: CGFloat = 0
	var yAxisValues: [CGFloat] = []
	var xAxisValues: [CGFloat] = []
	var lineLayer = CAShapeLayer()
	var zeroStateLinePath = UIBezierPath()
	var lineColour = UIColor.white
	
//	func numberOfDataPoints() -> Int? {
//		guard let dataSource = prices else {
//			return nil
//		}
//		
//		return dataSource.count
//	}
	
	func reloadData() {
		
		guard prices.count > 0 else {
			return
		}
		
//		if let numDataPoints = prices, numDataPoints <= 0 {
//			//errorLabel.isHidden = false
//		} else {
//			//errorLabel.isHidden = true
//		}
		
		graphSize = CGSize(width: self.frame.size.width, height: self.frame.size.height)
		
		yAxisValues = []
		xAxisValues = []
		
		lineLayer.strokeColor = lineColour.cgColor
		lineLayer.fillColor = UIColor.clear.cgColor
		lineLayer.lineWidth = 2
		self.layer.addSublayer(lineLayer)
		
		populateGraph()
	}
	
	func populateGraph() {
		maxAmount = maximumAmount()
		minAmount = minimumAmount()
		drawPoints()
	}
	
	func drawPoints() {
		for i in 0 ..< prices.count {
			let pointAmount = valueForPointAt(index: i)
			yAxisValues.append(calculateAmountYPosition(pointAmount))
			xAxisValues.append(calculateAmountXPosition(i))
		}
		drawLine()
	}
	
	func valueForPointAt(index: Int) -> CGFloat {
		if index < prices.count {
			return CGFloat(prices[index])
		}
		return 0.0
	}
	
	func drawLine() {
		
		if prices.count > 0 && prices.count == xAxisValues.count && prices.count == yAxisValues.count {
			let graphPath = UIBezierPath()
			
			graphPath.move(to: CGPoint(x:xAxisValues[0], y:yAxisValues[0]))
			
			for i in 0 ..< prices.count {
				var xVal = CGFloat(0)
				var yVal = CGFloat(0)
				if i < xAxisValues.count {
					xVal = xAxisValues[i]
				}
				if i < yAxisValues.count {
					yVal = yAxisValues[i]
				}
				let nextPoint = CGPoint(x:xVal, y:yVal)
				graphPath.addLine(to: nextPoint)
			}
			lineLayer.path = graphPath.cgPath
			
		} else {
			lineLayer.path = nil
		}
		setNeedsDisplay()
	}
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		
//		guard let path = lineLayer.path else {
//			return
//		}
//		
//		guard let numberOfPoints = numberOfDataPoints(), numberOfPoints > 0 else {
//			return
//		}
//		
//		guard let context = UIGraphicsGetCurrentContext() else { return }
//		
//		context.saveGState()
//		UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
//		let imageContext = UIGraphicsGetCurrentContext()
//		
//		let colorSpace = CGColorSpaceCreateDeviceRGB()
//		let colorLocations: [CGFloat] = [0, 1]
//		
////		let blockColors = [UIColor.red.cgColor, UIColor.red.cgColor]
////		let block = CGGradient(colorsSpace: colorSpace, colors: blockColors as CFArray, locations: colorLocations)
////		
////		let blockStartPoint = CGPoint(x:gradientPadding * 2, y:self.bounds.height * 0.5)
////		let blockEndPoint = CGPoint(x:self.bounds.width, y:self.bounds.height * 0.5)
////		imageContext!.drawLinearGradient(block!, start: blockStartPoint, end: blockEndPoint, options: CGGradientDrawingOptions(rawValue: 0))
////		
////		let gradientMaskcolors = [UIColor.clear.cgColor, UIColor.blue.cgColor]
////		let gradientMask = CGGradient(colorsSpace: colorSpace, colors: gradientMaskcolors as CFArray, locations: colorLocations)
////		
////		let gradientMaskStartPoint = CGPoint(x: gradientPadding, y: self.bounds.height * 0.5)
////		let gradientMaskEndPoint = CGPoint(x:gradientPadding * 2, y:self.bounds.height * 0.5)
////		imageContext!.drawLinearGradient(gradientMask!, start: gradientMaskStartPoint, end: gradientMaskEndPoint, options: CGGradientDrawingOptions(rawValue: 0))
//		
//		let mask = UIGraphicsGetCurrentContext()!.makeImage()
//		UIGraphicsEndImageContext()
//		
//		context.clip(to: self.bounds, mask: mask!)
//		
//		let clippingPath = UIBezierPath(cgPath: path)
//		clippingPath.addLine(to: CGPoint(x:xAxisValues[numberOfPoints - 1], y:graphSize.height))
//		clippingPath.addLine(to: CGPoint(x:xAxisValues[0], y:graphSize.height))
//		clippingPath.close()
//		clippingPath.addClip()
//		
////		let colors = [UIColor(white: 1, alpha: 0.4).cgColor, UIColor.clear.cgColor]
////		let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
////		
////		let startPoint = CGPoint.zero
////		let endPoint = CGPoint(x:0, y:self.bounds.height)
////		context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
//		
//		context.restoreGState()
	}
	
	func calculateAmountYPosition (_ pointAmount: CGFloat) -> CGFloat {
		return ((graphSize.height) - ((pointAmount - minAmount) / ((maxAmount - minAmount) / (graphSize.height))))
	}
	
	func calculateAmountXPosition (_ index: Int) -> CGFloat {
		let xAxisPos: CGFloat = (graphSize.width / CGFloat(prices.count - 1)) * CGFloat(index)
		return CGFloat(xAxisPos)
	}
	
	func maximumAmount() -> CGFloat {
		var maxAmount: CGFloat = CGFloat.leastNormalMagnitude
		
		for i in 0 ..< prices.count {
			let pointAmount = valueForPointAt(index: i)
			if pointAmount > maxAmount {
				maxAmount = pointAmount
			}
		}
		return maxAmount
	}
	
	func minimumAmount() -> CGFloat {
		var minAmount: CGFloat = CGFloat.greatestFiniteMagnitude
		
		for i in 0 ..< prices.count {
			let pointAmount = valueForPointAt(index: i)
			if pointAmount < minAmount {
				minAmount = pointAmount
			}
		}
		return minAmount
	}
}
