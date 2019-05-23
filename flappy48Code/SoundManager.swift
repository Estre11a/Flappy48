//
//  SoundManager.swift
//  v0
//
//  Created by 陆松林 on 2017/7/28.
//  Copyright © 2017年 Squirrel. All rights reserved.
//

import Foundation

import SpriteKit

import AVFoundation

class SoundManager: SKNode {
    //声明播放器
    var bgMusicPlayer = AVAudioPlayer()
    var hitMusicPlayer = AVAudioPlayer()
    var crushMusicPlayer = AVAudioPlayer()
    var gameoverMusicPlayer = AVAudioPlayer()
    var eatMusicPlayer = AVAudioPlayer()
    
    func playBackGround(){
        let bgMusicURL = Bundle.main.url(forAuxiliaryExecutable: "bg.mp3")
        try! bgMusicPlayer = AVAudioPlayer(contentsOf: bgMusicURL!)
        
        bgMusicPlayer.numberOfLoops = -1
        bgMusicPlayer.prepareToPlay()
        bgMusicPlayer.volume = 0.2
        bgMusicPlayer.play()
        
    }
    
    func playHit(){
        let bgMusicURL = Bundle.main.url(forAuxiliaryExecutable: "hit.mp3")
        try! hitMusicPlayer = AVAudioPlayer(contentsOf: bgMusicURL!)
        
        hitMusicPlayer.prepareToPlay()
        
        hitMusicPlayer.play()
    }
    
    func playCrush(){
        let bgMusicURL = Bundle.main.url(forAuxiliaryExecutable: "crush.mp3")
        try! crushMusicPlayer = AVAudioPlayer(contentsOf: bgMusicURL!)
        
        crushMusicPlayer.prepareToPlay()
        crushMusicPlayer.volume = 0.3
        crushMusicPlayer.play()
    }
    
    func playGameOver(){
        let bgMusicURL = Bundle.main.url(forAuxiliaryExecutable: "gameover.mp3")
        try! gameoverMusicPlayer = AVAudioPlayer(contentsOf: bgMusicURL!)
        
        gameoverMusicPlayer.prepareToPlay()
        gameoverMusicPlayer.volume = 0.3
        gameoverMusicPlayer.play()
    }
    
    func playEat(){
        let bgMusicURL = Bundle.main.url(forAuxiliaryExecutable: "eat.mp3")
        try! eatMusicPlayer = AVAudioPlayer(contentsOf: bgMusicURL!)
        
        eatMusicPlayer.prepareToPlay()
        eatMusicPlayer.volume = 0.3
        eatMusicPlayer.play()
    }

}
