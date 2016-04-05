//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jianfeng Yang on 3/23/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memedImage.image = meme.memedImage
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        // instantiate the editor
        let memeEditor = storyboard?.instantiateViewControllerWithIdentifier("EditorView") as! EditorViewController
        
        // embed the view controller with navigation controller 
        // (very important, otherwise there will be no nav bar)
        let memeEditorNavi = UINavigationController(rootViewController: memeEditor)
        
        // pass in the meme for editing
        memeEditor.meme = meme
        presentViewController(memeEditorNavi, animated: true, completion: nil)
    }
}
