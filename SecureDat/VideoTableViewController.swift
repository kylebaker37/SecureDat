//
//  VideoTableViewController.swift
//  SecureDat
//
//  Created by Kyle Baker on 3/12/17.
//  Copyright © 2017 Sauce Kitchen. All rights reserved.
//

import UIKit

class VideoTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedFile : String!
    var files: [String] = []
    @IBOutlet weak var videosTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.files = ["hey.mp4", "usuk.mp4", "asuh.mp4"]
        Backend.get_videos(completionHandler: setFiles)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFiles(file_list: [String]) {
        self.files = file_list
        self.videosTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vidcell", for: indexPath)
        cell.textLabel?.text = self.files[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedFile = self.files[indexPath.row]
        performSegue(withIdentifier: "videoListToVideo", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! VideoViewController
        vc.videoFile = self.selectedFile
    }

}
