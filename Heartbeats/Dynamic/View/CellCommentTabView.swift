//
//  CellCommentTabView.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/5/11.
//  Copyright © 2016年 heart. All rights reserved.
//

/*显示评论View*/

let commentTabViewCell = "commentTabViewCell"
class CellCommentTabView: UITableView {
 
//    MARK: -- override
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func selectRowAtIndexPath(indexPath: NSIndexPath?, animated: Bool, scrollPosition: UITableViewScrollPosition) {
        super.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .None)
    }
//    MARK: -- private func
    private func setUpUI() {
        dataSource = self
        delegate = self
        backgroundColor = UIColor.clearColor()
        bounces = false
        registerClass(CommentTabViewCell.self, forCellReuseIdentifier: commentTabViewCell)
    }
    
//     MARK: -- getter/ setter
    var dynamic: Dynamic? {                     // 动态
        didSet{
            
        }
    }
}

extension CellCommentTabView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(commentTabViewCell, forIndexPath: indexPath) as! CommentTabViewCell
        cell.contentText = "yesh, i know, I love"
        return cell
    }
}
extension CellCommentTabView: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
}



/*评论Cell*/
class CommentTabViewCell: UITableViewCell {
//    MARK: -- override
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//   MARK : -- private func
    private func setUpUI() {
        contentView.addSubview(contentLab)
        contentLab.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
//    MARK: -- getter / setter
    var contentText: String? {
        didSet{
            
        }
    }
    
    let contentLab: UILabel = {
        let lab = UILabel()
        return lab
    }()
}

