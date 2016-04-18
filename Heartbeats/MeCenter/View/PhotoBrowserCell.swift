//
//  PhotoBrowserCell.swift
//
//  Created by Romeo on 15/9/14.
//  Copyright © 2015年. All rights reserved.
//

import UIKit

/// 照片浏览 Cell，显示单张图片
class PhotoBrowserCell: UICollectionViewCell {
    /// 图像的 URL
    var url: NSURL? {
        didSet {
            printLog(url)
            // 重置 scrollView
            resetScrollView()
            
            // 打开指示器
            indicator.startAnimating()
            
            imageView.image = nil
            
            // 提问：对于 SDWebImage，如果设置了 image URL，图片会出现重用吗？
            // 原因：sdwebImage 一旦设置的 url 和之前的 url 不一致，会将 image 设置为 nil
            // dispatch_time 从什么时候开始，持续多久
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                // 之前 imageView 并没有指定大小
                // * RetryFailed 可以允许失败后重试
                // * RefreshCached 如果服务器的图像变化，而本地的图像是之前的图像，使用此选项，会更新服务器的图片
                //   GET 方法能够缓存，如果服务器返回的状态吗是 304，表示内容没有变化
                //   提交请求，如果是 304，就使用本地缓存，否则使用服务器返回的图片，具体内容看`网络视频`
                self.imageView.sd_setImageWithURL(self.url, placeholderImage: nil, options: [SDWebImageOptions.RetryFailed, SDWebImageOptions.RefreshCached]) { (image, error, _, _) in
                    
                    // 关闭指示器
                    self.indicator.stopAnimating()
                    
                    // 判断图像是否下载完成
                    if error != nil {
                        SVProgressHUD.showInfoWithStatus("您的网络不给力")
                        return
                    }
                    // 执行到此处，表示图片已经下载完成
                    self.setImagePosition()
                }
            }
        }
    }
    
    /// 重置 scrollView 的内容属性，因为缩放会影响到内容属性
    private func resetScrollView() {
        scrollView.contentSize = CGSizeZero
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
    }
    
    /// 设置图像位置
    /**
        长短图
    
        如果图像缩放之后，没有屏幕高，显示在中间
        否则，显示在顶部，并且设置 contentSize 允许滚动
    */
    private func setImagePosition() {
        
        let size = displaySize(imageView.image!)
        
        imageView.frame = CGRect(origin: CGPointZero, size: size)
        // 短图
        if size.height < scrollView.bounds.height {
            let y = (scrollView.bounds.height - size.height) * 0.5
            
            // 设置边距的最大好处，缩放之后，能够自动调整 contentSize，能够保证滚动看到边界
            scrollView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: 0)
        } else {    // 长图
            
            scrollView.contentSize = size
        }
    }
    
    /// 按照 scrollView 的宽度，计算缩放后的比例
    private func displaySize(image: UIImage) -> CGSize {
        // 1. 图像宽高比
        let scale = image.size.height / image.size.width
        // 2. 计算高度
        let w = scrollView.bounds.width
        let h = w * scale
        
        return CGSize(width: w, height: h)
    }
    
    // MARK: - 构造函数，因为和屏幕一样大，只会被调用两次，后面再滚动就直接使用缓冲池中的 cell
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 1. 添加控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        contentView.addSubview(indicator)
        
        // 2. 设置位置 － 让 scrollView 和 cell 一样大
        var rect = bounds
        rect.size.width -= 20
        
        scrollView.frame = rect
        indicator.center = scrollView.center
        
        prepareScrollView()
    }
    
    /// 准备 scrollView
    private func prepareScrollView() {
        // 设置代理
        scrollView.delegate = self
        
        // 设置最大和最小缩放比例
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
    }
    
    // MARK: - 懒加载控价
    /// 缩放图片
    private lazy var scrollView = UIScrollView()
    /// 显示单张图片
    lazy var imageView = UIImageView()
    /// 菊花
    private lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
}

// MARK: - UIScrollViewDelegate
extension PhotoBrowserCell: UIScrollViewDelegate {
    
    /// 告诉 scrollView 缩放哪一个视图
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    /// 缩放完成后会被调用
    ///
    /// - parameter scrollView: scrollView
    /// - parameter view:       view - 被缩放的视图
    /// - parameter scale:      scale 缩放完成的比例
    /// 提示：测试的时候，需要找合适的图片
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {   
        // 调整 Y 值
        var offsetY = (scrollView.bounds.height - imageView.frame.height) * 0.5
        // 调整 X 值
        var offsetX = (scrollView.bounds.width - imageView.frame.width) * 0.5
        // 调整 offsetY 避免 < 0 之后，顶部内容看不到
        offsetY = (offsetY < 0) ? 0 : offsetY
        offsetX = (offsetX < 0) ? 0 : offsetX
        
        // 重新设置间距
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
    
    /// 只要缩放，就会被调用
    ///
    /// - parameter scrollView: scrollView
    /// 形变参数小结
    /// 1. a / d 决定 缩放比例
    /// 2. tx / ty 决定 位移
    /// 3. a b c d 共同决定旋转角度
    /// 修改形变的过程中，bounds 的数值不会发生变化
    /// frame 的数值会发生变化，bounds * transform => frame
    func scrollViewDidZoom(scrollView: UIScrollView) {
        print("-----------")
        print(imageView.transform)
        print(imageView.bounds)
        print(imageView.frame)
    }
}
