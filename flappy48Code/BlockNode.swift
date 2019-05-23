//
//  BlockNode.swift
//  Flappy2048
//
//  Created by nju on 2017/5/27.
//  Copyright © 2017年 nju. All rights reserved.
//

import SpriteKit

class BlockNode: SKSpriteNode{
    var bgClrList: [UIColor]=[//2-2048方块背景颜色变化
        UIColor(red : 0xEC/255, green : 0xE4/255, blue : 0xDA/255, alpha : 1),//2
        UIColor(red : 0xED/255, green : 0xDF/255, blue : 0xCA/255, alpha : 1),//4
        UIColor(red : 0xF2/255, green : 0xAF/255, blue : 0x7E/255, alpha : 1),//8
        UIColor(red : 0xF4/255, green : 0x93/255, blue : 0x68/255, alpha : 1),//16
        UIColor(red : 0xF4/255, green : 0x7A/255, blue : 0x63/255, alpha : 1),//32
        UIColor(red : 0xF5/255, green : 0x5B/255, blue : 0x44/255, alpha : 1),//64
        UIColor(red : 0xEC/255, green : 0xCD/255, blue : 0x79/255, alpha : 1),//128
        UIColor(red : 0xEB/255, green : 0xCA/255, blue : 0x6A/255, alpha : 1),//256
        UIColor(red : 0xEB/255, green : 0xC6/255, blue : 0x5D/255, alpha : 1),//512
        UIColor(red : 0xEB/255, green : 0xC3/255, blue : 0x50/255, alpha : 1),//1024
        UIColor(red : 0xEC/255, green : 0xBF/255, blue : 0x44/255, alpha : 1),//2048
        
    ]
    var txtClrList:[UIColor]=[//2-2048字颜色变化
        UIColor(red : 0x7E/255, green : 0x7A/255, blue : 0x72/255, alpha : 1),//2
        UIColor(red : 0x7E/255, green : 0x7A/255, blue : 0x72/255, alpha : 1),//4
        UIColor(red : 0xFF/255, green : 0xFF/255, blue : 0xFF/255, alpha : 1),//8
        UIColor(red : 0xFF/255, green : 0xFF/255, blue : 0xFF/255, alpha : 1),//16
        UIColor(red : 0xFF/255, green : 0xFF/255, blue : 0xFF/255, alpha : 1),//32
        UIColor(red : 0xFF/255, green : 0xFF/255, blue : 0xFF/255, alpha : 1),//64
        UIColor(red : 0xFF/255, green : 0xFF/255, blue : 0xFF/255, alpha : 1),//128
        UIColor(red : 0xFF/255, green : 0xFF/255, blue : 0xFF/255, alpha : 1),//256
        UIColor(red : 0xFF/255, green : 0xFF/255, blue : 0xFF/255, alpha : 1),//512
        UIColor(red : 0xFF/255, green : 0xFF/255, blue : 0xFF/255, alpha : 1),//1024
        UIColor(red : 0xFF/255, green : 0xFF/255, blue : 0xFF/255, alpha : 1),//2048
        
    ]
    
    var fontSzList:[CGFloat]=[//2-2048字体大小
        30.0,//2
        30.0,//4
        30.0,//8
        30.0,//16
        30.0,//32
        30.0,//64
        25.0,//128
        25.0,//256
        25.0,//512
        20.0,//1024
        20.0,//2048
    ]
    //let blockSide : CGFloat = 50
    var label = SKLabelNode()
    var title = SKShapeNode(rectOf: CGSize(width: 50,height: 50))//每个小块的宽度
    
    var blockNo : Int=0/*{    //序号0-9 代表方块上面数字2^1-10次方 便于对应各个方块性质数组下标
        get{
            return self.blockNo
        }
        set{
            self.blockNo=newValue
            label.text = "\(pow(2, (blockNo+1)))"
            label.fontColor=txtClrList[blockNo]
            label.fontSize = fontSzList[blockNo]
            title.fillColor=bgClrList[blockNo]
            title.strokeColor=bgClrList[blockNo]
        }
    }*/
    
    
    func getBlockNo()->Int{
        return self.blockNo
    }
    
    func setBlockNo(newValue:Int){
        self.blockNo=newValue
        label.text = "\(pow(2, (blockNo+1)))"
        label.fontColor=txtClrList[blockNo]
        label.fontSize = fontSzList[blockNo]
        title.fillColor=bgClrList[blockNo]
        title.strokeColor=bgClrList[blockNo]
        
    }
    
    func initUI(number: Int){
        self.blockNo=number
        label.text = "\(pow(2, (blockNo+1)))"
        label.fontColor=txtClrList[blockNo]
        label.fontSize = fontSzList[blockNo]
        label.fontName="HelveticaNeue-Bold"
        title.fillColor=bgClrList[blockNo]
        title.strokeColor=bgClrList[blockNo]
        label.position=CGPoint(x:0, y:-label.frame.size.height*0.5)
        title.addChild(label)
        self.addChild(title)
    }
    
    func combine(){
        self.blockNo += 1;
        let act1=SKAction.scale(to: 1.2, duration: 0.05)
        let act2=SKAction.scale(to: 0.9, duration: 0.02)
        let act3=SKAction.scale(to: 1.0, duration: 0.06)
        let scaleTo=SKAction.sequence([act1, act2, act3])
        self.run(scaleTo)
    }
    func moveTo(position: CGPoint){
        if(position==self.position){
            return
        }
        let move=SKAction.move(to: position, duration: 0.15)
        move.timingMode = .easeInEaseOut
        self.run(move)
    }
    func remove(){
        let action=SKAction.fadeOut(withDuration: 0.15)
        self.run(action, completion: {()in
            self.removeFromParent()
        })
    }
}
