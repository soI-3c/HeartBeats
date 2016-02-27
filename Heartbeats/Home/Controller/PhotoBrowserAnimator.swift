//
//  PhotoBrowserAnimator.swift
//  Weibo09
//
//  Created by Romeo on 15/9/14.
//  Copyright © 2015年 itheima. All rights reserved.
//

import UIKit
import SDWebImage

/// 专门提供从控制器向照片浏览器的 Modal `转场`动画的对象
class PhotoBrowserAnimator: NSObject, UIViewControllerTransitioningDelegate {
    
    /// 是否展现的标记
    var isPresented = false
    /// 起始位置
    var fromRect = CGRectZero
    /// 目标位置
    var toRect = CGRectZero
    /// 图像视图的 URL
    var url: NSURL?
    /// 动画播放的图像视图
    lazy var imageView: HMProgressImageView = {
        let iv = HMProgressImageView()
        
        iv.contentMode = UIViewContentMode.ScaleAspectFill
        iv.clipsToBounds = true
        
        return iv
    }()
    
    /// 准备动画参数
    ///
    /// - parameter fromRect: fromRect
    /// - parameter toRect:   toRect
    /// - parameter url:      url
    func prepareAnimator(fromRect: CGRect, toRect: CGRect, url: NSURL) {
        self.fromRect = fromRect
        self.toRect = toRect
        self.url = url
    }
    
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

// MARK: - UIViewControllerAnimatedTransitioning - 转场动画协议 - 专门提供专场动画的实现细节
extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    
    /// 返回专场动画时长
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 2
    }
    
    /// 专门实现转场动画效果 - 一旦实现了此方法，程序员必须完成动画效果
    ///
    /// - parameter transitionContext: transition[转场]Context[上下文] 提供了转场动画所需的一切细节
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        printLog(fromVC)
        printLog(toVC)
        
        isPresented ? presentAnim(transitionContext) : dismissAnim(transitionContext)
    }
    
    /// 实现解除专场动画
    ///
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
        
        // 1. 将 imageView 添加的 容器视图
        transitionContext.containerView()?.addSubview(imageView)
        imageView.frame = fromRect
        
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
        imageView.sd_setImageWithURL(url, placeholderImage: nil, options: [SDWebImageOptions.RetryFailed], progress: { (current, total) -> Void in
            
            // 设置进度 - 计算下载进度
            dispatch_async(dispatch_get_main_queue()) {
                self.imageView.progress = CGFloat(current) / CGFloat(total)
            }
            
            }) { (_, error, _, _) in
                
                // 判断是否有错误
                if error != nil {
                    printLog(error, logError: true)
                    
                    // 声明动画结束 － 参数为 false 容器视图不会添加，转场失败
                    transitionContext.completeTransition(false)
                    
                    return
                }
                
                // 3. 图像下载完成之后，再显示动画
                UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: { () -> Void in
                    
                    self.imageView.frame = self.toRect
                    
                    }, completion: { (_) -> Void in
                        // 将目标视图添加到容器视图
                        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
                        transitionContext.containerView()?.addSubview(toView)
                        
                        // 将 imageView 从界面上删除
                        self.imageView.removeFromSuperview()
                        
                        // 声明动画完成
                        transitionContext.completeTransition(true)
                })
        }
    }
}
