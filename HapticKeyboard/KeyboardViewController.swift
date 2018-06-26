//
//  KeyboardViewController.swift
//  HapticKeyboard
//
//  Created by Alberto Xamin on 26/06/2018.
//  Copyright © 2018 Alberto Xamin. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    var timer: Timer!
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    @objc func keyUnPressed(_ sender: UIButton){
        timer.invalidate()
        sender.backgroundColor = UIColor.white
    }
    
    @objc func keyPressed(_ sender: UIButton){
        timer.invalidate()
        sender.backgroundColor = UIColor.white
        lightImpactFeedbackGenerator.impactOccurred()
        key = sender
        type()
    }
    
    @objc func type(){
        lightImpactFeedbackGenerator.impactOccurred()
        let text : String = key!.titleLabel!.text!
        switch text {
        case "␣":
            textDocumentProxy.insertText(" ")
        case "return":
            
            break
        case "🔢":
            break
        case "⌫":
            textDocumentProxy.deleteBackward()
        case "🌐":
            self.advanceToNextInputMode()
        case "↑":
            key!.setTitle("⇡", for: [])
            setCaps()
        case "⇡":
            key!.setTitle("↑", for: [])
            setCaps()
        default:
            textDocumentProxy.insertText(text)
        }
    }
    
    func setCaps() {
        caps = !caps
        let myViews = view.subviews.filter{$0 is UIButton}
        let letters = "qwertyuiopasdfghjklzxcvbnm"
        for button in myViews {
            if letters.contains((button as! UIButton).titleLabel!.text!.lowercased()) {
                let text = (button as! UIButton).titleLabel!.text!
                (button as! UIButton).setTitle((caps ? text.uppercased() : text.lowercased()), for: [])
            }
        }
    }
    
    @objc func initalizeRepeat(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(type), userInfo: nil, repeats: true)
    }
    
    
    var caps = false
    var key : UIButton?
    @objc func keyDown(_ sender: UIButton){
        sender.backgroundColor = UIColor.gray
        key = sender
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(initalizeRepeat), userInfo: nil, repeats: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lightImpactFeedbackGenerator.prepare()
        
        let firstRow = "qwertyuiop asdfghjkl ↑zxcvbnm⌫ 🔢🌐🎤␣➥"
        
        var x : CGFloat = 0
        var y : CGFloat = 10
        var rowIndex = 0
        for row in firstRow.split(separator: " ") {
            let letterSize = (UIScreen.main.bounds.size.width - 3 - ((rowIndex == 1) ? 36 : 0)) / CGFloat(row.count)
            if rowIndex == 1{
                x = 18
            }
            for char in row {
                let keyBtn = UIButton(type: .roundedRect)
                keyBtn.setTitle(NSLocalizedString(String(char), comment: String(char)), for: [])
                keyBtn.addTarget(self, action:#selector(keyPressed), for: .touchUpInside)
                keyBtn.addTarget(self, action:#selector(keyUnPressed), for: .touchUpOutside)
                keyBtn.addTarget(self, action:#selector(keyDown), for: .touchDown)
                keyBtn.tintColor = UIColor.black
                keyBtn.titleLabel?.font = UIFont(name: "SF Pro", size: 25)
                keyBtn.backgroundColor = UIColor.white
                keyBtn.layer.cornerRadius = 5
                keyBtn.layer.shadowColor = UIColor.black.cgColor
                keyBtn.layer.shadowOpacity = 0.1
                keyBtn.layer.shadowOffset = CGSize(width: 0, height: 1)
                keyBtn.layer.shadowRadius = 1
                self.view.addSubview(keyBtn)
                
                var w = letterSize
                if rowIndex == 3 {
                    if char == "➥" {
                        w = 92
                        keyBtn.setTitle("return", for: [])
                        keyBtn.backgroundColor = UIColor.blue
                    }else if char == "␣"{
                        w = 154
                    } else {
                        w = 42
                    }
                }
                keyBtn.frame = CGRect(x: x + 3, y: y, width: w - 3, height: 42)
                x += w
            }
            x = 0
            rowIndex += 1
            y += 42 + ((rowIndex == 1 || rowIndex == 2) ? 12 : 10)
        }
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
        
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
    }

}
