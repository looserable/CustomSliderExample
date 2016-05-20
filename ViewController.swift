//
//  ViewController.swift
//  CustomSliderExample
//
//  Created by john on 16/5/20.
//  Copyright © 2016年 jhon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let rangeSlider = RangeSlider(frame: CGRectZero)

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.addSubview(rangeSlider)
        
        rangeSlider.addTarget(self, action: #selector(rangeSliderValueChanged(_:)), forControlEvents: .ValueChanged)
    }
    
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        print("Range slider value changed: (\(rangeSlider.lowerValue) \(rangeSlider.upperValue))")
    }
    
    override func viewDidLayoutSubviews() {
        let margin:CGFloat = 20.0
        let width:CGFloat = self.view.bounds.width - 2.0 * margin
        
        rangeSlider.frame = CGRectMake(margin, margin + topLayoutGuide.length, width, 31)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

