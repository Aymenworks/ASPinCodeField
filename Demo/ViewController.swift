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
  
    // MARK: Properties
    
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
    
    let pinField = ASPinCodeField()

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pinField)

        pinField.delegate = self
        pinField.dataSource = self
        
        pinField.borderColor = UIColor.lightGray
        pinField.textColor = UIColor.black
        pinField.cornerRadius = 6
        pinField.textFont = .boldSystemFont(ofSize: 20)
        
        pinField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pinField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            pinField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            pinField.heightAnchor.constraint(equalToConstant: 60),
            pinField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
        ])
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

