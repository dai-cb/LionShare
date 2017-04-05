import UIKit
import Foundation

protocol ChartsViewDatasource {
	func chart(_ chart: ChartView, valueForPoint index: Int) -> CGFloat
}

@IBDesignable class ChartView: UIView {
	
	var prices: [Double] = [] {
		didSet {
			reloadData()
		}
	}
	
	fileprivate var graphSize = CGSize.zero
	fileprivate var maxAmount: CGFloat = 0
	fileprivate var minAmount: CGFloat = 0
	fileprivate var yAxisValues: [CGFloat] = []
	fileprivate var xAxisValues: [CGFloat] = []
	fileprivate var lineLayer = CAShapeLayer()
	fileprivate var zeroStateLinePath = UIBezierPath()
	var lineColour = UIColor.white
	
	func reloadData() {
		guard prices.count > 0 else {
			return
		}
		
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
