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

    var videoFile: String!
    
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    lazy var togglePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(white: 1, alpha: 0)
        button.isHidden = true
        
        button.addTarget(self, action: #selector(handlePlayToggle), for: .touchUpInside)
        return button
    }()
    
    var isPlaying = false
    
    func handlePlayToggle() {
        if isPlaying {
            self.player?.pause()
//            togglePlayButton.setImage(UIImage(named: "play"), for: .normal)
        }
        else {
            self.player?.play()
//            togglePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let height = self.view.frame.size.width * 9 / 16
        let frame = CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: height)
        
        setupPlayerView(frame: frame)
        
        controlsContainerView.frame = frame
        self.view.addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(togglePlayButton)
        togglePlayButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        togglePlayButton.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        togglePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        togglePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    var player:AVPlayer?
    
    private func setupPlayerView(frame: CGRect) {
        let urlString = "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v"
        if let url = NSURL(string: urlString) {
            player = AVPlayer(url: url as URL)
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = frame
            playerLayer.backgroundColor = UIColor.black.cgColor
            self.view.layer.addSublayer(playerLayer)
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }
        //        let url:NSURL = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")!
        //        let url:NSURL = NSURL(string: "http://localhost:5000/api/vid/1/" + videoFile)!
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            togglePlayButton.isHidden = false
            isPlaying = true
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
