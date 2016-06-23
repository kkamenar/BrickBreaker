//
//  ViewController.swift
//  BrickBreaker
//
//  Created by Kristin Kamenar on 6/23/16.
//  Copyright © 2016 Kristin Kamenar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var count = 10
    var allBricks : [UIView] = []
    
    
    @IBOutlet weak var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func playNewGameButton(sender: UIButton) {
        
        //remove button
        playButton.removeFromSuperview()
        gameSetUp()
        
    }
    
    func gameSetUp()
    {
        
        //make sure brick array is empty
        allBricks.removeAll()
        
        //create bricks
        let frameWidth = view.frame.width
        let brickWidth = (Int)(frameWidth - 30)/5
        let brickHeight = 20
        var currentX = 10
        var currentY = 50
        var x = 1
        var brick : UIView?
        
        //create two rows
        for _ in 1...2
        {
            //create five columns
            for _ in 1...5
            {

                brick = UIView(frame: CGRect(x: currentX, y: currentY, width: brickWidth, height: brickHeight))
                print("x and y: \(currentX) \(currentY)")
                brick!.backgroundColor = UIColor.blueColor()
                allBricks.append(brick!)
                //view.addSubview(brick)
                currentX += (brickWidth + 5)
                print(x)
                x += 1
            }
        
            currentX = 10
            currentY += (brickHeight + 30)
        }
    
        for eachBrick in allBricks
        {
            view.addSubview(eachBrick)
        }
        
        
        //create paddle
        let paddle = UIView(frame: CGRect(x: view.center.x, y: view.center.y, width: 80, height: 15))
        paddle.layer.cornerRadius = 5
        paddle.backgroundColor = UIColor.blackColor()
        view.addSubview(paddle)
        
        
        //create ball
        let ball = UIView(frame: CGRect(x: view.center.x/2, y: view.center.y/2, width: 20, height: 20))
        ball.layer.cornerRadius = 10
        ball.backgroundColor = UIColor.cyanColor()
        view.addSubview(ball)
        
    }
    
    func playGame()
    {
        
        
    }
    
    func win()
    {
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

