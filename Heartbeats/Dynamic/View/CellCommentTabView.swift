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
        separatorStyle = .None
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
        estimatedRowHeight = 50
        rowHeight = UITableViewAutomaticDimension
        dataSource = self
        delegate = self
        backgroundColor = UIColor.clearColor()
        bounces = false
        tableFooterView = UIView()
        registerClass(CommentTabViewCell.self, forCellReuseIdentifier: commentTabViewCell)
        prototypeCell =  dequeueReusableCellWithIdentifier(commentTabViewCell) as? CommentTabViewCell
    }
    
//     MARK: -- getter/ setter
    var dynamic: Dynamic? {                                 // 动态
        didSet{
            self.comments = dynamic?.comments as? [DynamicComment]
            reloadData()
        }
    }
    var tableViewHeight: CGFloat = 0.0
    var prototypeCell: CommentTabViewCell?                  // 减少cell的创建
    var comments: [DynamicComment]?                         // 评论
}

//  MARK: -- dataSource
extension CellCommentTabView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comments?.count < 1 {
            return 0
        }
        return comments?.count > 3 ? 3 : comments!.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(commentTabViewCell, forIndexPath: indexPath) as! CommentTabViewCell
        cell.comment = comments![indexPath.item]
        tableViewHeight += cell.cellHeight + 2
        return cell
    }
}
extension CellCommentTabView: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       let cell = self.prototypeCell!
       cell.comment = comments![indexPath.item]
        tableViewHeight += cell.cellHeight + 2
        if indexPath.item == comments!.count - 1 {
            NSNotificationCenter.defaultCenter().postNotificationName("updateCommentsViewHeight", object: nil, userInfo: ["height" : tableViewHeight])
        }
       return cell.cellHeight + 2
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}


/*评论Cell*/
class CommentTabViewCell: UITableViewCell {
//    MARK: -- override
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//   MARK : -- private func
    private func setUpUI() {
        backgroundColor = UIColor.clearColor()
        contentView.addSubview(contentLab)
        contentLab.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
//    MARK: -- getter / setter
    var comment: DynamicComment! {                                 // 评论
        didSet {
            let (str, height) = Tools.cellContentWithCellHeight(comment)
            contentLab.attributedText = str
            cellHeight = height
        }
    }
    var cellHeight: CGFloat = 0                                     // 行高
    let contentLab: UILabel = {                                     // 评论
        let lab = UILabel(frame: CGRect(x: 0, y: 0, width: Int(screenMaimWidth) - 16, height: Int.max))
        lab.preferredMaxLayoutWidth = screenMaimWidth - 16
        lab.textColor = UIColor.whiteColor()
        lab.numberOfLines = 4
        return lab
    }()
}

