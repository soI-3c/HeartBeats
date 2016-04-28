//
//  ShowDynamicPhotoController.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/1/5.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit

//MARK: -- 显示动态的Controller
class ShowDynamicPhotoController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var contentLabel: UILabel!       // 内容
    @IBOutlet weak var praiseBtn: UIButton!         // 赞
    @IBOutlet weak var commentBtn: UIButton!        // 评论
    @IBOutlet weak var praiseNumber: UIButton!      // 赞的个数
    @IBOutlet weak var commentNumber: UIButton!     // 评论个数
    
    @IBOutlet weak var dynamicCollectionView: UICollectionView!
    var dynamic: Dynamic? {
        didSet {
            if dynamic != nil {
                self.title = "2015/ 04/ 15"
                contentLabel.text = dynamic?.content
//                dynamicPhotos = Dynamic.photoUrls(dynamic!)
            }
        }
    }
    var dynamicPhotos: [String]? {
        didSet {
            dynamicCollectionView.reloadData()
        }
    }
    var selectDynamicIndex: Int?    // 选择动态的下标
    var dynamics: [Dynamic]? {
        didSet {
            dynamic = dynamics?[selectDynamicIndex!]
        }
    }
    
//     MARK: --- 初始化
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSetting()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func prepareSetting() {
        // 设置布局的间距
        let layout = dynamicCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = view.frame.size
        dynamicCollectionView.delegate = self
        dynamicCollectionView.pagingEnabled = true
        dynamicCollectionView.showsHorizontalScrollIndicator = false
        dynamicCollectionView.registerNib(UINib(nibName: "HBCollectionCell", bundle: nil), forCellWithReuseIdentifier: HBColleectionCellID)
    }
//    MARK: --- UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dynamicPhotos?.count ?? 0
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HBColleectionCellID, forIndexPath: indexPath) as! HBCollectionCell
        cell.imgUrl = dynamicPhotos?[indexPath.row]
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func praiseAction(sender: UIButton) {
        print("praiseAction")
    }
//    MARK : --- 发表评论
    @IBAction func commentAction(sender: UIButton) {
        let (showView, _) = loadNameWithPhoneView("PersonalitySetView")
        (showView as? PersonalitySetView)?.editBtn.setTitle("发表", forState: .Normal)
        showView.changeHandler = {(objStr) -> Void in
            Tools.showSVPMessage(objStr)
        }
    }
    
    private func loadNameWithPhoneView(classString: String) -> (view: NameWithPhoneSetView, modal: PathDynamicModal) {
        let showView = Tools.instantiateFromNib(classString, widthPercen: 0.65, hieghtPercen: 0.5) as! NameWithPhoneSetView
        let window = UIApplication.sharedApplication().delegate?.window!
        let modal = PathDynamicModal.show(modalView: showView, inView: window!)
        
        showView.changeSaveActionHandler = {() -> Void in
            modal.closeWithLeansRight()
        }
        showView.closeHandler = {() -> Void in
            modal.closeWithLeansLeft()
            return
        }
        return (showView, modal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
