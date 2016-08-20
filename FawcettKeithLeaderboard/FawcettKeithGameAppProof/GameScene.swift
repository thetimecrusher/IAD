//
//  GameScene.swift
//  FawcettKeithGameAppImmersiveElement
//
//  Created by Keith Fawcett on 6/29/16.
//  Copyright (c) 2016 Keith Fawcett. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit

//create the masks for the different collision elements
let floorMask:UInt32 = 0x1 << 0
let fruitMask:UInt32 = 0x1 << 1
let bombMask:UInt32 = 0x1 << 2


class GameScene: SKScene, SKPhysicsContactDelegate, GKGameCenterControllerDelegate  {
  
  
  //create the variable for the launch emitters
  var launcher1: SKEmitterNode!
  var launcher2: SKEmitterNode!
  var launcher3: SKEmitterNode!
  var launcher4: SKEmitterNode!
  
  //create the variables for the hearts
  var heart1: SKSpriteNode!
  var heart2: SKSpriteNode!
  var heart3: SKSpriteNode!
  
  //create explotion variable
  var explotion: SKSpriteNode!
  
  //create animated atlas variables
  var textureAtlas = SKTextureAtlas()
  var textureArray = [SKTexture]()
  
  //connect win loss menu labels to code
  var winLoss: SKLabelNode!
  var playAgain: SKLabelNode!
  var finalScoreLabel: SKLabelNode!
  var menu: SKLabelNode!
  var submitScoreLabel: SKLabelNode!
  var continueLabel: SKLabelNode!
  
  
  //is the game currently being played
  var playingGame = true
  
  //create the score and multiplier labels
  var scoreLabel: SKLabelNode!
  var multiplierLabel: SKLabelNode!
  var timerLabel: SKLabelNode!
  var starsLabel: SKLabelNode!
  
  //create the variables to keep track of the score
  var score = 0
  var multiplier = 1
  var fruitInARow = 0
  
  var interval = 2.0
  
  //number of lifes and stars variable
  var lifes = 3
  
  var stars = 5
  //countdown timer
  var time = 60
  var timer = NSTimer()
  
  var sounds = []
  
  //creates background variable with the BG as it's image
  var background = SKSpriteNode(imageNamed: "BG")
  
  
  
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
      
      //scale the scene to the device size
     // scene!.scaleMode = SKSceneScaleMode.Fill
      
