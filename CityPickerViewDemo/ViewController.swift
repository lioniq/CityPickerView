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
   
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.cityTextField.delegate = self
        self.cityPickerView.hidden = true
        self.view.bringSubviewToFront(self.cityTextField)
        self.cityPickerView.delegate = self
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField == self.cityTextField
        textField.resignFirstResponder()
        if cityPickerView != nil {
            self.cityPickerView.hidden = false
        }
    }
}

extension ViewController:CityPickerViewDelegate {
    
    func cityPickerDidPickArea(cityPickerView: CityPickerView, province: String!, city: String!, district: String!) {
        let provinceCityDistrict = "\(province)\(city)\(district)"
        self.cityTextField.text = provinceCityDistrict
        
        self.cityPickerView.hidden = true
    }
    
    func cityPickerDidCancel(cityPickerView: CityPickerView) {
        self.cityPickerView.hidden = true
    }
}