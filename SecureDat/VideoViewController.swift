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

    @IBOutlet weak var theProgressBar: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    @IBOutlet weak var pausePlayButton: UIButton!
    
    var player:AVPlayer!
    var videoFile: String!
    var updater : CADisplayLink! = nil

    @IBOutlet weak var videoView: PlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let url:NSURL = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")!
//        let url:NSURL = NSURL(string: "http://localhost:80/api/vid/1/input.mp4")!
        let url:NSURL = NSURL(string: Backend.HOST + ":" + Backend.PORT + "/api/vid/1/" + videoFile)!
        
        player = AVPlayer(url: url as URL)
        
        self.videoView.player = player
        
        //playing video
        theProgressBar.addTarget(self, action: #selector(VideoViewController.userReleasedSlider), for: UIControlEvents.touchUpInside)
        
        theProgressBar.addTarget(self, action: #selector(VideoViewController.userBeganTouchingSlider), for: UIControlEvents.touchDown)
        
        updater = CADisplayLink(target: self, selector: #selector(VideoViewController.trackVideo))
        updater.preferredFramesPerSecond = 10
        updater.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        
        theProgressBar.minimumValue = 0
        theProgressBar.maximumValue = 100 // 
        player.play()
        ////////
        /////////

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.player.pause()
        self.updater.invalidate()
        self.updater = nil
        self.player = nil
    }

    func trackVideo(){
        if (player != nil){
            if(player.rate != 0){
                let normalizedTime = Float(player.currentTime().seconds * 100.0 / (self.player.currentItem?.asset.duration.seconds)!)
                theProgressBar.value = normalizedTime
                
            }
            let time = (Double(theProgressBar.value)/100.0) * (self.player.currentItem?.asset.duration.seconds)!
            self.currentTimeLabel.text = "\(time.roundTo(places:1))"
        }
        
    }
    
    func userReleasedSlider() {
        print("editing slider ended")
        self.player.seek(to: CMTime(seconds: (Double(self.theProgressBar.value / 100.0) * (self.player.currentItem?.asset.duration.seconds)!), preferredTimescale: 1))
    }
    
    func userBeganTouchingSlider(){
        print("paused from editing slider")
        self.player.pause()
        self.pausePlayButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.pausePlayButton.setImage(UIImage(named: "playHover")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
    }
    
    @IBAction func pausePlayButtonDidTouchUpInside(_ sender: Any) {
        if (self.player.rate == 0){
            self.player.play()
            self.pausePlayButton.setImage(UIImage(named: "pause")?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.pausePlayButton.setImage(UIImage(named: "pauseHover")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
        }else{
            self.player.pause()
            self.pausePlayButton.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.pausePlayButton.setImage(UIImage(named: "playHover")?.withRenderingMode(.alwaysOriginal), for: .highlighted)
        }
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

