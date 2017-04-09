//
//  Player.swift
//  Perception
//
//  Created by Ryan Anderson on 4/9/17.
//  Copyright © 2017 Ryan Anderson. All rights reserved.
//

import Foundation
import GameplayKit

class Player: SKSpriteNode {
    
    weak var gameScene: GameScene?
    let gravity: CGFloat = 620
    let jumpInitialVelocity: CGFloat = 450
    let horizontalSpeed: CGFloat = 200
    var velocity = CGVector(dx: 0, dy: 0)
    var previousPosition: CGPoint!
    var jumping = false
    var canJump = false
     //Input variables
    var leftMotion = (pressed: false, active: false)
    var rightMotion = (pressed: false, active: false)
    
    /* Support for NSKeyedArchiver (loading objects from SK Scene Editor */
    required init?(coder aDecoder: NSCoder) {
        /* Call parent initializer e.g. SKSpriteNode */
        super.init(coder: aDecoder)
        previousPosition = self.position
    }
    
    func update(deltaTime dt: CGFloat) {
        if let gameScene = gameScene {
            orientationSpecificUpdates(deltaTime: dt, gameScene: gameScene)
            self.previousPosition = self.position
            self.position.x += velocity.dx * dt
            self.position.y += velocity.dy * dt
            
            // YAY PHYSICS!
            for platform in gameScene.platforms {
                if self.intersects(platform) {
                    if testAboveOrBelow(otherSprite: platform, playerPosition: previousPosition) {
                        // Player hit from either top or the bottom
                        velocity.dy = 0
                        if previousPosition.y > platform.position.y {
                            // Hit from top
                            position.y = platform.position.y + platform.size.height/2 + self.size.height/2
                            if gameScene.currentOrientation == .one { canJump = true }
                        } else {
                            // Hit from bottom
                            position.y = platform.position.y - platform.size.height/2 - self.size.height/2
                            if gameScene.currentOrientation == .three { canJump = true }
                        }
                    } else {
                        // Player hit from the left or right side
                        velocity.dx = 0
                        if previousPosition.x > platform.position.x {
                            // Hit from the right
                            position.x = platform.position.x + platform.size.width/2 + self.size.width/2
                            if gameScene.currentOrientation == .four { canJump = true }

                        } else {
                            /// Hit from the left
                            position.x = platform.position.x - platform.size.width/2 - self.size.width/2
                            if gameScene.currentOrientation == .two { canJump = true }

                        }
                    }
                }
            }
        }
    }
    
    func orientationSpecificUpdates(deltaTime dt: CGFloat, gameScene: GameScene) {
        // Updates gravity and responds to user input in different ways depending on
        // the current level orientation
        switch gameScene.currentOrientation {
        // Gravity down
        case .one:
            velocity.dy -= gravity * dt
            if rightMotion.active {
                velocity.dx = horizontalSpeed
            } else if leftMotion.active {
                velocity.dx = -horizontalSpeed
            } else {
                velocity.dx = 0
            }
            if jumping && canJump {
                jumping = false
                canJump = false
                velocity.dy = jumpInitialVelocity
            }
        //Gravity to the right
        case .two:
            print("grav right")
            velocity.dx += gravity * dt
            if rightMotion.active {
                velocity.dy = horizontalSpeed
            } else if leftMotion.active {
                velocity.dy = -horizontalSpeed
            } else {
                velocity.dy = 0
            }
            if jumping && canJump {
                jumping = false
                canJump = false
                velocity.dx = -jumpInitialVelocity
            }
        //Gravity up
        case .three:
            velocity.dy += gravity * dt
            if rightMotion.active {
                velocity.dx = -horizontalSpeed
            } else if leftMotion.active {
                velocity.dx = horizontalSpeed
            } else {
                velocity.dx = 0
            }
            if jumping && canJump {
                jumping = false
                canJump = false
                velocity.dy = -jumpInitialVelocity
            }
            
        //Gravity left
        case .four:
            print("grav left dx=\(velocity.dx)")
            velocity.dx -= gravity * dt
            if rightMotion.active {
                velocity.dy = -horizontalSpeed
            } else if leftMotion.active {
                velocity.dy = horizontalSpeed
            } else {
                velocity.dy = 0
            }
            if jumping && canJump {
                jumping = false
                canJump = false
                velocity.dx = jumpInitialVelocity
            }

        }
    }
    
    func testAboveOrBelow(otherSprite other: SKSpriteNode, playerPosition: CGPoint) -> Bool {
        // r,l,R,and L represent coordinates
        // l = player's left edge, r = player's right edge
        // L = other's left edge, R = other's right edge
        // if l < L and r < L
        // or
        // if r > R and l > R
        // are the two cases in which false is returned. True otherwise
        let l = playerPosition.x - size.width/2
        let r = playerPosition.x + size.width/2
        let L = other.position.x - other.size.width/2 + CGFloat(5) // tiny arbitrary numbers added to make
        let R = other.position.x + other.size.width/2 - CGFloat(5) // it slightly easier to fail the test.
                        // The result is top/bottom collisions look like they should be top/bottom collisions.
        if  (l <= L && r <= L) || (l >= R && r >= R) {
            return false
        } else {
            return true
        }
    }
    
    
    func keyDown(withKeyCode keyCode: UInt16) {
        switch keyCode {
        case Keycode.leftArrow:
            leftMotion.pressed = true
            if rightMotion.pressed == false { leftMotion.active = true }
        case Keycode.rightArrow:
            rightMotion.pressed = true
            if leftMotion.pressed == false { rightMotion.active = true }
        case Keycode.upArrow:
            if canJump {
                jumping = true // Do later in update
            }
        default: break
        }
//        print("rm \(rightMotion)")
//        print("lm \(leftMotion)")

    }
    
    func keyUp(withKeyCode keyCode: UInt16) {
        switch keyCode {
        case Keycode.leftArrow:
            leftMotion.pressed = false
            leftMotion.active = false
            if rightMotion.pressed == true { rightMotion.active = true }
        case Keycode.rightArrow:
            rightMotion.pressed = false
            rightMotion.active = false
            if leftMotion.pressed == true { leftMotion.active = true }
        default: break
        }
//        print("rm \(rightMotion)")
//        print("lm \(leftMotion)")

    }
    

}
