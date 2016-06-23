//
//  Brick.swift
//  BrickBreaker
//
//  Created by Kristin Kamenar on 6/23/16.
//  Copyright © 2016 Kristin Kamenar. All rights reserved.
//

import UIKit

class Brick: UIView {
    
    var brickX : Int?
    var brickY : Int?
    var brickWidth : Int?
    var brickHeight : Int?
    var brickColor : UIColor

    
    init (x: Int, y: Int, width: Int, height: Int)
    {
        brickX = x
        brickY = y
        brickWidth = width
        brickHeight = height
        brickColor = UIColor.blueColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
