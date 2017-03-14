//
//  PlayerView.swift
//  SecureDat
//
//  Created by Markus Notti on 3/13/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        layer.backgroundColor = UIColor.black.cgColor
        return layer as! AVPlayerLayer
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    

}
