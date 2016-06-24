//
//  ViewController.swift
//  BrickBreaker
//
//  Created by Kristin Kamenar on 6/23/16.
//  Copyright © 2016 Kristin Kamenar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var count = 10
    var allBricks : [UIView] = []
    var allItems : [UIView] = []
    
    //ball, paddle, and boundary
    var ball : UIView?
    var paddle : UIView?
    var boundary : UIView?
    
    @IBOutlet weak var livesLabel: UILabel!
    var livesLeft = 3
    
    @IBOutlet weak var levelLabel: UILabel!
    var level = 1
    
    var ballSpeed : CGFloat = 0.2
    
    
    var dynamicAnimator : UIDynamicAnimator!
    var pushBehavior : UIPushBehavior!
    
    //define dynamic behavior for ball, paddle and brick
    var ballDynamicBehavior : UIDynamicItemBehavior!
    var paddleDynamicBehavior : UIDynamicItemBehavior!
    var brickDynamicBehavior : UIDynamicItemBehavior!
    var boundaryDynamicBehavior : UIDynamicItemBehavior!

    
    //define collision behavior
    var collisionBehavior : UICollisionBehavior!

    
    @IBOutlet weak var playButton: UIButton!

    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        //round the corners of the play button
        playButton.layer.cornerRadius = 8
        
        //add a shadow around the play button
        playButton.layer.shadowColor = UIColor.darkGrayColor().CGColor
        playButton.layer.shadowOffset = CGSizeMake(5, 5)
        playButton.layer.shadowRadius = 5
        playButton.layer.shadowOpacity = 1.0
        
        //call 100% background class
        self.view.addBackground()
        


    }

    //MARK: -playNewGameButton
    @IBAction func playNewGameButton(sender: UIButton) {
        
        //remove button
        playButton.removeFromSuperview()
        gameSetUp()
        
    }
    
    //MARK: -gameSetUp
    func gameSetUp()
    {
        
        count = 10
    
        livesLabel.text = "Lives remaining: \(livesLeft)"
        levelLabel.text = "Level: \(level)   "
        
        //lifeCounterCheater = 30
        
        //make sure brick array is empty
        allBricks.removeAll()
        allItems.removeAll()
        
        //create bottom boundary
        boundary = UIView(frame: CGRect(x: 0, y: view.frame.height - 100, width: view.frame.width, height: 100))
        view.addSubview(boundary!)
        
        allItems.append(boundary!)
        
        //create bricks
        let frameWidth = view.frame.width
        let brickWidth = (Int)(frameWidth - 30)/5
        let brickHeight = 20
        var currentX = 10
        var currentY = 100
        var x = 1
        var brick : UIView?
        
        //create two rows
        for _ in 1...2
        {
            //create five columns
            for _ in 1...5
            {

                brick = UIView(frame: CGRect(x: currentX, y: currentY, width: brickWidth, height: brickHeight))
                brick!.backgroundColor = UIColor.orangeColor()
                allBricks.append(brick!)
                allItems.append(brick!)
                currentX += (brickWidth + 5)
                x += 1
            }
        
            currentX = 10
            currentY += (brickHeight + 30)
        }
    
        for eachBrick in allBricks
        {
            view.addSubview(eachBrick)
            eachBrick.tag = 0
        }
        
        
        //create paddle
        paddle = UIView(frame: CGRect(x: view.center.x, y: view.center.y + 100, width: 80, height: 15))
        paddle!.layer.cornerRadius = 5
        paddle!.backgroundColor = UIColor.darkGrayColor()
        //paddle!.backgroundColor = UIColor(red: 221/255, green: 225/255, blue: 58/255, alpha: 1.0)
        view.addSubview(paddle!)
        allItems.append(paddle!)
    
        
        
        //create ball
        ball = UIView(frame: CGRect(x: view.center.x/2, y: view.center.y/2, width: 20, height: 20))
        ball!.layer.cornerRadius = 10
        ball!.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(ball!)
        allItems.append(ball!)
        
        if level%2 == 0
        {
            ball!.backgroundColor = UIColor.greenColor()
        }
        
        
        playGame()
        
    }
    
    //MARK: -playGame
    //add behaviors and animation
    func playGame()
    {
        
        //set up dynamicAnimator
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        //set up pushBehavior; start motion of ball
        pushBehavior = UIPushBehavior(items: [ball!], mode: UIPushBehaviorMode.Instantaneous)
        
        //set direction
        
        
        //random Double to set random direction for ball
        let random1 = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        let random2 = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        
        pushBehavior.pushDirection = CGVectorMake(random1, random2)
        
        //make ball active
        pushBehavior.active = true
        
        //set force
        pushBehavior.magnitude = ballSpeed
        
        //add to dynamicAnimator
        dynamicAnimator.addBehavior(pushBehavior)
        
        //define dynamic behavior for the paddle
        paddleDynamicBehavior = UIDynamicItemBehavior(items: [paddle!])
        paddleDynamicBehavior.allowsRotation = false
        paddleDynamicBehavior.density = 1000.0
        dynamicAnimator.addBehavior(paddleDynamicBehavior)

        //define dynamic behavior for the boundary
        boundaryDynamicBehavior = UIDynamicItemBehavior(items: [boundary!])
        boundaryDynamicBehavior.allowsRotation = false
        boundaryDynamicBehavior.density = 1000.0
        dynamicAnimator.addBehavior(boundaryDynamicBehavior)
        
        
        //define dynamic behavior for the ball
        ballDynamicBehavior = UIDynamicItemBehavior(items: [ball!])
        ballDynamicBehavior.allowsRotation = false
        ballDynamicBehavior.elasticity = 1.0
        ballDynamicBehavior.friction = 0.0
        ballDynamicBehavior.resistance = 0.0
        dynamicAnimator.addBehavior(ballDynamicBehavior)
        
        //define dynamic behavior for the bricks
        //brackets around allBricks not necessary since it is already an array
        brickDynamicBehavior = UIDynamicItemBehavior(items: allBricks)
        brickDynamicBehavior.allowsRotation = false
        brickDynamicBehavior.density = 10000.0
        brickDynamicBehavior.resistance = 100.0
        dynamicAnimator.addBehavior(brickDynamicBehavior)
        
        //Define collision behavior
        //add ball, paddle, and brick into an allItems array; define what happens when they collide
        collisionBehavior = UICollisionBehavior(items: allItems)
        
        //type of edges that participate in collision
        collisionBehavior.collisionMode = UICollisionBehaviorMode.Everything
        
        //define collision behavior for the edges of device
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        
        dynamicAnimator.addBehavior(collisionBehavior)
        
        collisionBehavior.collisionDelegate = self
        
        
    }
 

    
    //MARK: -collisionBehavior
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem) {
        
        for brick in allBricks
        {
        
            if (item1.isEqual(ball) && item2.isEqual(brick)) || (item1.isEqual(brick) && item2.isEqual(ball))
            {
                if level%2 == 1
                {
                    //remove collision behavior from brick
                    collisionBehavior.removeItem(brick)
                    
                    //remove brick from play
                    brick.removeFromSuperview()
                    
                    count -= 1
                    
                }
                
                else if level%2 == 0
                {
                    if brick.tag == 0
                    {
                        //brick.backgroundColor = UIColor.purpleColor()
                        brick.backgroundColor = UIColor(red: 219/255, green: 113/255, blue: 88/255, alpha: 1.0)
                        brick.tag = 1
                    }
                    
                    else if brick.tag == 1
                    {
                    
                    //remove collision behavior from brick
                    collisionBehavior.removeItem(brick)
                    
                    //remove brick from play
                    brick.removeFromSuperview()

                    count -= 1
                }
                }
                
                
            }
        }
            
             if (item1.isEqual(boundary) && item2.isEqual(ball)) || (item1.isEqual(ball) && item2.isEqual(boundary))
            {
                pushBehavior.magnitude = 0.0
                
                //print("edge reached")
                livesLeft -= 1
                //lifeCounterCheater -= 1
                //print(livesLeft)
                livesLabel.text = "Lives Remaining: \(livesLeft)"
    
                //make ball inactive
                collisionBehavior.removeItem(ball!)
                ball!.removeFromSuperview()
                
                
                if livesLeft == 0
                {
                    gameOver()
                }
                
                else if livesLeft > 0
                {
                    
                    if livesLeft == 1
                    {
                    let myAlert = UIAlertController(title: "Life Lost", message: "You have \(livesLeft) life left.", preferredStyle: UIAlertControllerStyle.Alert)
                        myAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: {(alert: UIAlertAction!) in
                            
                            //make ball active
                            
                            //ball!.frame.y = view.frame.center.y
                            self.ball!.center = self.view.center
                            self.collisionBehavior.addItem(self.ball!)
                            self.view.addSubview(self.ball!)
                            self.dynamicAnimator.updateItemUsingCurrentState(self.ball!)
                            
                        }))
                        presentViewController(myAlert, animated: true, completion: nil)
                    }
                    
                        
                    
                    
                    else
                    {
                    
                    let myAlert = UIAlertController(title: "Life Lost", message: "You have \(livesLeft) lives left.", preferredStyle: UIAlertControllerStyle.Alert)
                    myAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: {(alert: UIAlertAction!) in
                    
                        //make ball active
                        
                        //ball!.frame.y = view.frame.center.y
                        self.ball!.center = self.view.center
                        self.collisionBehavior.addItem(self.ball!)
                        self.view.addSubview(self.ball!)
                        self.dynamicAnimator.updateItemUsingCurrentState(self.ball!)

                    }))
                    
                
                    presentViewController(myAlert, animated: true, completion: nil)
                    }
                }
        
        }
        
            
            if count == 0
            {
                win()
            }
    
    }
    
    //MARK: -gameOver
    func gameOver()
    {
        
        //make ball inactive
        collisionBehavior.removeItem(ball!)
        ball!.removeFromSuperview()
        
        //remove paddle
        collisionBehavior.removeItem(paddle!)
        paddle!.removeFromSuperview()
        
        //remove bricks
        for brick in allBricks
        {
            collisionBehavior.removeItem(brick)
            brick.removeFromSuperview()
        }
        
        
        let myAlert = UIAlertController(title: "You Lost!", message: "Would you like to play again?", preferredStyle: UIAlertControllerStyle.Alert)
    
        
        myAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {(alert: UIAlertAction!) in
            
            self.livesLeft = 3
            self.level = 1
            self.gameSetUp()
            
        }))
        
        myAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        
        presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    func win()
    {
        
        //make ball inactive
        collisionBehavior.removeItem(ball!)
        ball!.removeFromSuperview()
        
        //remove paddle
        collisionBehavior.removeItem(paddle!)
        paddle!.removeFromSuperview()
        
        //remove bricks
        for brick in allBricks
        {
            collisionBehavior.removeItem(brick)
            brick.removeFromSuperview()
        }


        
        if level%2 == 1
        {
            
            let myAlert = UIAlertController(title: "Level Complete!", message: "Prepare for Level \(level + 1)", preferredStyle: UIAlertControllerStyle.Alert)
            myAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: {(action) -> Void in
                
                self.gameSetUp()
                
            }))
            presentViewController(myAlert, animated: true, completion: nil)
            
            
        }
        
        else if level%2 == 0
        {
//            //make ball inactive
//            collisionBehavior.removeItem(ball!)
//            ball!.removeFromSuperview()
//            
//            //remove paddle
//            collisionBehavior.removeItem(paddle!)
//            paddle!.removeFromSuperview()
//        
//            //remove bricks
//            for brick in allBricks
//            {
//                collisionBehavior.removeItem(brick)
//                brick.removeFromSuperview()
//            }
        
                let myAlert = UIAlertController(title: "You Win!", message: "Speed Increasing. Prepare for Level \(level + 1)", preferredStyle: UIAlertControllerStyle.Alert)
                
                myAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: {(action) -> Void in
                    
                    self.ballSpeed += 0.05
                    self.gameSetUp()

                }))
        
            
            presentViewController(myAlert, animated: true, completion: nil)
            
        }
        
        //one more level
        level += 1
        

        
    }
    
    //MARK: -paddleDrag
    @IBAction func paddleDrag(sender: UIPanGestureRecognizer) {
        
        //find the horizontal location of the drag
        let xLocation = sender.locationInView(view).x
        
        //find the vertical location of the paddle; this will stay constant
        let yLocation = paddle!.center.y
        
        
        //set the  location of the paddle
        paddle!.center = CGPointMake(xLocation, yLocation)
        
        //app gets "glitchy" if you don't update
        dynamicAnimator.updateItemUsingCurrentState(paddle!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// 100% background
//thank you stackoverflow!
extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.mainScreen().bounds.size.width
        let height = UIScreen.mainScreen().bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRectMake(0, 0, width, height))
        imageViewBackground.image = UIImage(named: "orange_bg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubviewToBack(imageViewBackground)
    }}

