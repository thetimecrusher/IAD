//
//  instructions.swift
//  FawcettKeithGameAppGold
//
//  Created by Keith Fawcett on 7/28/16.
//  Copyright © 2016 Keith Fawcett. All rights reserved.
//

import SpriteKit
import AVFoundation


class instructions: SKScene {
  
  var background = SKSpriteNode(imageNamed: "BG")
  
  override func didMoveToView(view: SKView) {
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
      if name == "back"{
        let myScene = MainMenuScreen(fileNamed: "MainMenuScreen")
        myScene!.scaleMode = scaleMode
        let reveal = SKTransition.fadeWithDuration(1.0)
        self.view?.presentScene(myScene!, transition: reveal)
      }
    }
  }
  
}
