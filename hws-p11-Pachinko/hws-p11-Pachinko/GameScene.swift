//
//  GameScene.swift
//  hws-p11-Pachinko
//
//  Created by Terry Kuo on 2021/9/11.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384) //center of landscape ipad
        background.blendMode = .replace
        background.zPosition = -1 //put it behind everything
        addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let box = SKSpriteNode(color: .red, size: CGSize(width: 64, height: 64))
            box.position = location
            addChild(box)
        }
    }
}
