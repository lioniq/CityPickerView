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
    
    func cityPickerViewDidPickArea(cityPickerView: CityPickerView, area: String) {
        self.cityPickerView = cityPickerView
        self.cityTextField.text = area
        self.cityPickerView.hidden = true
    }
    
    func hiddenPicker(cityPickerView: CityPickerView) {
        self.cityPickerView = cityPickerView
        self.cityPickerView.hidden = true
    }
}