//
//  UIButton+Extension.swift
//  Heartbeats
//
//  Created by liaosenshi on 15/12/30.
//  Copyright © 2015年 heart. All rights reserved.

import UIKit

/// Cell 的可重用标识符
private let PictureSelectorCellID = "PictureSelectorCellID"
/// 最大选择照片数量
private let HBMaxPictureCount = 6

class PictureSelectorViewController: UICollectionViewController, PictureSelectorCellDelegate {
    
    /// 照片数组 - 数据源
    lazy var pictures = [UIImage]()
    /// 用户当前选中照片索引
    private var currentIndex = 0
    
    // MARK: - 搭建界面
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        // 设置布局 -> 屏幕越大，展现的内容越多！不完全是等比例放大！
        layout.itemSize = CGSize(width: screenMaimWidth / 4 - 1, height: 85)
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.blackColor()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        // 注册可重用 cell
        self.collectionView!.registerClass(PictureSelectorCell.self, forCellWithReuseIdentifier: PictureSelectorCellID)
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 至少要有一个按钮允许用户添加照片，如果达到最大数量限制，就不再添加
        return pictures.count + (pictures.count == HBMaxPictureCount ? 0 : 1)
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PictureSelectorCellID, forIndexPath: indexPath) as! PictureSelectorCell
        // 设置代理
        cell.pictureDelegate = self
        // 设置图片，比数据源多一个，让最后一个作为添加照片的按钮
        cell.image = indexPath.item < pictures.count ? pictures[indexPath.item] : nil
        return cell
    }
    
    /// 选择照片
    /// Camera              相机
    /// PhotoLibrary        照片库 － 包含相册，包括通过 iTunes / iPhoto 同步的照片，同步的照片不允许在手机删除
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            print("无法访问相册")
            return
        }
        // 记录用户当前选中 的照片
        currentIndex = indexPath.item
        
        // 访问相册
        let vc = UIImagePickerController()
        
        // 监听照片选择
        vc.delegate = self
        // 允许编辑
        // vc.allowsEditing = true
        presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - PictureSelectorCellDelegate
    private func pictureSelectorCellClickRemoveButton(cell: PictureSelectorCell) {
        print("删除按钮 \(cell)")
        
        // 根据 cell 获得当前的索引
        if let indexPath = collectionView?.indexPathForCell(cell) where indexPath.item < pictures.count {
            
            // 删除对应索引的图像
            pictures.removeAtIndex(indexPath.item)
            
            // 刷新视图
            collectionView?.reloadData()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension PictureSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /// 选中照片代理方法
    ///
    /// - parameter picker:      picker 选择控制器
    /// - parameter image:       选中的图像
    /// - parameter editingInfo: 编辑字典，在开发选择用户头像时，格外有用！vc.allowsEditing = true
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
       
        let scaleImage = image.scaleImageToWidth(screenMaimWidth)
           print( UIImagePNGRepresentation(scaleImage)?.length)
        // 用户选中了一张照片
        if currentIndex < pictures.count {
            print("选中的索引是 \(currentIndex)")
            pictures[currentIndex] = scaleImage
        } else {
            // 追加照片
            pictures.append(scaleImage)
        }
        // 刷新视图
        collectionView?.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}

/// 照片 Cell 的协议
private protocol PictureSelectorCellDelegate: NSObjectProtocol {
    /// 选中删除按钮 - collectionView / tableView Cell 一个视图会包含多个 cell，在定义代理方法的时候，一定要传 cell
    /// 通过 cell 的属性，控制器能够判断出点击的对象
    func pictureSelectorCellClickRemoveButton(cell: PictureSelectorCell)
}

/// 照片选择 Cell
private class PictureSelectorCell: UICollectionViewCell {
    
    var image: UIImage? {
        didSet {
            if image != nil {
                pictureButton.setImage(image, forState: .Normal)
            } else {
                // 显示默认的加号图片
                pictureButton.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Normal)
            }
            
            // 如果没有图像，隐藏删除按钮
            removeButton.hidden = (image == nil)
        }
    }
    
    /// 定义代理
    weak var pictureDelegate: PictureSelectorCellDelegate?
    
    /// 点击删除按钮
    @objc private func clickRemove() {
        pictureDelegate?.pictureSelectorCellClickRemoveButton(self)
    }
    
    /// 提示： frame是根据 layout 的 itemSize 来的
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(pictureButton)
        contentView.addSubview(removeButton)
        // 布局
        pictureButton.frame = bounds
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        let viewDict = ["btn": removeButton]
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[btn]-0-|", options: [], metrics: nil, views: viewDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[btn]", options: [], metrics: nil, views: viewDict))
        
        // 禁用 照片选择按钮 - 就可以触发 collectionView 的 didSelected 代理方法
        // 禁用按钮有一个损失：不会再显示高亮图像
        pictureButton.userInteractionEnabled = false
        
        // 添加监听方法
        removeButton.addTarget(self, action: "clickRemove", forControlEvents: .TouchUpInside)
        
        // 通过修改 imageView 才能够修改按钮的 contentMode
        pictureButton.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    // MARK: - 懒加载控件
    /// 添加照片按钮
    private lazy var pictureButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: .Normal)
        btn.sizeToFit()
        return btn
    }()
    /// 删除照片按钮
    private lazy var removeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "compose_photo_close"), forState: .Normal)
        btn.sizeToFit()
        return btn
    }()
}
