//
//  ViewController.swift
//  CatCyCleView
//
//  Created by sinoservices on 2017/5/22.
//  Copyright © 2017年 sinoservices. All rights reserved.
//

import UIKit
let kCycleH : CGFloat   =  190

class ViewController: UIViewController , CycleViewDelegate {
    //懒加载
   lazy var cycleView : CycleMethodOne = { [weak self] in
        let cycleView = CycleMethodOne(frame: CGRect(x: 0, y: 64, width: kCycleW, height: kCycleH))
        cycleView.delegate = self
        return cycleView
    }()
    var dataArray : Array<Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataArray = ["0","1","2","03","4"]
        self.view.addSubview(cycleView)
    }

    func cycleViewCountInCycle( _ cycleView : CycleMethodOne) -> Array<Any>{
        return dataArray!
    }
}

