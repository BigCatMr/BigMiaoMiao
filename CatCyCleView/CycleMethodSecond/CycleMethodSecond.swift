//
//  CycleMethodSecond.swift
//  CatCyCleView
//
//  Created by sinoservices on 2017/5/22.
//  Copyright © 2017年 sinoservices. All rights reserved.
//

import UIKit

private let kCycleCellID = "CycleViewCell"

class CycleMethodSecond: UIView {
    // MARK: 定义属性
    var cycleTimer : Timer?
    var cycleArray : [String]? {
        didSet {
            // 1.刷新collectionView
            collectionView.reloadData()
            
            // 2.设置pageControl个数
            pageControl.numberOfPages = cycleArray?.count ?? 0
            
//            // 3.默认滚动到中间某一个位置
//            let indexPath = IndexPath(item: (cycleArray?.count ?? 0) * 5000, section: 0)
//            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            // 4.添加定时器
            removeCycleTimer()
            addCycleTimer()
        }
    }

    // MARK: 控件属性
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    // MARK: 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置该控件不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
        collectionView.delegate = self
        collectionView.dataSource = self
        // 注册Cell
        collectionView.register(UINib(nibName: "CycleViewCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置collectionView的layout
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
    }

}
// MARK:- 提供一个快速创建View的类方法
extension CycleMethodSecond {
    class func recommendCycleView() -> CycleMethodSecond {
        return Bundle.main.loadNibNamed("CycleMethodSecond", owner: nil, options: nil)?.first as! CycleMethodSecond
    }
}


// MARK:- 遵守UICollectionView的数据源协议
extension CycleMethodSecond : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (cycleArray?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CycleViewCell
        let imageName = cycleArray?[indexPath.row % (cycleArray?.count)!]
        cell.cycleViewImage.image = UIImage(named: imageName!)
        return cell
    }
}


// MARK:- 遵守UICollectionView的代理协议
extension CycleMethodSecond : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x
        // 2.计算pageControl的currentIndex
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleArray?.count ?? 1)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addCycleTimer()
    }
}

// MARK:- 对定时器的操作方法
extension CycleMethodSecond {
    fileprivate func addCycleTimer() {
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func removeCycleTimer() {
        cycleTimer?.invalidate() // 从运行循环中移除
        cycleTimer = nil
    }
    
    @objc fileprivate func scrollToNext() {
        // 1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        // 2.滚动该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
