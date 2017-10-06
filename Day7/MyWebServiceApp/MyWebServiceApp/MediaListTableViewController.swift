//
//  MediaListTableViewController.swift
//  MyWebServiceApp
//
//  Created by Amnuay M on 9/25/17.
//  Copyright © 2017 ANT. All rights reserved.
//

import UIKit
import AVKit

class MediaListTableViewController: UITableViewController {

    //Create Array to get value response from WebService
    var mySongList : [[String : String]] = []
    var myVideoList : [[String : String]] = []
    
    //Create audio and video player
    var audioPlayer : AVPlayer?
    var moviePlayer : AVPlayerViewController?
    
    func parseJSON(myData : Data, from : Int){
        let json = try! JSONSerialization.jsonObject(with: myData, options: .mutableContainers)
        if from == 0 {
            mySongList = json as! [[String : String]]
        }else{
            myVideoList = json as! [[String : String]]
        }
        self.tableView.reloadData()
    }
    
    func getSong(){
        //Create Activity Indicator and order it to show
        let myActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        myActivityIndicator.activityIndicatorViewStyle = .gray
        myActivityIndicator.center = (self.navigationController?.view.center)!
        myActivityIndicator.startAnimating()
        myActivityIndicator.backgroundColor = UIColor.white
        self.view.addSubview(myActivityIndicator)
        
        //HTTP Request initialization
        let myURL : URL = URL(string: "http://www.worasit.com/iosbuilder/getsong.php")!
        var myRequest : URLRequest = URLRequest(url: myURL)
        let mySession = URLSession.shared
        myRequest.httpMethod = "GET"
        let myTask = mySession.dataTask(with: myRequest){
            (responseData, responseStatus, error) in
            //Forced Operation in MainQueue
            OperationQueue.main.addOperation {
                print("responseStatus = \(responseStatus!)")
                print("responseData = \(responseData!)")
                self.parseJSON(myData: responseData!, from: 0)
                myActivityIndicator.stopAnimating()
                myActivityIndicator.hidesWhenStopped = true
            }
        }
        myTask.resume()

    }
    
    func getVideo(){
        //Create Activity Indicator and order it to show
        let myActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        myActivityIndicator.activityIndicatorViewStyle = .gray
        myActivityIndicator.center = (self.navigationController?.view.center)!
        myActivityIndicator.startAnimating()
        myActivityIndicator.backgroundColor = UIColor.white
        self.view.addSubview(myActivityIndicator)
        
        //HTTP Request initialization
        let myURL : URL = URL(string: "http://www.worasit.com/iosbuilder/getvideo.php")!
        var myRequest : URLRequest = URLRequest(url: myURL)
        let mySession = URLSession.shared
        myRequest.httpMethod = "GET"
        let myTask = mySession.dataTask(with: myRequest){
            (responseData, responseStatus, error) in
            //Forced Operation in MainQueue
            OperationQueue.main.addOperation {
                print("responseStatus = \(responseStatus!)")
                print("responseData = \(responseData!)")
                self.parseJSON(myData: responseData!, from: 1)
                myActivityIndicator.stopAnimating()
                myActivityIndicator.hidesWhenStopped = true
            }
        }
        myTask.resume()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.title = "AV List"
        self.getSong()
        self.getVideo()
    }

    @objc func videoHasFinishedPlaying(notification: Notification){
        print("Video finished playing")
        moviePlayer?.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return mySongList.count
        }else{
            return myVideoList.count
        }
    }
    
    //Add Section Title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Your Music"
        }else{
            return "Your Video"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...

        var myAVItem : [String:String]
        if indexPath.section == 0{
            myAVItem = mySongList[indexPath.row]
            
        }else{
            myAVItem = myVideoList[indexPath.row]
            
        }
        cell.textLabel?.text = myAVItem["avName"]!
        cell.detailTextLabel?.text = myAVItem["artistName"]!
        
        //Read Data from internet
        let url = URL(string:"http://www.worasit.com/iosbuilder/"+myAVItem["imgName"]!)
        //put loaded image as an object in imgData
        let imgData = try? Data(contentsOf: url!)
        cell.imageView?.image = UIImage(data: imgData!)
        
        return cell
    }
    
    //Specify Row height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var myAVItem : [String:String]
        if indexPath.section == 0{
            myAVItem = mySongList[indexPath.row]
            let mySong : URL = URL(string:"http://www.worasit.com/iosbuilder/"+myAVItem["fileName"]!)!
            audioPlayer = AVPlayer(url: mySong)
            audioPlayer!.rate = 1.0
            audioPlayer!.play()
            
            let alertController = UIAlertController(title: "Music Player", message: "Playing "+myAVItem["avName"]!+" "+myAVItem["artistName"]!, preferredStyle: .actionSheet)
            let cancelButton = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            let stopButton = UIAlertAction(title: "Stop", style: .default, handler: {(action) in self.audioPlayer!.pause()})
            alertController.addAction(cancelButton)
            alertController.addAction(stopButton)
            self.present(alertController, animated: true, completion: nil)
        }else{
            myAVItem = myVideoList[indexPath.row]
            let myVideo : URL = URL(string:"http://www.worasit.com/iosbuilder/"+myAVItem["fileName"]!)!
            
            moviePlayer = AVPlayerViewController()
            moviePlayer?.player = AVPlayer(url: myVideo)
            
            if let player = moviePlayer{
                NotificationCenter.default.addObserver(self, selector: #selector(videoHasFinishedPlaying(notification:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                print("Successfully instatiated the movie player")
                self.present(player, animated: true, completion: {() -> Void in player.player?.play()})
            }
        }
    }
    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
