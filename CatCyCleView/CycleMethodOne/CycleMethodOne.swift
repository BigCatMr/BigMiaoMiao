//
//  CycleMethodOne.swift
//  CatCyCleView
//
//  Created by sinoservices on 2017/5/22.
//  Copyright © 2017年 sinoservices. All rights reserved.
//

import UIKit
let kCycleW = UIScreen.main.bounds.width //屏幕的宽
fileprivate let kCycleIdentifier  = "CycleViewCell"
protocol CycleViewDelegate : class {
    func cycleViewCountInCycle( _ cycleView : CycleMethodOne) -> Array<Any>
}

class CycleMethodOne: UIView {

   fileprivate var cyCleCollection : UICollectionView?
   fileprivate var cyTimer : Timer?
   fileprivate var cyPageControl : UIPageControl?
   fileprivate var cyDataArray : Array<Any>?
    weak var delegate : CycleViewDelegate? {
        didSet{
            cyDataArray = self.delegate?.cycleViewCountInCycle(self)
            setCycleView()

        }
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置视图不随父视图控件的大小变化而改变
        self.autoresizingMask = UIViewAutoresizing()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        cyTimer?.invalidate()
        cyTimer = nil
    }
}
//设置界面的方法
extension CycleMethodOne {
   fileprivate func setCycleView()  {
        //设置Collection的界面属性
        let cycleH = self.bounds.size.height //轮播图的高
        let cyLayout = UICollectionViewFlowLayout()
        cyLayout.scrollDirection         = .horizontal
        cyLayout.minimumLineSpacing      = 0
        cyLayout.minimumInteritemSpacing = 0
        cyLayout.itemSize                = CGSize(width: kCycleW, height: cycleH)
        let cyClecollRect = CGRect(x: 0, y: 0, width: kCycleW, height: cycleH)
        cyCleCollection                  = UICollectionView(frame:cyClecollRect , collectionViewLayout: cyLayout)
        cyCleCollection?.showsHorizontalScrollIndicator = false
        cyCleCollection?.isPagingEnabled  = true
        cyCleCollection?.delegate         = self
        cyCleCollection?.dataSource       = self
        cyCleCollection?.register(UINib(nibName: "CycleViewCell", bundle: nil), forCellWithReuseIdentifier: kCycleIdentifier)
        addSubview(cyCleCollection!)
    //设置cyPageControl
        let pageFrame = CGRect(x: kCycleW - 200, y: cycleH - 20, width: 150, height: 20)
        cyPageControl                    = UIPageControl(frame: pageFrame)
        cyPageControl?.center.x          = kCycleW/2
        cyPageControl?.numberOfPages     = cyDataArray?.count ?? 0
        cyPageControl?.currentPage       = 0
        cyPageControl?.currentPageIndicatorTintColor = UIColor.red
        cyPageControl?.pageIndicatorTintColor        = UIColor.purple
        addSubview(cyPageControl!)
        addTimer()
        if (cyDataArray != nil) {
            let indexPath = IndexPath(item: (cyDataArray?.count)! * 5000, section: 0)
            cyCleCollection?.scrollToItem(at: indexPath, at: .left, animated: false)
         }
        
    }
}
//定时器的方法
extension CycleMethodOne {
    func addTimer()  {
        if cyTimer == nil {
            cyTimer = Timer(timeInterval: 2, repeats: true, block: { (timer) in
                let currentOffserX = self.cyCleCollection?.contentOffset.x
                self.cyCleCollection?.setContentOffset(CGPoint(x: currentOffserX! + kCycleW, y: 0), animated: true)
            })
            CFRunLoopAddTimer(CFRunLoopGetMain(), cyTimer, CFRunLoopMode.commonModes)
          //  CFRunLoopAddTimer(CFRunLoopGetCurrent(), cyTimer, CFRunLoopMode.commonModes) 也可以
        }
    }
    func removeTimer() {
        cyTimer?.invalidate()
        cyTimer = nil
    }
}
//CollectionView 的代理 数据源方法
extension CycleMethodOne : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return (cyDataArray?.count)! * 10000 
    }
  
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cyCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleIdentifier, for: indexPath) as! CycleViewCell
        let imageName = cyDataArray?[indexPath.row % (cyDataArray?.count)!]
        cyCell.cycleViewImage.image = UIImage(named: imageName as! String)
        return cyCell
        
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offSetPage : NSInteger = NSInteger(scrollView.contentOffset.x / kCycleW)
        cyPageControl?.currentPage = offSetPage % (cyDataArray?.count)!

    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        removeTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        addTimer()
    }
    

}





