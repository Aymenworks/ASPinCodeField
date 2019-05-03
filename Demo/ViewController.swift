//
//  ViewController.swift
//  Demo
//
//  Created by Rebouh Aymen on 02/05/2019.
//  Copyright © 2019 Rebouh Aymen. All rights reserved.
//

import UIKit
import ASPinCodeField

class ViewController: UIViewController, ASPinCodeFieldDelegate, ASPinCodeFieldDataSource {
  
    let numberOfDigits = 6
    
    @IBOutlet weak var storyboardPinField: ASPinCodeField! {
        didSet {
            storyboardPinField.delegate = self
            storyboardPinField.dataSource = self
            storyboardPinField.borderColor = UIColor.lightGray
            storyboardPinField.textColor = UIColor.black
            storyboardPinField.cornerRadius = 6
            storyboardPinField.textFont = .boldSystemFont(ofSize: 20)
        }
    }

    // MARK: ASPinCodeFieldDelegate
    
    func pinCodeField(_ pinCodeField: ASPinCodeField, didChangeText text: String) {
        print("pinCodeField didChangeText = \(text)")
        if text.count == numberOfDigits {
            _ = pinCodeField.resignFirstResponder()
            print("finish typing pin code.  Time to validate")
        }
    }

    // MARK: ASPinCodeFieldDataSource
    
    func numberOfDigits(in pinCodeField: ASPinCodeField) -> Int {
        return self.numberOfDigits
    }
    
    func canPasteFromPasteBoard(_ pinCodeField: ASPinCodeField, pasteboard: String) -> Bool {
        return false
    }
}

