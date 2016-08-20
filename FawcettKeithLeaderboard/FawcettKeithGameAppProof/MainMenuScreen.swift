//
//  MainMenuScreen.swift
//  FawcettKeithGameAppGold
//
//  Created by Keith Fawcett on 7/27/16.
//  Copyright © 2016 Keith Fawcett. All rights reserved.
//


import SpriteKit
import AVFoundation
import GameKit


class MainMenuScreen: SKScene, GKGameCenterControllerDelegate {
  
  var background = SKSpriteNode(imageNamed: "BG")
  
  override func didMoveToView(view: SKView) {
    //run authenticatePlayer function
    authenticatePlayer()
    /* Setup your scene here */
    //centers the background
    background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    //pushes the backqround behind the sprits
    background.zPosition = -1
    //adds the background to the scene
    addChild(background)
  }
  

  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    /* Called when a touch begins */
    let touch:UITouch = touches.first! as UITouch
    let positionInScene = touch.locationInNode(self)
    let touchedNode = self.nodeAtPoint(positionInScene)
    
    //let name be the touched nodes name
    if let name = touchedNode.name
    {
      //if it's one of the fruits and we are playing the game
      if name == "playGame"{
        let myScene = GameScene(fileNamed: "GameScene")
        myScene!.scaleMode = scaleMode
        let reveal = SKTransition.fadeWithDuration(1.0)
        self.view?.presentScene(myScene!, transition: reveal)
      }else  if name == "instructions"{
        let myScene = instructions(fileNamed: "instructions")
        myScene!.scaleMode = scaleMode
        let reveal = SKTransition.fadeWithDuration(1.0)
        self.view?.presentScene(myScene!, transition: reveal)
      }else  if name == "credits"{
        let myScene = credits(fileNamed: "credits")
        myScene!.scaleMode = scaleMode
        let reveal = SKTransition.fadeWithDuration(1.0)
        self.view?.presentScene(myScene!, transition: reveal)
      }else if name == "highScoresLabel"{ // if the high score label is taped
        showLeaderBoard() // run the showLeaderBoard function
        
      }
     
    }
  
}
  
  //Game Center
  
  //create function that authenticates if the player is logged into game center
  func authenticatePlayer(){
    //let localPlayer equal the GKLocalPlayers localPlayer
    let localPlayer = GKLocalPlayer.localPlayer()
    //authenticateHandler
    localPlayer.authenticateHandler = {
      (gameCenterView, error) in
      
      if gameCenterView != nil {
        //present the GameCenterView
        self.view!.window?.rootViewController?.presentViewController(gameCenterView!, animated: true, completion: nil)
        
      }
      else {
        //print is the authentication is true or false
        print(GKLocalPlayer.localPlayer().authenticated)
        
      }
      
      
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




















