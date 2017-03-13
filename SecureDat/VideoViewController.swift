//
//  VideoViewController.swift
//  SecureDat
//
//  Created by Kyle Baker on 3/12/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {

    var player:AVPlayer!
    var videoFile: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v"
        if let url = NSURL(string: urlString) {
            let player = AVPlayer(url: url as URL)
            let playerLayer = AVPlayerLayer(player: player)
            let height = self.view.frame.size.width * 9 / 16
            playerLayer.frame = CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: height)
            playerLayer.backgroundColor = UIColor.black.cgColor
            self.view.layer.addSublayer(playerLayer)
            player.play()
        }
//        let url:NSURL = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")!
//        let url:NSURL = NSURL(string: "http://localhost:5000/api/vid/1/" + videoFile)!
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
