//
//  ScoreNode.swift
//  v0
//
//  Created by nju on 2017/6/4.
//  Copyright © 2017年 nju. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverPanel: SKSpriteNode{
    var bgClr: UIColor = UIColor(red : 0xBA/255, green : 0xAC/255, blue : 0xA0/255, alpha : 0.8)
    
    var txtClr:UIColor=UIColor(red : 0xFC/255, green : 0xF7/255, blue : 0xF0/255, alpha : 1)
    var fontSz:CGFloat=30.0
    var scoreLabel = SKLabelNode()
    let gameOverLabel = SKLabelNode()
    let shareLabel = SKLabelNode()
    
    var panel = SKShapeNode(rectOf: CGSize(width: 300,height: 200))//尺寸
    var shareButton = SKShapeNode(rectOf: CGSize(width: 80, height:40))
    
    var score : Int=0/*{
     get{
     return self.score
     }
     set{
     self.score=newValue
     label.text = name! + ": \(score)"
     
     }
     }*/
    
    func initUI(number: Int){
        self.score=number
        scoreLabel.text = "Score: \(self.score)"
        scoreLabel.fontColor=txtClr
        scoreLabel.fontSize = fontSz
        scoreLabel.fontName="HelveticaNeue-Bold"
        panel.fillColor=bgClr
        panel.strokeColor=bgClr
        scoreLabel.position=CGPoint(x:0, y:0)
        
        
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontColor=txtClr
        gameOverLabel.fontSize = fontSz
        gameOverLabel.fontName="HelveticaNeue-Bold"
        //panel.fillColor=bgClr
        //panel.strokeColor=bgClr
        gameOverLabel.position=CGPoint(x:0, y:panel.frame.size.height*0.25)
        
        shareLabel.text = "Touch to try again"
        shareLabel.fontColor=txtClr
        shareLabel.fontSize = fontSz
        shareLabel.fontName="HelveticaNeue-Bold"
        //panel.fillColor=UIColor(red : 120/255, green : 220/255, blue : 50/255, alpha : 1)
        //panel.strokeColor=UIColor(red : 120/255, green : 220/255, blue : 50/255, alpha : 1)
        shareLabel.position=CGPoint(x:0, y:-panel.frame.size.height*0.3)
        
        
        panel.addChild(scoreLabel)
        panel.addChild(gameOverLabel)
        panel.addChild(shareLabel)
        self.addChild(panel)
    }
    
    func setScore(number: Int){
        self.score=number
        scoreLabel.text = "Score: \(self.score)"
        
        }
    

    
}
