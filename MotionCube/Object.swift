//
//  Object.swift
//  MotionCube
//
//  Created by Nordine Sayah on 01/10/2018.
//  Copyright © 2018 Nordine Sayah. All rights reserved.
//

import Foundation
import UIKit

class Object : UIView {
    
    var isCircle : Bool?
    let width : CGFloat = 100
    let height : CGFloat = 100
    
    init(x: CGFloat, y: CGFloat) {
        super.init(frame: CGRect(x: x - self.width / 2, y: y - self.height  / 2, width:self.width, height: self.height))
        
        self.backgroundColor = UIColor.random()
        self.isCircle = Bool.random()
        if (self.isCircle!){
            self.layer.cornerRadius = 50
            self.layer.masksToBounds = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