      //preload the sound elements
      do {
         sounds = ["bomb", "beep","powerup","powerdown"]
        for sound in sounds{
          let player = try AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(sound as? String, ofType: "wav")!))
          player.prepareToPlay()
        }
      }catch{
        
      }
      self.physicsWorld.contactDelegate = self

      
      //centers the background
      background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
      //pushes the backqround behind the sprits
      background.zPosition = -1
      //adds the background to the scene
      addChild(background)
      
      //setup the score and multiplier labels
      scoreLabel = self.childNodeWithName("ScoreLabel") as! SKLabelNode
      multiplierLabel = self.childNodeWithName("Multiplier") as! SKLabelNode
      multiplierLabel.text = "X" + String(multiplier)
      timerLabel = self.childNodeWithName("timeLabel") as! SKLabelNode
      timerLabel.text = String(time)
      starsLabel = self.childNodeWithName("starsLabel") as! SKLabelNode
      starsLabel.text = String(stars)
      
      //setup the ending labels and hid them
      winLoss = self.childNodeWithName("winLoss") as! SKLabelNode
      winLoss.hidden = true
      
      finalScoreLabel = self.childNodeWithName("finalScoreLabel") as! SKLabelNode
      finalScoreLabel.hidden = true
      
      playAgain = self.childNodeWithName("playAgain") as! SKLabelNode
      playAgain.hidden = true
      
      menu = self.childNodeWithName("menu") as! SKLabelNode
      menu.hidden = true
      
      submitScoreLabel = self.childNodeWithName("SubmitScoreLabel") as! SKLabelNode
      submitScoreLabel.hidden = true
      
      continueLabel = self.childNodeWithName("continueLabel") as! SKLabelNode
      continueLabel.text = "Continue for 5 stars"
      continueLabel.hidden = true
     
      //connect the launchers in code with the scene
      launcher1 = self.childNodeWithName("launcher1") as! SKEmitterNode
      launcher2 = self.childNodeWithName("launcher2") as! SKEmitterNode
      launcher3 = self.childNodeWithName("launcher3") as! SKEmitterNode
      launcher4 = self.childNodeWithName("launcher4") as! SKEmitterNode
      
      //connect the hearts in code with the scene
      heart1 = self.childNodeWithName("heart1") as! SKSpriteNode
      heart2 = self.childNodeWithName("heart2") as! SKSpriteNode
      heart3 = self.childNodeWithName("heart3") as! SKSpriteNode
      
      
      textureAtlas = SKTextureAtlas(named: "explotion")
      
      //order the textureAtlas
      for i in 1...textureAtlas.textureNames.count{
        let name = "\(i).png"
        textureArray.append(SKTexture(imageNamed: name))
        
      }
    //start the explotion at the first image
      explotion = SKSpriteNode(imageNamed: textureAtlas.textureNames[0] )
      
      //set the size and add it to the screen
      explotion.size = CGSize(width: 170, height: 170)
      explotion.position = CGPoint(x: -50, y:0)
      self.addChild(explotion)
      
      
      //run the timer
      runTimer()
      //create the countdown timer
      timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
    }
  //subtract from the timerLabel 1
  func update() {
    time -= 1
      timerLabel.text = String(time)
    }
  
  //create a timer that fires the items
  func runTimer(){
    _ = NSTimer.scheduledTimerWithTimeInterval(interval, target: self, selector: #selector(GameScene.launchItem), userInfo: nil, repeats: false)
  }
  
  
  
  //launch the items function to reset the timer and launch a item
  func launchItem(){
    if scene?.view?.paused == false{
    runTimer()
    }
    interval = ((Double(arc4random_uniform(21))/9))
    
    //connect the sprits in code with the scene
    let bomb: SKSpriteNode = SKScene(fileNamed: "Bomb")!.childNodeWithName("bomb")! as! SKSpriteNode
    let watermelon: SKSpriteNode = SKScene(fileNamed: "Watermelon")!.childNodeWithName("watermelon")! as! SKSpriteNode
    let banana: SKSpriteNode = SKScene(fileNamed: "Banana")!.childNodeWithName("banana")! as! SKSpriteNode
    let pear: SKSpriteNode = SKScene(fileNamed: "Pear")!.childNodeWithName("pear")! as! SKSpriteNode
    let apple: SKSpriteNode = SKScene(fileNamed: "Apple")!.childNodeWithName("apple")! as! SKSpriteNode
    let star: SKSpriteNode = SKScene(fileNamed: "Star")!.childNodeWithName("star")! as! SKSpriteNode
    
    //generate a random number to choose the item launched
    let itemSelect = arc4random_uniform(26)
    
    //create the item variable
    var item = bomb
    
   
    if itemSelect <= 4{ //if the number was less then or equal to 9 launch a bomb
      item = bomb
    }else if itemSelect <= 9{ //if the number was less then or equal to 19 launch a watermelon
      item = watermelon
    }else if itemSelect <= 14{ //if the number was less then or equal to 29 launch a banana
      item = banana
    }else if itemSelect <= 19{ //if the number was less then or equal to 39 launch a pear
      item = pear
    }else if itemSelect <= 24{ //if the number was less then or equal to 49 launch a apple
      item = apple
    }else if itemSelect == 25{ //if the number is 50 launch a star
      item = star
    }
    
    
    item.removeFromParent()
    self.addChild(item)
    item.zPosition = 0
    
    //generate random number to pick which emmiter the item will launch from
    let chooseLauncher = arc4random_uniform(4)
    
    if chooseLauncher == 0{ //if it's a 0 launch from launcher 1
    item.position = launcher1.position
    }else if chooseLauncher == 1{ //if it's a 1 launch from launcher 2
      item.position = launcher2.position
    }else if chooseLauncher == 2{ //if it's a 2 launch from launcher 3
      item.position = launcher3.position
    }else if chooseLauncher == 3{ //if it's a 3 launch from launcher 4
      item.position = launcher4.position
    }
    //launch at a random x between -200 and 200 and a y of 400
    item.physicsBody?.applyImpulse(CGVectorMake((CGFloat(arc4random_uniform(5)) * 100) - 200, 400))
    
    item.physicsBody?.collisionBitMask = floorMask | fruitMask | bombMask
    item.physicsBody?.contactTestBitMask = (item.physicsBody?.collisionBitMask)!
    
  }
  
 
  
  
  //when a touch begins
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
      let touch:UITouch = touches.first! as UITouch
      let positionInScene = touch.locationInNode(self)
      let touchedNode = self.nodeAtPoint(positionInScene)
      
      //let name be the touched nodes name
      if let name = touchedNode.name
      {
        //if it's one of the fruits and we are playing the game
        if name == "pear" && playingGame || name == "apple" && playingGame || name == "watermelon" && playingGame || name == "banana" && playingGame || name == "star" && playingGame
        {
          //play the beep sound
          self.runAction(SKAction.playSoundFileNamed(sounds[1] as! String, waitForCompletion: true))
          if name == "pear"{ //if a pear is taped add 5 points to the score
            score += 5 * multiplier
            fruitInARow += 1
        }else if name == "apple"{ //if a apple is taped add 10 points to the score
            score += 10 * multiplier
            fruitInARow += 1
          }else if name == "watermelon"{ //if a watermelon is taped add 15 points to the score
            score += 15 * multiplier
            fruitInARow += 1
          }else if name == "banana"{ //if a banana is taped add 20 points to the score
            score += 20 * multiplier
            fruitInARow += 1
          }else if name == "star"{ //if a star is taped add
            if fruitInARow < 5{
              fruitInARow = 5 //if fruit is over 14 set multiplier to 4
            }else if fruitInARow < 15{
              fruitInARow = 15 //if fruit is over 4 set multiplier to 2
            }else if fruitInARow < 40{
              fruitInARow = 40 //if fruit is over 4 set multiplier to 2
            }
            stars += 1
            starsLabel.text = String(stars)
          }
          
            
            
          //if fruitInARow is 5, 15, or 40
          if fruitInARow == 5 || fruitInARow == 15 || fruitInARow == 40{
            //play the powerup sound
            self.runAction(SKAction.playSoundFileNamed(sounds[2] as! String, waitForCompletion: true))
          }
          //remove the taped fruit
          touchedNode.removeFromParent()
        }
          //if it's the bomb and we are playing the game
        else if name == "bomb" && playingGame
        {
          //subtract 100 from score and reset the multiplier
          lifes -= 1
          score -= 100
          fruitInARow = 0
          multiplier = 1
          
          //run the explotion
          explotion.position = CGPoint(x: touchedNode.position.x, y: touchedNode.position.y)
          explotion.runAction(SKAction.animateWithTextures(textureArray, timePerFrame: 0.01))
          
          
          if lifes == 2{ //if you have 2 lives
            heart3.hidden = true //hide the 3 heart
          }else if lifes == 1{ //if you have 1 life
            heart2.hidden = true //hide the 2 heart
          }else if lifes == 0 { //if you have 0 lifes
            heart1.hidden = true //hide the 1 heart
            //display the end game labels and stop the timer
            winLoss.hidden = false
            winLoss.text = "You loss"
            playAgain.hidden = false
            menu.hidden = false
            playingGame = false
            timer.invalidate()
            //if player has at least 5 stars
            if stars > 4{
              continueLabel.hidden = false //display the continue label
            }
          }
          //play the bomb sound
          self.runAction(SKAction.playSoundFileNamed(sounds[0] as! String, waitForCompletion: true))
          touchedNode.removeFromParent()
          //if the pause button is press and we are playing the game
        }else if name == "pause"{
          
          //if it is not paused pause the scene
          if scene?.view?.paused == false{
            scene?.view?.paused = true
            scene?.physicsWorld.speed = 0
            timer.invalidate()
            playingGame = false
            
          //if it is paused unpause the scene
          }else if scene?.view?.paused == true{
           scene?.view?.paused = false
            scene?.physicsWorld.speed = 1
            playingGame = true
            //start the timer again
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
            launchItem()
          }
          //when the playAgain label is pressed
        }else if name == "playAgain"{
          //reset everything to start the game over
          score = 0
          time = 60
          multiplier = 1
          fruitInARow = 0
          lifes = 3
          playingGame = true
          winLoss.hidden = true
          finalScoreLabel.hidden = true
          playAgain.hidden = true
          menu.hidden = true
          submitScoreLabel.hidden = true
          continueLabel.hidden = true
          heart1.hidden = false
          heart2.hidden = false
          heart3.hidden = false
          timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
        }
          //if menu is taped
        else if name == "menu"{
          //go the the menu screen
          let myScene = MainMenuScreen(fileNamed: "MainMenuScreen")
          myScene!.scaleMode = scaleMode
          let reveal = SKTransition.fadeWithDuration(1.0)
          self.view?.presentScene(myScene!, transition: reveal)
        }
          //if the continueLabel is taped
        else if name == "continueLabel"{
          //if player lost their lifes give them an extra one
          if lifes == 0{
            lifes = 1
            heart1.hidden = false
          }
            //otherwise give them an extra 15 seconds
          else{
            time = 15
          }
          //subtrace 5 stars and hide all the menus
          stars -= 5
          starsLabel.text = String(stars)
          playingGame = true
          winLoss.hidden = true
          finalScoreLabel.hidden = true
          playAgain.hidden = true
          menu.hidden = true
          submitScoreLabel.hidden = true
          continueLabel.hidden = true
          timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(UIMenuController.update), userInfo: nil, repeats: true)
        }
        else if name == "SubmitScoreLabel"{
          print("submit hit")
          saveScore(score)
          showLeaderBoard()
        }
    }
  }
  
  
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
      //set the scor lable to the score
      scoreLabel.text = String(score)
      //set the multiplier label to the multiplier adding an x in front of it
      multiplierLabel.text = "X" + String(multiplier)
      if fruitInARow > 39{
        multiplier = 8 //if fruit is over 39 set multiplier to 8
      }else if fruitInARow > 14{
        multiplier = 4 //if fruit is over 14 set multiplier to 4
      }else if fruitInARow > 4{
        multiplier = 2 //if fruit is over 4 set multiplier to 2
      }
      //when the timer runs out
      if time == 0{
        //stop everything display they won and their score
        timer.invalidate()
        winLoss.text = "You win"
        winLoss.hidden = false
        finalScoreLabel.text = "Your score is \(score)"
        finalScoreLabel.hidden = false
        playingGame = false
        playAgain.hidden = false
        menu.hidden = false
        submitScoreLabel.hidden = false
        if stars > 4{
        continueLabel.hidden = false
        }
        
      }
    }

  //when a contact begins
  func didBeginContact(contact: SKPhysicsContact) {
    //check what is hitting what
    let item = (contact.bodyA.categoryBitMask == fruitMask) ? contact.bodyA : contact.bodyB
    let other = (item == contact.bodyA) ? contact.bodyB : contact.bodyA
  
    if other.categoryBitMask == floorMask{
      
      //if a fruit hits the floor
      if item.categoryBitMask == fruitMask && playingGame{
        //if the fruitInARow is over 4
        if fruitInARow > 4{
          //reset the fruitInARow and the multiplier and play the sound
          fruitInARow = 0
          multiplier = 1
          self.runAction(SKAction.playSoundFileNamed(sounds[3] as! String, waitForCompletion: true))
        }else{
          //otherwise just reset the fruitInARow and the multiplier
        fruitInARow = 0
        multiplier = 1
      }
      }
      //remove the item that hit the ground
      item.node?.removeFromParent()
    }
  }

  
  
  //Game Center
  
  
  //create function that saves the score
  func saveScore(score : Int){
    //if the player is logged in
    if GKLocalPlayer.localPlayer().authenticated {
      //set playerScore to the FruitDropLeaderBoard
      let playerScore = GKScore(leaderboardIdentifier: "FuitDropLeaderBoard")
      //set the score to the playerScore value
      playerScore.value = Int64(score)
      //add the scores into the scoreArray
      let scoreArray : [GKScore] = [playerScore]
      //report the scores
      GKScore.reportScores(scoreArray, withCompletionHandler: nil)
      
    }
    
    
  }
  //create function that shows the leaderboard
  func showLeaderBoard(){
    //set viewController to the windows rootViewController
    let viewController = self.view!.window?.rootViewController
    //set gameCneterVC to the GKGameViewController
    let gameCenterVC = GKGameCenterViewController()
    //set gameCenterVC gameCenterDelegate to self
    gameCenterVC.gameCenterDelegate = self
    //present the gameCenterViewController
    viewController?.presentViewController(gameCenterVC, animated: true, completion: nil)
  }
  
  //conform to GKGameCenterControllerDelegate
  func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
    gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    
  }

  
  
  
}

















