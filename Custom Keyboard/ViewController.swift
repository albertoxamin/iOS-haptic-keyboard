//
//  ViewController.swift
//  Custom Keyboard
//
//  Created by Alberto Xamin on 26/06/2018.
//  Copyright © 2018 Alberto Xamin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.becomeFirstResponder()
    }


}

