//
//  ViewControllerSecond.swift
//  CatCyCleView
//
//  Created by sinoservices on 2017/5/22.
//  Copyright © 2017年 sinoservices. All rights reserved.
//

import UIKit

class ViewControllerSecond: UIViewController {
    
    fileprivate lazy var cycleView : CycleMethodSecond = {
        let cycleView = CycleMethodSecond.recommendCycleView()
        cycleView.frame = CGRect(x: 0, y: 64, width: kCycleW, height: kCycleH)
        return cycleView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let dataArray = ["0","1","2","03","4"]
        self.view.addSubview(cycleView)
        cycleView.cycleArray = dataArray

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   
}
