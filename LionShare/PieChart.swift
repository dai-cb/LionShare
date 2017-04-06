import Foundation
import UIKit

@IBDesignable open class PieChart: UIControl {
	
		public struct Slice {
			public var color: UIColor!
			public var value: CGFloat!
		}
	
		public struct Radius {
			public var inner: CGFloat = 0
			public var outer: CGFloat = 1
		}
	
		var titleLabel: UILabel!
		var subtitleLabel: UILabel!
		var infoLabel: UILabel!
		var total: CGFloat!
	
		open var radius: Radius = Radius()
		open var activeSlice: Int = 0
	
		open var slices: [Slice] = [] {
			didSet {
				total = 0
				for slice in slices {
					total = slice.value + total
				}
				//setNeedsDisplay()
			}
		}
	
		required public init?(coder aDecoder: NSCoder) {
			super.init(coder: aDecoder)
		}
		
		override public init(frame: CGRect) {
			super.init(frame: frame)
			self.backgroundColor = UIColor.black
		}
		
		convenience init() {
			self.init(frame: CGRect.zero)
		}
		
		open override func draw(_ rect: CGRect) {
			super.draw(rect)
			
			radius.inner = bounds.width * 0.5 - 40
			radius.outer = bounds.width * 0.5 - 30
			
			let center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
			var startValue: CGFloat = 0
			var startAngle: CGFloat = 0
			var endValue: CGFloat = 0
			var endAngle: CGFloat = 0
			
			for (_, slice) in slices.enumerated() {
				
				startAngle = (startValue * 2 * CGFloat.pi) - (CGFloat.pi / 2)
				endValue = startValue + (slice.value / self.total)
				endAngle = (endValue * 2 * CGFloat.pi) - (CGFloat.pi / 2)
				
				let path = UIBezierPath()
				path.move(to: center)
				
				// index == activeSlice ? radius.outer + 10 : radius.outer
				
				path.addArc(withCenter: center, radius: radius.outer, startAngle: startAngle, endAngle: endAngle, clockwise: true)
			
				slice.color.setFill()
				path.fill()
			
				startValue += slice.value / self.total
			}
			
			let innerPath = UIBezierPath()
			innerPath.move(to: center)
			innerPath.addArc(withCenter: center, radius: radius.inner, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
			UIColor.black.setFill()
			innerPath.fill()
		}
		
		func animate() {
			activeSlice += 1
			if activeSlice >= slices.count {
				activeSlice = 0
			}
			UIView.animate(withDuration: 0.3) {
				self.setNeedsDisplay()
			}
	}
}
