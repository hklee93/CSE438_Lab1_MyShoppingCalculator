//
//  ViewController.swift
//  Lab1-ShoppingCalculator
//
//  Created by Hakkyung on 2018. 9. 10..
//  Copyright © 2018년 Hakkyung Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var myTitle: UILabel!
    @IBOutlet weak var opLabel: UILabel!
    @IBOutlet weak var dcLabel: UILabel!
    @IBOutlet weak var stLabel: UILabel!
    @IBOutlet weak var fpLabel: UILabel!
    @IBOutlet weak var erLabel: UILabel!
    
    @IBOutlet weak var opText: UITextField!
    @IBOutlet weak var dcText: UITextField!
    @IBOutlet weak var stText: UITextField!
    @IBOutlet weak var fpText: UILabel!
    @IBOutlet weak var erText: UITextField!
    @IBOutlet weak var segCtr: UISegmentedControl!
    
    var lang:String = "ENG"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        opText.textAlignment = .center
        dcText.textAlignment = .center
        stText.textAlignment = .center
        fpText.textAlignment = .center
        erText.textAlignment = .center
        
        self.opText.delegate = self
        self.dcText.delegate = self
        self.stText.delegate = self
        self.erText.delegate = self
        
        erText.text = "1000.00"
        updatePrice()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //Reference: closing keyboard when tapped the view
        //https://medium.com/@KaushElsewhere/how-to-dismiss-keyboard-in-a-view-controller-of-ios-3b1bfe973ad1
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeValue(_ sender: UITextField) {
        
        updatePrice()
    }
    
    @IBAction func changeLang(_ sender: Any) {
        
        if(segCtr.selectedSegmentIndex == 0){
            
            lang = "ENG"
            myTitle.text = "My Shopping Calculator"
            opLabel.text = "Original Price"
            dcLabel.text = "Discount %"
            stLabel.text = "Sales Tax %"
            fpLabel.text = "Final Price"
            erLabel.text = "Exchange Rate"
            
            if(fpText.text!.count > 0){
                
                fpText.text = fpText.text!.replacingOccurrences(of: "₩", with: "$")
            }
        }
        else{
            
            lang = "KR"
            myTitle.text = "나의 쇼핑 계산기"
            opLabel.text = "원가"
            dcLabel.text = "할인률(%)"
            stLabel.text = "판매세(%)"
            fpLabel.text = "최종가"
            erLabel.text = "환율"
            
            if(fpText.text!.count > 0){
                
                fpText.text = fpText.text!.replacingOccurrences(of: "$", with: "₩")
            }
        }
        
        updatePrice()
    }
    
    //Reference: closing the keyboard when pressed "done"
    //https://stackoverflow.com/questions/24180954/how-to-hide-keyboard-in-swift-on-pressing-return-key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
    }
    
    //Reference: only digits in UITextField
    //https://stackoverflow.com/questions/31363216/set-the-maximum-character-length-of-a-uitextfield-in-swift
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var result = true
        
        if (string.count > 0){
            let limitSet = NSCharacterSet(charactersIn: "0123456789.").inverted
            let replacementStringIsLegal = string.rangeOfCharacter(from: limitSet) == nil
            result = replacementStringIsLegal
        }
        
        return result
    }
    
    func updatePrice(){
        
        var original:Double = 0.0
        var discount:Double = 0.0
        var tax:Double = 0.0
        var exchangeRate:Double = 1000.0
        
        if(opText.text != nil){
            
            if(Double(opText.text!) != nil){
                
                if(opText.text!.count > 10){
                    
                    opText.text = String(opText.text!.prefix(10))
                }
                original = Double(opText.text!)!
            }
        }

        if(dcText.text != nil){
            
            if(Double(dcText.text!) != nil){
                
                if(dcText.text!.count > 10){
                    
                    dcText.text = String(dcText.text!.prefix(10))
                }
                discount = Double(dcText.text!)!
                discount /= 100.0
            }
        }

        
        if(stText.text != nil){
            
            if(Double(stText.text!) != nil){
                
                if(stText.text!.count > 10){
                    
                    stText.text = String(stText.text!.prefix(10))
                }
                tax = Double(stText.text!)!
                tax = 1 + (tax / 100.0)
            }
        }

        if(erText.text != nil){

            if(Double(erText.text!) != nil){
                
                if(erText.text!.count > 8){
                    
                    erText.text = String(erText.text!.prefix(8))
                }
                exchangeRate = Double(erText.text!)!
            }
        }

        if(original > 0 && discount > 0 && tax > 0){
            
            let finalPrice = (original * (1 - discount)) * tax
            let dispPrice:String
            
            if(finalPrice > 0){
                
                if(lang == "ENG"){
                 
                    dispPrice = "$\(String(format: "%.2f", finalPrice))"
                }
                else{
                    
                    let finalPriceER = finalPrice * exchangeRate
                    dispPrice = "₩\(String(format: "%.2f", finalPriceER))"
                }
                
            }
            else{
                
                if(lang == "ENG"){
                    
                    dispPrice = "$0.00"
                }
                else{
                    
                    dispPrice = "₩0.00"
                }
            }
            fpText.text = dispPrice
            print(dispPrice)
        }
        else{
            
            if(lang == "ENG"){
                
                fpText.text = "$0.00"
            }
            else{
                
                fpText.text = "₩0.00"
            }
        }
    }
}
