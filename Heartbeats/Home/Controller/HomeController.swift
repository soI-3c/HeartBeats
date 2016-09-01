//
//  DynamicController.swift
//  Heartbeats
//
//  Created by iOS-3C on 15/11/15.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit
let HBHomeCellID = "HBHomeCellID"
/* 首页 */
class HomeController: UICollectionViewController {
    
//    MARK: -- getter/ setter
    // 数据源
    var users: [HeartUser]? {
        didSet {
            collectionView?.reloadData()
        }
    }
    var isPresented: Bool = false               //  判断是presented 还是diss

    let backImageView: UIImageView = {          // 背景图, 毛玻璃
        let imgView = UIImageView()
        imgView.image = placeholderImage
        return imgView
    }()
    
//    MARK: -- override
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundView = backImageView
        Tools.insertBlurView(backImageView, style: .ExtraLight)

        // 注册可重用 cell
        collectionView?.registerClass(PublicDynamicCell.self, forCellWithReuseIdentifier: HBHomeCellID)
        loadData()
        prepareLayout()
    }
    
    // 实现 init() 构造函数，方便外部的代码调用，不需要额外指定布局属性
    init() {
        // 调用父类的默认构造函数
        super.init(collectionViewLayout: DWFlowLayout())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
//    MARK: -- private func
    func loadData() {
        NetworkTools.loadUsers { (result, error) -> () in
            if error == nil {
                self.users = result as? [HeartUser]
            }else {
                print(error)
            }
        }
    }
    /// 1. 准备布局
    private func prepareLayout() {
        // 获得当前的布局属性
        let layout = collectionView?.collectionViewLayout as! DWFlowLayout
        layout.itemSize = CGSize(width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.7)
          collectionView?.showsHorizontalScrollIndicator = false
    }
    
    // MARK: -- DataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HBHomeCellID, forIndexPath: indexPath) as! PublicDynamicCell
//        图片浏览器
        cell.tapBackImageBlock = {(image) -> Void in
            let photoBrowControl =  PhotoBrowserViewController()
            photoBrowControl.showImage = image
            // 自定义`转场` transitioning
            // 默认的专场完成之后，之前的view会被移出屏幕
            // 1. 指定代理
            photoBrowControl.transitioningDelegate = self
            // 2. 指定Modal转场模式 － 自定义
            photoBrowControl.modalPresentationStyle = UIModalPresentationStyle.Custom
            self.presentViewController(photoBrowControl, animated: true, completion: nil)
        }
        cell.delegate = self
        cell.user = nil
        cell.user = users?[indexPath.row]
        cell.backgroundColor = UIColor.whiteColor()
        return cell
    }
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
           let meCenterControl =  MeCenterController()
             meCenterControl.user = users![indexPath.item]
        navigationController?.pushViewController(meCenterControl, animated: true)
    }
}



// MARK: -- PublicDynamicCellDelegate
extension HomeController: PublicDynamicCellDelegate {
    func publicDynamicCell(cell: PublicDynamicCell, converse user: HeartUser) {
    }
    func publicDynamicCell(cell: PublicDynamicCell, giveHeart user: HeartUser) {
    }
}

// MARK: -- 转场动画
extension HomeController: UIViewControllerTransitioningDelegate {
    /// 返回提供展现 present 转场动画的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    /// 返回提供解除 dismiss 转场动画的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}
extension HomeController: UIViewControllerAnimatedTransitioning {
    /// 返回专场动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.25
    }
    /// 专门实现转场动画效果 - 一旦实现了此方法，必须完成动画效果
    /// - parameter transitionContext: transition[转场]Context[上下文] 提供了转场动画所需的一切细节
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        _ = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        _ = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        isPresented ? presentAnim(transitionContext) : dismissAnim(transitionContext)
    }
    /// 实现解除专场动画
    /// - parameter transitionContext: 上下文
    private func dismissAnim(transitionContext: UIViewControllerContextTransitioning) {
        // 拿到被展现的视图 - fromView
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        UIView .animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            fromView.alpha = 0
            }, completion: { (_) -> Void in
                // 将视图从容器视图中删除
                fromView.removeFromSuperview()
                // 动画完成
                transitionContext.completeTransition(true)
        })
    }

    /// 实现 Modal 展现动画
    ///
    /// - parameter transitionContext: 上下文
    private func presentAnim(transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        // 2. 用 sdwebImage 异步下载图像
        /**
        sd_setImageWithURL
        1> 如果图片已经被缓存，不会再次下载
        2> 如果要跟进进度，都是`异步`回调
        原因：
        a) 一般程序不会跟踪进度
        b) 进度回调的频率相对较高
        异步回调，能够降低对主线程的压力
        */
        toView.alpha = 0.0
        // 3. 图像下载完成之后，再显示动画
            UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
                toView.alpha = 1.0
                // 将目标视图添加到容器视图
                transitionContext.containerView()?.addSubview(toView)
                // 声明动画完成
                transitionContext.completeTransition(true)
            }, completion: { (_) -> Void in
               
            })
        }
}


