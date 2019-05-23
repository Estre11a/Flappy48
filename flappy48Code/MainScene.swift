//
//  MainScene.swift
//  Flappy2048
//
//  Created by nju on 2017/5/27.
//  Copyright © 2017年 nju. All rights reserved.
//

import SpriteKit


class MainScene: SKScene,SKPhysicsContactDelegate {
    var bgClr = UIColor(red : 0xFC/255, green : 0xF7/255, blue : 0xF0/255, alpha : 1)
    var viewWidth:CGFloat=0
    var viewHeight:CGFloat=0
    var blockArray = Array<BlockNode>()
    var scoreNum:Double=0
    var bestNum:Double=0
    let scoreViewSpace: CGFloat = 40
    var head:BlockNode!
    
    let score=ScoreNode()
    let best=ScoreNode()
    let gameoverPanel=GameOverPanel()

    
    var canRestart = Bool()
    var index:Int = 0
    
    
    var moving:SKNode!
    var pipes:SKNode!
    let verticalPipeGap = 200.0
    var pipeTextureUp:SKTexture!
    var pipeTextureDown:SKTexture!
    
    var blocks :BlockNode!
    var singleBlock:BlockNode!
    
    
    let birdCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3
    let singleBlockCategory: UInt32 = 1 << 4
    let bodyCategory: UInt32 = 1 << 5
    var movePipesAndRemove:SKAction!
    
    lazy var sound = SoundManager()
    //var record = 0

    
    //当切换到这个场景视图后
    override func didMove(to view: SKView) {
        
        /*let manager = FileManager.default
        let urlsForDocDirectory = manager.urls(for: .documentDirectory, in:.userDomainMask)
        let docPath = urlsForDocDirectory[0]
        let file = docPath.appendingPathComponent("record.txt")
        
        //方法1
        let readHandler = try! FileHandle(forReadingFrom:file)
        let data = readHandler.readDataToEndOfFile()
        let readString = String(data: data, encoding: String.Encoding.utf8)
        print("文件内容: \(readString)")
        
        //方法2
        let data2 = manager.contents(atPath: file.path)
        let readString2 = String(data: data2!, encoding: String.Encoding.utf8)
        print("文件内容: \(readString2)")*/
        
        //let record:Int? = Int(temp!)
        
        //var url: NSURL = NSURL(fileURLWithPath: "/Users/lusonglin/Desktop/record.txt")!
                //取得当前应用下路径
        
        //设定路径
        /*let url: NSURL = NSURL(fileURLWithPath: "/Users/lusonglin/Desktop/record.txt")
        if let readData = NSData(contentsOfFile: url.path!) {
            //如果内容存在 则用readData创建文字列
            let tmp = NSString(data: readData as Data, encoding: String.Encoding.utf8.rawValue) ?? ""
            record = Int(tmp as String)!
            //print(record)
            bestNum = Double(record)
            
        } else {
            //nil的话，输出空
            print("Null")
        }*/
        
        //播放背景音乐
        self.addChild(sound)
        sound.playBackGround()
        
        moving = SKNode()
        self.addChild(moving)
        
        canRestart = false
        
        self.physicsWorld.gravity=CGVector(dx: 0.0, dy: -2.0)
        //self.physicsBody = SKPhysicsBody (edgeLoopFromRect: self.frame )
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        createScene()
        createPipe()
        createSingleBlock()

        
    }
    
    func createScene(){
        //改变背景颜色
        backgroundColor = bgClr
        
        
        //初始化一个游戏区块对象
        head = BlockNode()
        head.initUI(number: 0)
        head.position=CGPoint(x:self.frame.size.width*0.6,y:self.frame.size.height*0.5)
        head.zPosition=2
        head.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50,height: 50))
