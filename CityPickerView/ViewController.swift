//
//  ViewController.swift
//  CityPickerView
//
//  Created by impressly on 11/19/15.
//  Copyright © 2015 OTT. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityPickerView: CityPickerView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var backView: UIView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.cityTextField.delegate = self
        self.cityPickerView.hidden = true
        self.backView.hidden = true
        self.backView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        //cityPickerView 移到最上面
        self.view.bringSubviewToFront(self.cityPickerView)
        self.cityPickerView.delegate = self
        //self.cityTextField.userInteractionEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField == self.cityTextField
        self.backView.hidden = false
        self.cityPickerView.hidden = false
    }
}

extension ViewController:CityPickerViewDelegate {
    
    func cityPickerViewDidPickArea(cityPickerView: CityPickerView, area: String) {
        self.cityPickerView = cityPickerView
        self.cityTextField.text = area
        self.backView.hidden = true
    }
}