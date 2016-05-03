//
//  DynamicWriteContentTextController.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/5/3.
//  Copyright © 2016年 heart. All rights reserved.
//



/* 填写动态文字 */
class DynamicWriteContentTextController: UIViewController, UITextViewDelegate {
    
//    MARK: -- override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = UIColor.blackColor()
        navigationItem.title = "文字"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: "doneWrite")
        setUpUI()
    }
    override func viewWillAppear(animated: Bool) {
        contentTextView.becomeFirstResponder()
    }
    override func prefersStatusBarHidden() -> Bool {     // 隐藏状态栏
        return true
    }
    
//    MARK: -- private func
    private func setUpUI() {
        view.addSubview(contentTextView)
        
        contentTextView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.left.right.equalTo(view)
            make.height.equalTo(view)
        }
    }
    
    func doneWrite() {
        contentTextView.resignFirstResponder()
        contentT?(contentTextView.text)
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //    MARK: -- getter / setter
   lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.blackColor()
        textView.font = UIFont(name: "", size: 14)
        textView.delegate = self
        textView.backgroundColor = UIColor.whiteColor()
        return textView
    }()
    var contentT: (String -> Void)?                     // 回调
}
