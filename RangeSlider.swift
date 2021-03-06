//
//  RangeSlider.swift
//  CustomSliderExample
//
//  Created by john on 16/5/20.
//  Copyright © 2016年 jhon. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {
    
    var minValue   = 0.0
    var maxValue   = 1.0
    var lowerValue = 0.2
    var upperValue = 0.8
    
    let trackLayer = RangeSliderTrackLayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    
    var previousLocation = CGPoint()
    
    var trackTintColor = UIColor(white: 0.9, alpha: 1.0)
    var trackHighlightTintColor = UIColor(red: 0.0, green: 0.45, blue: 0.94, alpha: 1.0)
    var thumbTintColor = UIColor.whiteColor()
    
    var curvaceousness : CGFloat = 1.0
    
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.mainScreen().scale
        layer.addSublayer(upperThumbLayer)
    }
    
    
    func updateLayerFrames() {
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        //左边滑块的滑动过的进度条的长度。也是左边滑块的中心点的坐标
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        
        //左边滑块儿的坐标
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        //右边滑块儿的坐标
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
    }
    
    
    func positionForValue(value: Double) -> Double {
        let _ = Double(thumbWidth)
        return Double(bounds.width - thumbWidth) * (value - minValue) /
            (maxValue - minValue) + Double(thumbWidth / 2.0)
    }
    
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    
    //开始拖动的时候会调用这个方法
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent!) -> Bool {
        
        previousLocation = touch.locationInView(self)
        
        // Hit test the thumb layers
        
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    //拖动的过程会调用这个方法
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent!) -> Bool {
        let location = touch.locationInView(self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maxValue - minValue) * deltaLocation / Double(bounds.width - bounds.height)
        
        previousLocation = location
        
        // 2. Update the values
        if lowerThumbLayer.highlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(lowerValue, toLowerValue: minValue, upperValue: upperValue)
        } else if upperThumbLayer.highlighted {
            upperValue += deltaValue
            upperValue = boundValue(upperValue, toLowerValue: lowerValue, upperValue: maxValue)
        }
        
        // 3. Update the UI
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        updateLayerFrames()
        
        CATransaction.commit()
        
        sendActionsForControlEvents(.ValueChanged)
        
        return true
    }
    //拖动结束后会调用这个方法
    override func endTrackingWithTouch(touch: UITouch!, withEvent event: UIEvent!) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }

}
