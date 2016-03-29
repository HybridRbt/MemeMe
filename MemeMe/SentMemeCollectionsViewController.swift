//
//  SentMemeCollectionsViewController.swift
//  MemeMe
//
//  Created by Jianfeng Yang on 3/23/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionsViewController: UICollectionViewController {
    // Get the Mems from the appDelegate for the table
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    // Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! SentMemeCollectionViewCell
        let meme = memes[indexPath.row]
        
        // Set image to be the memed image
        cell.memedImage.image = meme.memedImage 
        // If the cell has a detail label, we will put the evil scheme in.
//        if let detailTextLabel = cell.detailTextLabel {
//            detailTextLabel.text = meme.topTextString + meme.bottomTextString
//        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let customMeme = self.storyboard!.instantiateViewControllerWithIdentifier("CustomMemeViewController") as! CustomMemeViewController
        customMeme.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(customMeme, animated: true)
    }
}

