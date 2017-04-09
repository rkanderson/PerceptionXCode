//
//  GameScene.swift
//  Perception
//
//  Created by Ryan Anderson on 4/8/17.
//  Copyright © 2017 Ryan Anderson. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var prevTime: TimeInterval?
    var levelLabel: SKLabelNode!
    var shiftsLabel: SKLabelNode!
    var player: Player!
    var levelNode: SKNode!
    var platformsNode: SKNode!
    var platforms: [SKSpriteNode] {
        return platformsNode.children as! [SKSpriteNode]
    }
    // Describes which way the level is facing. 1=normal, 2=90 degrees ccw, 3=180 ccw, etc
    enum LevelOrientation {
        case one, two, three, four
    }
    var currentOrientation = LevelOrientation.one
    
    override func didMove(to view: SKView) {
        levelLabel = childNode(withName: "//levelLabel") as! SKLabelNode
        shiftsLabel = childNode(withName: "//shiftsLabel") as! SKLabelNode
        player = childNode(withName: "//player") as! Player
        levelNode = childNode(withName: "//levelContainer")
        loadLevel(0);
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override func keyDown(with event: NSEvent) {
        player.keyDown(with: event, levelOrientation: currentOrientation)
    }
    
    override func keyUp(with event: NSEvent) {
        player.keyUp(with: event, levelOrientation: currentOrientation)
    }
    
    func loadLevel(_ index: Int) {
        let lvlStr = "Level" + String(index)
        let path = Bundle.main.path(forResource: lvlStr, ofType: "sks")
        let refNode = SKReferenceNode (url: NSURL (fileURLWithPath: path!) as URL)
        levelNode.addChild(refNode);
        platformsNode = childNode(withName: "//platforms")
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        let dt = CGFloat(currentTime - (prevTime ?? currentTime))
        prevTime = currentTime
        player.update(deltaTime: dt, platforms: platforms)
    }
}
