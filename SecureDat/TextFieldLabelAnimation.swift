//
//  textFieldLabelAnimation.swift
//  BoredBets
//
//  Created by Markus Notti on 11/25/16.
//  Copyright © 2016 SauceKitchen. All rights reserved.
//

import Foundation
import UIKit

class TextFieldLabelAnimation{
    var field: UITextField
    var label: UILabel
    var labelPositioned: Bool
    init(field: UITextField, label: UILabel){
        self.field = field
        self.label = label
        self.labelPositioned = false
        self.label.isHidden = true
    }
    
    func animateLabelAppear(){
        if(label.isHidden == true){
            self.label.center.y += 25
            label.isHidden = false
            UIView.animate(withDuration: 0.5,
                           animations:{
                            self.label.center.y -= 25
            })
        }
    }
    
    func animateLabelDisappear(){
        if ((field.text?.isEmpty)! || field.text == nil || field.text == "") {
            label.center.y += 25
            label.isHidden = true
        }
    }
}
