//
//  TimeView.swift
//  wristBand
//
//  Created by suhengxian on 2021/11/8.
//

import Foundation
import UIKit
import SnapKit

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width

typealias TimeViewComplete = (_ date:Date) ->(Void)

public class TimeView:UIView{
    private  var topView:UIView!
    private var datePickerView:UIDatePicker!
    var titel:String?{
        didSet{
            self.titelLab.text = titel
        }
    }
    var mode:UIDatePicker.Mode?{
        didSet{
            self.datePickerView.datePickerMode = mode ?? .date
            
            if self.mode == .date{
                datePickerView.maximumDate = Date()
            }else{
                datePickerView.minimumDate = Date()
            }
            
        }
    }
    private var cancelBtn:UIButton!
    private var titelLab:UILabel!
    private var okBtn:UIButton!
    var timeViewComplete:TimeViewComplete?
    
    public override init(frame: CGRect) {
        super.init(frame:CGRect.init(x: 0, y:kScreenHeight,width: kScreenWidth, height: 280))
        commitView()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commitView()
    }
    
    func commitView(){
        self.backgroundColor = UIColor.clear
        topView = UIView()
        topView.backgroundColor = UIColor.gray
        self.addSubview(topView)
        
        cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancel(_:)), for: .touchUpInside)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .selected)
        topView.addSubview(cancelBtn)
        
        okBtn = UIButton(type: .custom)
        okBtn.setTitle("完成", for:.normal)
        okBtn.setTitle("完成", for: .selected)
        okBtn.addTarget(self, action: #selector(sure(_:)), for: .touchUpInside)
        okBtn.setTitleColor(UIColor.white, for: .normal)
        okBtn.setTitleColor(UIColor.white, for: .selected)
        topView.addSubview(okBtn)
        
        titelLab = UILabel()
        titelLab.textColor = UIColor.white
        titelLab.font = UIFont.systemFont(ofSize: 18)
        titelLab.textAlignment = .center
        titelLab.text = self.titel
        topView.addSubview(titelLab)
        
        datePickerView = UIDatePicker()
        datePickerView.timeZone = TimeZone.current
        datePickerView.datePickerMode = self.mode ?? .date
        datePickerView.addTarget(self, action: #selector(dateValueChanged(_:)), for: .valueChanged)
        if #available(iOS 13.4, *){
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        datePickerView.calendar = Calendar.current;
        datePickerView.locale = Locale(identifier: "zh_GB");
        datePickerView.timeZone = TimeZone.current;
        
//        1. "en_GB"英文 24小时
//        2. "zh_GB"中文24小时
//        3. ”zh_CN“中文12小时
        
        self.datePickerView.backgroundColor = UIColor.white
        self.setDateTextColor(picker:datePickerView)
        self.addSubview(datePickerView)
        
        //tap
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
    }
    
    @objc func tapClick(){
        self.dismiss()
    }
    
    private func setDateTextColor(picker:UIDatePicker){
            var count:UInt32 = 0
            let propertys = class_copyPropertyList(UIDatePicker.self, &count)
            for index in 0..<count {
                let i = Int(index)
                let property = propertys![i]
                let propertyName = property_getName(property)
                
                let strName = String.init(cString: propertyName, encoding: String.Encoding.utf8)
                if strName == "textColor"{
                    picker.setValue(UIColor.black, forKey: strName!)
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        datePickerView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(0)
            make.bottom.equalToSuperview()
            make.height.equalTo(220)
        }
        
        topView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(0)
            make.bottom.equalTo(datePickerView.snp.top)
            make.width.equalTo(self)
            make.height.equalTo(60)
        }
            
        cancelBtn.snp.makeConstraints { make in
            make.leading.equalTo(topView.snp.leading).offset(10)
            make.top.equalTo(topView.snp.top).offset(5)
            make.width.equalTo(60)
            make.bottom.equalTo(topView.snp.bottom).offset(-5)
        }
       
        okBtn.snp.makeConstraints { make in
            make.trailing.equalTo(topView.snp.trailing).offset(-10)
            make.top.equalTo(topView.snp.top).offset(5)
            make.width.equalTo(60)
            make.bottom.equalTo(topView.snp.bottom).offset(-5)
        }

        titelLab.snp.makeConstraints { make in
            make.leading.equalTo(cancelBtn.snp.trailing).offset(0)
            make.trailing.equalTo(okBtn.snp.leading).offset(0)
            make.top.equalTo(topView.snp.top).offset(5)
            make.bottom.equalTo(topView.snp.bottom).offset(-5)
        }
    }
    
    @objc private func dateValueChanged(_ datePicker:UIDatePicker){
        print("date:\(datePicker.date)")

    }
    
    @objc func cancel(_ sender:UIButton){
        self.dismiss()
        
    }
 
    @objc func sure(_ sender:UIButton){
        self.dismiss()
        if self.timeViewComplete != nil{
            self.timeViewComplete!(self.datePickerView.date)
        }
    }
    
    func selectDate(_ timeViewComplete:@escaping TimeViewComplete){
        self.timeViewComplete = timeViewComplete
    }
    
    //出现
    func show(){
        var w:UIWindow = UIWindow()
        if #available(iOS 13, *){
            for windowScene in UIApplication.shared.connectedScenes{
                if windowScene.activationState == UIWindowScene.ActivationState.foregroundActive {
                    
                    for window in (windowScene as! UIWindowScene).windows {
                        if window.isKeyWindow {
                            w = window
                        }
                    }
                }
            }
        }else{
            w = UIApplication.shared.keyWindow ?? UIWindow()
        }
        
        w.addSubview(self)
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect.init(x: 0, y:0, width: kScreenWidth, height:kScreenHeight)
        }
    }
    
    //隐藏
    func dismiss(){
        UIView.animate(withDuration: 0.5) {
            self.frame = CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height:kScreenHeight)
        } completion: { ret in
            self.removeFromSuperview()
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.dismiss()
    }
    
}


//+ (UIWindow *)zyl_keyWindow
//{
//    if (@available(iOS 13.0, *)) {
//        for (UIWindowScene *windowScene in UIApplication.sharedApplication.connectedScenes) {
//            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
//                for (UIWindow *window in windowScene.windows) {
//                    if (window.isKeyWindow) {
//                        return window;
//                    }
//                }
//                break;
//            }
//        }
//    } else {
//        return UIApplication.sharedApplication.keyWindow;
//    }
//
//    return nil;
//}


