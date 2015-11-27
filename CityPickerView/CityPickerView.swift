//
//  CityPickerView.swift
//  CityPickerView
//
//  Created by impressly on 11/19/15.
//  Copyright © 2015 OTT. All rights reserved.
//

import UIKit
import Foundation

protocol CityPickerViewDelegate: NSObjectProtocol {
    
    func cityPickerDidPickArea(cityPickerView: CityPickerView, province: String!, city: String!, district: String!)
    func cityPickerDidCancel(cityPickerView: CityPickerView)
    
}

class CityPickerView: UIView {
    
    @IBOutlet weak var sureButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var buttonBgView: UIView!
    
    //load nib/xib
    var view: UIView!
    var nibName:String = "CityPickerView"
    
    // properties
    var cities:NSArray?
    var districts:NSArray?
    var provinces:NSArray?
    var cityData:NSArray = [] {
        didSet{
            self.getCityData()
        }
    }
    
    var pickerDistrict: String?
    var pickerCity: String?
    var pickerState: String?
    
    // delegate
    weak var delegate: CityPickerViewDelegate?
    
    // Lifecycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    // Load from xib/nib
    func loadViewFromNib()->UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    private func setup() {
        self.view = loadViewFromNib()
        view.frame = self.bounds
//        //MARK:自动调整大小
        view.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
//        //MARK:添加约束
        view.addConstraints(self.constraints)
        self.addSubview(self.view)
        //MARK:添加手势
        let tapGR = UITapGestureRecognizer(target: self, action: "tapAction:")
        self.view.addGestureRecognizer(tapGR)
        
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
        self.buttonBgView.hidden = true
        self.pickerView.selectRow(0, inComponent: 0, animated: false)
        self.pickerView.selectRow(0, inComponent: 1, animated: false)
        self.pickerView.selectRow(0, inComponent: 2, animated: false)
        self.pickerView.reloadAllComponents()

        addAnimation()
        getCityData()
    }
    
    //MARK:添加动画
    private func addAnimation() {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(1)
        self.pickerView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 200)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStopSelector("showButton:")
        UIView.commitAnimations()
    }
    
    //MARK:手势响应事件
    func tapAction(tap: UITapGestureRecognizer) {
        tap.view?.hidden = true
    }
    
    //MARK:动画结束之后显示buttonBgView
    func showButton(event:UIEvent) {
      self.buttonBgView.hidden = false
    }
    @IBAction func cancleAction(sender: AnyObject) {
        self.delegate?.cityPickerDidCancel(self)
       
    }
    
    @IBAction func sureAction(sender: AnyObject) {
        
        //MARK:传值
        //省
        let province: String = self.getProvince()
        //市
        let city: String = self.getCity()
        //区
        let district: String = self.getDistrict()
        
        
        self.delegate?.cityPickerDidPickArea(self, province: province, city: city, district: district)
        
    }
    
    private func getCityData() {
        self.provinces = NSMutableArray(contentsOfFile: NSBundle.mainBundle().pathForResource("area", ofType: "plist")!)!
        self.cities = self.provinces!.objectAtIndex(0).objectForKey("cities") as? NSArray
        self.districts = cities?.objectAtIndex(0).objectForKey("areas") as? NSArray
    }
    
}

extension CityPickerView: UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponentsInPickerView( pickerView: UIPickerView) -> Int{
        return 3
    }
    
    //设置选择框的行数
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int)->Int {
        switch (component) {
        case 0:
            return (self.provinces != nil ? self.provinces!.count : 0)
        case 1:
            return (self.cities != nil ? self.cities!.count : 0)
        case 2:
            return (self.districts != nil ? self.districts!.count : 0)
        default:
            return 0
        }
    }
    
    //设置选择框各选项的内容
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch (component) {
        case 0:
            return provinces?.objectAtIndex(row).objectForKey("state") as? String
            
        case 1:
            return cities?.objectAtIndex(row).objectForKey("city") as? String
        case 2:
            if (self.districts?.count > 0) {
                return self.districts?.objectAtIndex(row) as? String
            }
        default:
            return ""
        }
        return nil
    }
    
    //选项的选择状态
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch (component) {
        case 0:
            
            cities = provinces?.objectAtIndex(row).objectForKey("cities") as? NSArray
            
            // reselect 1st city
            self.pickerView.selectRow(0, inComponent: 1, animated: true)
            self.pickerView.reloadComponent(1)
            
            self.districts = cities?.objectAtIndex(0).objectForKey("areas") as? NSArray
            
            // reselect 1st area
            self.pickerView.selectRow(0, inComponent: 2, animated: true)
            self.pickerView.reloadComponent(2)
            
        case 1:
            self.districts = cities?.objectAtIndex(row).objectForKey("areas") as? NSArray
            
            // reselect 1st area
            self.pickerView.selectRow(0, inComponent: 2, animated: true)
            self.pickerView.reloadComponent(2)
            

        default:
            break
        }
        
        self.getPickerValues()
      
        
    }
    
    func getPickerValues() {
        let p1 = self.pickerView.selectedRowInComponent(0)
        self.pickerState = self.provinces?.objectAtIndex(p1).objectForKey("state") as? String
        
        
        let p2 = self.pickerView.selectedRowInComponent(1)
        self.pickerCity = self.cities?.objectAtIndex(p2).objectForKey("city") as? String
        
        if (self.districts?.count > 0) {
            let p3 = self.pickerView.selectedRowInComponent(2)
            self.pickerDistrict = self.districts?.objectAtIndex(p3) as? String
            
        } else {
            self.pickerDistrict = ""
        }
        
    }
    
    
    //省
    func getProvince() -> String {
        if self.pickerState?.characters.count > 0 && self.districts?.count > 0 {
            return "\(self.pickerState!)省"
        } else if self.pickerState?.characters.count > 0 {
            return "\(self.pickerState!)市"
        }
        return ""
    }
    //市
    func getCity() -> String {
        if self.pickerState?.characters.count > 0 && self.pickerCity?.characters.count > 0 && self.districts?.count > 0 {
            return "\(self.pickerCity!)市"
        } else if self.pickerCity?.characters.count > 0 {
            return "\(self.pickerCity!)区"
        }
        return ""
    }
    //区
    func getDistrict() ->String {
        if self.pickerDistrict?.characters.count > 0 {
            return "\(self.pickerDistrict!)"
        }
        return ""
    }

}
