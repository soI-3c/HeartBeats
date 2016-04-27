//
//  Tools.swift
//  Heartbeats
//
//  Created by iOS-3C on 15/12/6.
//  Copyright © 2015年 heart. All rights reserved.
//

import UIKit

let screenMaimWidth = UIScreen.mainScreen().bounds.size.width
let screenMaimheiht = UIScreen.mainScreen().bounds.size.height
let iconImageString = "iconImage"                       // 头像名称ID
let backIconImageString = "backIconImage"               // 背景头像ID

let placeholderImage = UIImage(named: "u4")

let zero:CGFloat = 0.0
let minMargins = 8                  // MeCenterHeadView
let maxMArgins = 16                 // MeCenterHeadView
let fontSize: CGFloat = 15


let provinceArray = ["广东省","上海", "北京"]
let sexs = ["男", "女"]

let cityArray = ["珠海", "广州", "深圳"]

let academicArray = ["大专以下", "大专", "本科", "硕士", "博士"]

 let heights = ["140cm","141cm","142cm","143cm","144cm","145cm","146cm","147cm","148cm","149cm","150cm", "151cm", "152cm", "153cm", "154cm", "155cm", "156cm", "157cm", "158cm", "159cm", "160cm", "161cm", "162cm", "163cm", "164cm", "165cm", "166cm", "167cm", "168cm", "169cm","170cm", "171cm", "172cm", "173cm", "174cm", "175cm", "176cm", "177cm", "178cm", "179cm","180cm", "181cm", "182cm", "183cm", "184cm", "185cm", "186cm", "187cm", "188cm", "189cm", "190cm", "191cm", "192cm", "193cm", "194cm", "195cm", "196cm", "197cm", "198cm", "199cm", "200cm","201cm", "202cm", "203cm", "204cm", "205cm", "206cm", "207cm", "208cm", "209cm", "210cm"]

let ages = ["18","19","20","21","22","23","24","25","26","27","28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47","48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60"]

 let incomes = ["0 -- 2000元", "2000 -- 5000元", "5000 -- 8000元", "8000 -- 10000元", "10000 -- 15000元", "15000 -- 20000元", "20000 -- 30000元", "30000元以上"]

 let houses = ["租房", "与父母同住", "已购房"]

 let cars = ["已购车", "暂没购车"]


let userId = "userID"



// MARK: - 输出日志
/// 输出日志
///
/// - parameter message:  日志消息
/// - parameter logError: 错误标记，默认是 false，如果是 true，发布时仍然会输出
/// - parameter file:     文件名
/// - parameter method:   方法名
/// - parameter line:     代码行数
func printLog<T>(message: T,
    logError: Bool = false,
    file: String = __FILE__,
    method: String = __FUNCTION__,
    line: Int = __LINE__)
{
    if logError {
        print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    } else {
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
        #endif
    }
}
class Tools: NSObject {
    static var userdefaults = NSUserDefaults.standardUserDefaults()
    
//    MARK: -- token
    internal class func saveUserID(token : String) {
        userdefaults.setObject(token, forKey: userId)
    }
    
    internal class func userID() -> String {
        return (userdefaults.objectForKey(userId) ?? "") as! String
    }
    
//    MARK: -- 保存用户名
    internal class func saveUsername(token : String) {
        userdefaults.setObject("username", forKey: token)
    }
    
    internal class func username() -> String {
        return (userdefaults.objectForKey("username") ?? "") as! String
    }

//   MARK: -- 手机验证
    class func phoneCheck(number: String)-> Bool {
        let mobile = "^1[3|4|5|7|8][0-9]{9}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        
        if ((regextestmobile.evaluateWithObject(number) == true)
            || (regextestcm.evaluateWithObject(number)  == true)
            || (regextestct.evaluateWithObject(number) == true)
            || (regextestcu.evaluateWithObject(number) == true)) {
                return true
        }else {
            return false
        }
    }
//    MARK: -- 验证代码判断, 是否为纯数字
    class func verifyCodeCheck(var number : String) -> Bool{
     number = number.stringByTrimmingCharactersInSet(NSCharacterSet.decimalDigitCharacterSet())
        if number.characters.count > 0 {
            return false
        }else {
            return true
        }
    }
    
//    MARK: -- 自己封装一个UIAlertView
    class func myAlertView(title: String?, message: String?, delegate: AnyObject?, canelBtnTitle: String?) {
         UIAlertView(title: title!, message: message!, delegate: delegate, cancelButtonTitle: canelBtnTitle).show()
    }
    
//    MARK: -- 封装一个UILabel(标签Label)
    class func hbUILabel(text: NSString)-> UILabel {
        let lab = UILabel()
        lab.text = text as String
        let labSize = text.sizeWithAttributes([NSFontAttributeName : lab.font])
        lab.frame = CGRect(x: 0, y: 0, width: labSize.width, height: labSize.height)
        lab.backgroundColor = UIColor.grayColor()
        lab.textColor = UIColor.whiteColor()
        return lab
    }
    
    class func hbUILabel2(text: NSString, width: CGFloat)-> UILabel {
        let lab = UILabel()
        lab.text = text as String
        lab.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(width)
        }
        lab.backgroundColor = UIColor.grayColor()
        lab.textColor = UIColor.whiteColor()
        return lab
    }
//    MARK: -- 加载指定xib
    class func instantiateFromNib(className: String, widthPercen: CGFloat, hieghtPercen: CGFloat) -> UIView? {
        let view = UINib(nibName: className, bundle: nil).instantiateWithOwner(nil, options: nil).first as! UIView
        view.frame = CGRect(x: 0, y: 0, width: screenMaimWidth * widthPercen, height: screenMaimheiht * hieghtPercen)
        return view
    }
    
//    显示提示框并设置样式
    class func showSVPMessage(message: String) {
        SVProgressHUD.setBackgroundColor(UIColor.blackColor())
        SVProgressHUD.setForegroundColor(UIColor.whiteColor())
        SVProgressHUD.showInfoWithStatus(message);
    }
}
