//
//  ScoreNode.swift
//  v0
//
//  Created by nju on 2017/6/4.
//  Copyright © 2017年 nju. All rights reserved.
//

import Foundation
import SpriteKit

class ScoreNode: SKSpriteNode{
    var bgClr: UIColor = UIColor(red : 0xBA/255, green : 0xAC/255, blue : 0xA0/255, alpha : 1)

    var txtClr:UIColor=UIColor(red : 0xFC/255, green : 0xF7/255, blue : 0xF0/255, alpha : 1)
    var fontSz:CGFloat=16.0
    var label = SKLabelNode()
    var title = SKShapeNode(rectOf: CGSize(width: 80,height: 40))//每个小块的宽度
    
    var score : Double=0/*{    //序号0-9 代表方块上面数字2^1-10次方 便于对应各个方块性质数组下标
     get{
        return self.score
        }
     set{
        self.score=newValue
        label.text = name! + ": \(score)"
     
        }
    }*/
    
    func initUI(name:String, number: Double){
        self.score=number
        let uiScore=Int(number)
        label.text = name + ": \(uiScore)"
        label.fontColor=txtClr
        label.fontSize = fontSz
        label.fontName="HelveticaNeue-Bold"
        title.fillColor=bgClr
        title.strokeColor=bgClr
        label.position=CGPoint(x:0, y:-label.frame.size.height*0.5)
        title.addChild(label)
        self.addChild(title)
    }
    
    func setScore(name:String, number: Double){
        self.score=number
        let uiScore=Int(number)
        label.text = name + ": \(uiScore)"
        label.fontColor=txtClr
        label.fontSize = fontSz
        label.fontName="HelveticaNeue-Bold"
        title.fillColor=bgClr
        title.strokeColor=bgClr
    }
  
}
