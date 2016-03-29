//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Jianfeng Yang on 3/23/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController {
    // Get the Mems from the appDelegate for the table
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    // Table View Data Source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemeCell")!
        let meme = memes[indexPath.row]
        
        // Use the top string as the text label
        cell.textLabel?.text = meme.topTextString
        
        // Set image to be the memed image
        cell.imageView?.image = meme.memedImage
        
        // If the cell has a detail label, we will put the evil scheme in.
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = meme.topTextString + meme.bottomTextString
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let customMeme = self.storyboard!.instantiateViewControllerWithIdentifier("CustomMemeViewController") as! CustomMemeViewController
        customMeme.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(customMeme, animated: true)
    }
}