//        head.physicsBody = SKPhysicsBody()
        head.physicsBody?.usesPreciseCollisionDetection = true
        head.physicsBody?.isDynamic = true
        head.physicsBody?.allowsRotation = false
            
        head.physicsBody?.categoryBitMask = birdCategory
        head.physicsBody?.collisionBitMask = worldCategory | pipeCategory | singleBlockCategory
        head.physicsBody?.contactTestBitMask = worldCategory | pipeCategory | singleBlockCategory
            
        self.addChild(head)
        blockArray.append(head)
        
        //scoreboard
        
        score.initUI(name: "score", number: scoreNum)
        score.position=CGPoint(x:self.frame.size.width*0.6,
                               y:self.frame.size.height-scoreViewSpace)
        score.zPosition=2
        
        best.position=CGPoint(x:self.frame.size.width*0.85,
                              y:self.frame.size.height-scoreViewSpace)
        best.zPosition=2
        best.initUI(name: "best", number: bestNum)
        
        self.addChild(score)
        self.addChild(best)
        
        
        let ground=SKShapeNode(rectOf: CGSize(width:self.frame.size.width,height: 150))
        ground.fillColor=UIColor(red : 0x81/255, green : 0x81/255, blue : 0x81/255, alpha : 1)
        ground.strokeColor=UIColor(red : 0x81/255, green : 0x81/255, blue : 0x81/255, alpha : 1)
        ground.position=CGPoint(x:self.frame.size.width*0.5,y:ground.frame.size.height*0.5)
        ground.zPosition=1
        
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.frame.size)
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = worldCategory
        
//        self.addChild(ground)
        moving.addChild(ground)
        
        gameoverPanel.initUI(number: 0)
        
    }

    func createSingleBlock(){//隔一段时间随机生成一个新方块
        
        blocks = BlockNode()
        moving.addChild(blocks)
        
        //let initDelay = SKAction.wait(forDuration: TimeInterval(1.5))
        if !canRestart{
        let time: TimeInterval = 2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {//延迟执行
            Timer.scheduledTimer(timeInterval: 3.0, target: self,
                             selector: #selector(self.spawnSingleBlock),
                             userInfo: nil, repeats: true)
        }
        }
        
    }
    
    func createPipe(){
        
        
        pipes = SKNode()
        moving.addChild(pipes)
        
        // create the pipes textures
        pipeTextureUp = SKTexture(imageNamed: "PipeUp")
        pipeTextureUp.filteringMode = .nearest
        pipeTextureDown = SKTexture(imageNamed: "PipeDown")
        pipeTextureDown.filteringMode = .nearest
        //self.addChild(pipeTextureUp)
        
        // create the pipes movement actions
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * pipeTextureUp.size().width)
        let movePipes = SKAction.moveBy(x: -distanceToMove, y:0.0, duration:TimeInterval(0.01 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        // spawn the pipes
        let spawn = SKAction.run(spawnPipes)
        let delay = SKAction.wait(forDuration: TimeInterval(3.0))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatForever(spawnThenDelay)
        self.run(spawnThenDelayForever)

    }
    
    func spawnPipes() {
        let pipePair = SKNode()
        pipePair.position = CGPoint( x: self.frame.size.width + pipeTextureUp.size().width * 2, y: 0 )
        //pipePair.zPosition = -10
        
        let height = UInt32( self.frame.size.height / 5)
        let y = Double(arc4random_uniform(height) + height);
        
        let pipeDown = SKSpriteNode(texture: pipeTextureDown)
        pipeDown.setScale(2.0)
        pipeDown.position = CGPoint(x: 0.0, y: y + Double(pipeDown.size.height) + verticalPipeGap)
        
        
        pipeDown.physicsBody = SKPhysicsBody(rectangleOf: pipeDown.size)
        pipeDown.physicsBody?.isDynamic = false
        pipeDown.physicsBody?.categoryBitMask = pipeCategory
        pipeDown.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeDown)
        
        let pipeUp = SKSpriteNode(texture: pipeTextureUp)
        pipeUp.setScale(2.0)
        pipeUp.position = CGPoint(x: 0.0, y: y)
        
        pipeUp.physicsBody = SKPhysicsBody(rectangleOf: pipeUp.size)
        pipeUp.physicsBody?.isDynamic = false
        pipeUp.physicsBody?.categoryBitMask = pipeCategory
        pipeUp.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(pipeUp)
        
        let contactNode = SKNode()
        contactNode.position = CGPoint( x: pipeDown.size.width + head.size.width / 2, y: self.frame.midY )
        contactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize( width: pipeUp.size.width, height: self.frame.size.height ))
        contactNode.physicsBody?.isDynamic = false
        contactNode.physicsBody?.categoryBitMask = scoreCategory
        contactNode.physicsBody?.contactTestBitMask = birdCategory
        pipePair.addChild(contactNode)
        
        pipePair.run(movePipesAndRemove)
        pipes.addChild(pipePair)
        
    }
    
    func spawnSingleBlock(){
      
        let randomNo = Int(arc4random()) % (2)
        singleBlock = BlockNode()
        singleBlock.initUI(number: randomNo)
        let randomY:CGFloat=CGFloat(arc4random()).truncatingRemainder(dividingBy: self.frame.size.height*0.5)
        singleBlock.position=CGPoint(x:self.frame.size.width+30,
                                     y:self.frame.size.height/4 + randomY)
        singleBlock.zPosition=0;
//        self.addChild(singleBlock)
        
        singleBlock.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50,height: 50))
        singleBlock.physicsBody?.isDynamic = false
        singleBlock.physicsBody?.categoryBitMask = singleBlockCategory
        singleBlock.physicsBody?.contactTestBitMask = birdCategory
        
