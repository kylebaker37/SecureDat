//
//  VideoViewController.swift
//  SecureDat
//
//  Created by Kyle Baker on 3/12/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoViewController: UIViewController {

    var player:AVPlayer!
    var videoFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let url:NSURL = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")!
//        let url:NSURL = NSURL(string: "http://localhost:5000/api/vid")!
        let url:NSURL = NSURL(string: "http://localhost:5000/api/vid/1/" + videoFile)!
        
        player = AVPlayer(url: url as URL)
        let avPlayerLayer:AVPlayerLayer = AVPlayerLayer(player: player)
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        avPlayerLayer.frame = CGRect(x: 25, y: 25, width: screenWidth-50, height: screenWidth-50)
        self.view.layer.addSublayer(avPlayerLayer)
        player.play()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
