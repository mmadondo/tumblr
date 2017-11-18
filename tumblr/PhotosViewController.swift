//
//  PhotosViewController.swift
//  tumblr
//
//  Created by Malvern Madondo on 11/17/17.
//  Copyright © 2017 Malvern Madondo. All rights reserved.
//

import UIKit
import AlamofireImage

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tumblrTableView: UITableView!
    
    var posts: [[String: Any]] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configure datasource and delegate of tumblrTableView
        
        tumblrTableView.delegate = self;
        tumblrTableView.dataSource = self;
        //tumblrTableView.rowHeight = 350;
        
        // Network request
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")!
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main);
        
        session.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData;
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data,
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
                // TODO: Get the posts and store in posts property
                // Get the dictionary from the response key
                let responseDictionary = dataDictionary["response"] as! [String: Any]
                
                // Store the returned array of dictionaries in our posts property
                self.posts = responseDictionary["posts"] as! [[String: Any]]
                
                // Reload the table view
                self.tumblrTableView.reloadData();
            
            }
            
        }
        
        task.resume();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tumblrPhotoCell", for: indexPath) as! tumblrTableViewCell;
        
        let post = posts[indexPath.row];  //pull out single post from posts array
        
        //get photo dictionary from the post
        
        if let photos = post["photos"] as? [[String: Any]]{
            
            //to get images url:
            let photo = photos[0]; //1st image in photos array
            
            let originalSize = photo["original_size"] as! [String: Any]; //Get the original size dictionary from the photo
            
            // Get the url string from the original size dictionary
            let urlString = originalSize["url"] as! String;
            
            // Create a URL using the urlString
            let url = URL(string: urlString);
            
            cell.tumblrImageView.af_setImage(withURL: url!);
        }
        
        return cell;
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