//        moving.addChild(singleBlock)
        
        
        let distanceToMove = CGFloat(self.frame.size.width + 2.0 * singleBlock.size.width)
        let moveLeft = SKAction.moveBy(x: -distanceToMove, y:0.0, duration:TimeInterval(0.01 * distanceToMove))
        let removeBlock = SKAction.removeFromParent()
        
        //let delay = SKAction.wait(forDuration: TimeInterval(2.0))
        let singleMoveSequence = SKAction.sequence([moveLeft, removeBlock])
        let singleMove = SKAction.repeatForever(singleMoveSequence)
        
        singleBlock.run(singleMove)
        blocks.addChild(singleBlock)
        
    }
    
    func resetScene (){
        gameoverPanel.removeFromParent()
        
        for i in 1..<blockArray.count{
            blockArray[i].removeFromParent()
        }
        blockArray.removeAll()
        
        //head = BlockNode()
        head.setBlockNo(newValue: 0)
        head.position = CGPoint(x:self.frame.size.width*0.6,y:self.frame.size.height*0.5)
        head.physicsBody?.velocity = CGVector( dx: 0, dy: 0 )
        head.physicsBody?.collisionBitMask = worldCategory | pipeCategory | singleBlockCategory
        head.speed = 1.0
        head.zRotation = 0.0
        
        blockArray.append(head)
        index = 0
        
        // Remove all existing pipes
        pipes.removeAllChildren()
        
        //Remove all existing blocks
        blocks.removeAllChildren()
        
        // Reset _canRestart
        canRestart = false
        
        // Reset score
        scoreNum = 0
        score.setScore(name: "score", number: scoreNum)
//        scoreLabelNode.text = String(score)
        
        // Restart animation
        moving.speed = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        head.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//        head.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
//        score += 1
        //let moveSequence = SKAction.sequence([moveUp1,moveUp2])
        //head.run(moveSequence)
        
        //播放点击音效
        //sound.playHit()
        
        if moving.speed > 0  {
            for _ in touches { // do we need all touches?
//                head.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
 //               head.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 30))
                let height = blockArray[0].position.y
                for i in 0..<blockArray.count{
                    if blockArray[i].position.y > height{
                        blockArray[i].physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        blockArray[i].physicsBody?.applyImpulse(CGVector(dx: 0, dy: -4.0*sqrt((Double)(i+1))))

                    }
                    else{
                        blockArray[i].physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        blockArray[i].physicsBody?.applyImpulse(CGVector(dx: 0, dy: 18.0*sqrt((Double)(i+1))))
                    }
                    
                    //self.run(SKAction.wait(forDuration: TimeInterval(1.0)))
                }
            }
        } else if canRestart{
            self.resetScene()
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        /*let other = contact.bodyA.categoryBitMask == PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        
        if other.categoryBitMask == PhysicsCategory.Ground {
            hitGround = true
        }
        if other.categoryBitMask == PhysicsCategory.Obstacle {
            hitObstacle = true
        }*/
        
        if moving.speed > 0 {
            if ( contact.bodyA.categoryBitMask & scoreCategory ) == scoreCategory || ( contact.bodyB.categoryBitMask & scoreCategory ) == scoreCategory {
                // Bird has contact with score entity
//                score += 1
//                scoreLabelNode.text = String(score)
                
                // Add a little visual feedback for the score increment
//                scoreLabelNode.run(SKAction.sequence([SKAction.scale(to: 1.5, duration:TimeInterval(0.1)), SKAction.scale(to: 1.0, duration:TimeInterval(0.1))]))
            }else if (((contact.bodyA.categoryBitMask & bodyCategory) == bodyCategory)
                &&  ((contact.bodyB.categoryBitMask & pipeCategory) == pipeCategory)) || (((contact.bodyB.categoryBitMask & bodyCategory) == bodyCategory)
                    &&  ((contact.bodyA.categoryBitMask & pipeCategory) == pipeCategory)){
                
                //播放碰撞音效
                sound.playCrush()
                
                //躯干与管子碰撞检测
                for i in 0..<blockArray.count{
                    if contact.bodyA == blockArray[i].physicsBody || contact.bodyB == blockArray[i].physicsBody{
                        //print(blockArray.count)
                        var j = blockArray.count-1
                        while(j>=i){
                            
                            let fadeAway = SKAction.fadeOut(withDuration: 2.0)
                            blockArray[j].run(fadeAway)
                            
                            blockArray[j].removeFromParent()
                            
                            blockArray.remove(at: j)
                            j-=1
                        }
                        //physicsWorld.remove(<#T##joint: SKPhysicsJoint##SKPhysicsJoint#>)
                        //print(blockArray.count)
                        /*for j in i..<blockArray.count{
                            blockArray.remove(at: j)
                        }*/
                        //blockArray.remove(at: 1)
                        break;
                    }
                }
                
                
                
                
            }else if( contact.bodyA.categoryBitMask & singleBlockCategory ) == singleBlockCategory || ( contact.bodyB.categoryBitMask & singleBlockCategory ) == singleBlockCategory{
             
                //播放吃到单个方块的音效
                sound.playEat()
                
                index = blockArray.count
                
                //碰撞到单个方块的处理
                singleBlock.removeFromParent()
                
                let temp = BlockNode()
                temp.initUI(number: singleBlock.blockNo)
//                blockArray.append(temp)
                
                
                //为temp添加物理体
                let offset = 55 * CGFloat(1)
                //temp.position = CGPoint(x: blockArray[index-1].position.x - offset, y: blockArray[index-1].position.y)
                temp.position = CGPoint(x:blockArray[0].position.x,y:blockArray[0].position.y)
//                temp.position = CGPoint(x: blockArray[0].position.x - offset, y:blockArray[0].position.y)
                
                    
                temp.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50,height: 50))
                temp.physicsBody?.usesPreciseCollisionDetection = true
                temp.physicsBody?.isDynamic = true
                temp.physicsBody?.allowsRotation = false
                    
                temp.physicsBody?.categoryBitMask = birdCategory
                temp.physicsBody?.collisionBitMask = worldCategory | pipeCategory
                temp.physicsBody?.contactTestBitMask = worldCategory | pipeCategory

                
                blockArray.insert(temp, at: 0)
                self.addChild(temp)
                
                for i in 1..<blockArray.count{
                    blockArray[i].position = CGPoint(x: blockArray[i-1].position.x - offset, y: blockArray[i-1].position.y)
                    blockArray[i].physicsBody?.categoryBitMask = bodyCategory
                    blockArray[i].physicsBody?.collisionBitMask = pipeCategory | worldCategory | singleBlockCategory
                    blockArray[i].physicsBody?.contactTestBitMask = pipeCategory
                }
           
                let nodeA = blockArray[1]
                let nodeB = temp
                //let joint = SKPhysicsJointPin.joint(withBodyA: nodeA.physicsBody!, bodyB: nodeB.physicsBody!,anchor: CGPoint(x: nodeA.frame.maxX, y: nodeA.frame.minY))
                let joint = SKPhysicsJointSliding.joint(withBodyA: nodeA.physicsBody!, bodyB: nodeB.physicsBody!,anchor: CGPoint(x: nodeA.frame.maxX, y: nodeA.frame.minY), axis: CGVector(dx:0,dy:5.0))
                
                joint.lowerDistanceLimit = -40
                joint.upperDistanceLimit = 40
                joint.shouldEnableLimits = true
                
                physicsWorld.add(joint)
                
                //合并
                var size = blockArray.count
                var i:Int = 1
//                var flag:Bool = false
                
                while i<size {
                    if blockArray[i].blockNo == blockArray[i-1].blockNo{
                        scoreNum += pow(2, Double(blockArray[i].blockNo)+1)
                        blockArray[i].removeFromParent()
                        blockArray[i-1].setBlockNo(newValue: blockArray[i].blockNo+1)
                        for j in i+1..<blockArray.count{
                            blockArray[j].position = CGPoint(x: blockArray[j].position.x + offset, y: blockArray[j].position.y)
                        }
                        blockArray.remove(at: i)
                        //删除后如有需要则重新连接断裂处
                        if i != size-1{
                            let nodeA = blockArray[i-1]
                            let nodeB = blockArray[i]
                            let joint = SKPhysicsJointSliding.joint(withBodyA: nodeA.physicsBody!, bodyB: nodeB.physicsBody!,anchor: CGPoint(x: nodeA.frame.maxX, y: nodeA.frame.minY), axis: CGVector(dx:0,dy:5.0))
                            
                            joint.lowerDistanceLimit = -40
                            joint.upperDistanceLimit = 40
                            joint.shouldEnableLimits = true
                            
                            
                            //let joint = SKPhysicsJointPin.joint(withBodyA: nodeA.physicsBody!, bodyB: nodeB.physicsBody!,anchor: CGPoint(x: nodeA.frame.maxX, y: nodeA.frame.minY))
                            
                            physicsWorld.add(joint)
                        }
                        
                        size -= 1
                        i -= 1
                
                    }
                    if size == 1{
                        break
                    }
                    i += 1
                    
                    //循环检测直至没有相邻重复方块
                    if(i == size){
                        for j in 1..<size{
                            if(blockArray[j].blockNo == blockArray[j-1].blockNo){
                                i = 1
                            }
                        }
                    }
                }
////                print(scoreNum)s
                score.setScore(name: "score", number: scoreNum)
                head = blockArray[0];
                
                //判断是否需要更改记录
                if bestNum<scoreNum{
                    bestNum=scoreNum
                    best.setScore(name: "best", number:bestNum)
                    /*let temp = String(Int(bestNum))
                    try! temp.write(toFile: "/Users/lusonglin/Desktop/record.txt", atomically: true,encoding: String.Encoding.utf8)
                    */
                }
                
                
            }else {
                
                moving.speed = 0
                
                head.physicsBody?.collisionBitMask = worldCategory
           //     head.run(  SKAction.rotate(byAngle: CGFloat(M_PI) * CGFloat(head.position.y) * 0.01, duration:1), completion:{self.head.speed = 0 })
                
                
                // Flash background if contact is detected
                self.removeAction(forKey: "flash")
                self.run(SKAction.sequence([SKAction.repeat(SKAction.sequence([SKAction.run({
                    self.backgroundColor = SKColor(red: 1, green: 0, blue: 0, alpha: 1.0)
                }),SKAction.wait(forDuration: TimeInterval(0.05)), SKAction.run({
                    self.backgroundColor = self.bgClr
                }), SKAction.wait(forDuration: TimeInterval(0.05))]), count:4), SKAction.run({self.canRestart = true
                })]), withKey: "flash")
                
                
                
                //播放游戏结束音效
                sound.playGameOver()
                
                gameoverPanel.setScore(number: Int(scoreNum))
                gameoverPanel.position=CGPoint(x:self.frame.size.width/2,y:self.frame.size.height/2)
                gameoverPanel.zPosition=3;
                self.addChild(gameoverPanel)
                
                

                
            }
        }
        
    }
    override func update(_ currentTime: TimeInterval) {
    }
    
}
