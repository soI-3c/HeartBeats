//
//  DynamicAddressControl.swift
//  Heartbeats
//
//  Created by liaosenshi on 16/5/4.
//  Copyright © 2016年 heart. All rights reserved.
//

import UIKit
import CoreLocation

let addressCellID = "addressCellID"
class DynamicAddressControl: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAddressView.registerClass(UITableViewCell.self, forCellReuseIdentifier: addressCellID)
    
        navigationItem.title = "位置"
        setUpUI()
    }
    override func viewWillAppear(animated: Bool) {
        inputAddressView.inputAddressField.text = ""                        // 先置空之前的输入位置
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        ////发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.startUpdatingLocation()
        }

    }
    override func prefersStatusBarHidden() -> Bool {     // 隐藏状态栏
        return true
    }
    
    func setUpUI() {
        showAddressView.tableFooterView = UIView()
        view.addSubview(inputAddressView)
        view.addSubview(showAddressView)
        
        inputAddressView.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(view)
            make.left.right.equalTo(view)
            make.height.equalTo(44)
        })
        showAddressView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(inputAddressView.snp_bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(view)
        }
    }
    
    //定位管理器
    let locationManager: CLLocationManager = CLLocationManager()
    var location: CLLocation?
    
    var addresss : [String]?                                    // 数据源
    
    var returnAddress: (String -> Void)?                        //  return 地址
    var showAddressView = UITableView()
    lazy var inputAddressView: InputAddressView = {
        let inputView = InputAddressView()
        inputView.addressString = {[weak self](addressString) -> Void in
            self!.returnAddress?(addressString)
            self!.dismissViewControllerAnimated(true, completion: nil)
        }
        return inputView
    }()
}

extension DynamicAddressControl: CLLocationManagerDelegate {
    
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         location = locations.last!
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location!, completionHandler: { (placemarks, error) -> Void in          // 返地理位置
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
                return
            }
            if placemarks!.count > 0 {
                    let placemark = placemarks?.first
                    self.addresss?.append((placemark?.locality)!)
                    self.addresss?.append((placemark?.subThoroughfare)!)
                    self.addresss?.append((placemark?.subLocality)!)
                    self.addresss?.append((placemark?.name)!)
                    self.showAddressView.reloadData()
            } else {
                print("No placemark")
            }
        })
    }
}

extension DynamicAddressControl: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresss?.count ?? 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(addressCellID)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: addressCellID)
        }
        if indexPath.row == 0 {
            cell?.textLabel?.text = "不显示位置"
            return cell!
        }
        cell?.textLabel?.text = addresss![indexPath.row]
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.returnAddress?(addresss![indexPath.row])
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


// MARK: -- 输入位置View
class InputAddressView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lightGrayColor()
        alpha = 0.8
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpUI() {
        addSubview(inputAddressField)
        addSubview(doneBtn)
        doneBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-8)
            make.right.equalTo(self).offset(-16)
            make.width.equalTo(45)
        }
        inputAddressField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(doneBtn)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(doneBtn.snp_left).offset(-16)
            make.bottom.equalTo(doneBtn)
        }
    }
    func doneWirteAddress() {
        inputAddressField.resignFirstResponder()
        addressString?(self.inputAddressField.text!)
    }

    var inputAddressField: UITextField = {
        let textField = UITextField()
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 5
        textField.backgroundColor = UIColor.whiteColor()
        textField.placeholder = "  手动输入位置..."
        textField.leftView = UIView(frame:  CGRectMake(0, 0, 16, textField.frame.height))
        textField.leftViewMode = .Always
        return textField
    }()
    lazy var doneBtn: UIButton = {
        let btn = UIButton()
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5
        btn.backgroundColor = UIColor.redColor()
        btn.setTitle(" 确定 ", forState: .Normal)
        btn.addTarget(self, action: "doneWirteAddress", forControlEvents: .TouchUpInside)
        return btn
    }()
    
    var addressString: (String -> Void)?                // 地址
}
