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
    
    func convertToTimestamp(filename: String) -> String {
        if (filename.characters.count != 19) {
            return "Corrupt File"
        }
        let yearIndex = filename.index(filename.startIndex, offsetBy: 4)
        let year = filename.substring(to: yearIndex)
        
        let startMonth = filename.index(filename.startIndex, offsetBy: 4)
        let endMonth = filename.index(filename.startIndex, offsetBy: 6)
        let monthRange = startMonth..<endMonth
        let month = filename.substring(with: monthRange)
        
        let startDay = filename.index(filename.startIndex, offsetBy: 6)
        let endDay = filename.index(filename.startIndex, offsetBy: 8)
        let dayRange = startDay..<endDay
        let day = filename.substring(with: dayRange)
        
        let startHour = filename.index(filename.startIndex, offsetBy: 9)
        let endHour = filename.index(filename.startIndex, offsetBy: 11)
        let hourRange = startHour..<endHour
        let hour = filename.substring(with: hourRange)
        
        let startMinute = filename.index(filename.startIndex, offsetBy: 11)
        let endMinute = filename.index(filename.startIndex, offsetBy: 13)
        let minuteRange = startMinute..<endMinute
        let minute = filename.substring(with: minuteRange)
        
        let startSecond = filename.index(filename.startIndex, offsetBy: 13)
        let endSecond = filename.index(filename.startIndex, offsetBy: 15)
        let secondRange = startSecond..<endSecond
        let second = filename.substring(with: secondRange)
        
        let firstHalf = month + "-" + day + "-" + year + ", "
        let secondHalf = hour + ":" + minute + ":" + second
        let final = firstHalf + secondHalf
        return final
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count // your number of cell here
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vidcell", for: indexPath)
//        let txt = convertToTimestamp(filename: self.files[indexPath.row])
        let txt = convertToTimestamp(filename: "20170314T064525.mp4")
        cell.textLabel?.text = txt
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
