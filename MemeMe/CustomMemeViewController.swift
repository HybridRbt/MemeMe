//
//  CustomMemeViewController.swift
//  MemeMe
//
//  Created by Jianfeng Yang on 3/23/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import UIKit

class CustomMemeViewController: UIViewController {
    
    var meme: Meme!
    
    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.memedImage.image = meme.memedImage
    }
    
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        //var memeEditor: EditorViewController
        
        let memeEditor = storyboard?.instantiateViewControllerWithIdentifier("EditorView") as! EditorViewController
        
        let memeEditorNavi = UINavigationController(rootViewController: memeEditor)
        
        memeEditor.openAsEditor = true
        memeEditor.meme = meme
        self.presentViewController(memeEditorNavi, animated: true, completion: nil)
        
        
      //  memeEditor.topTextField.text = meme.topTextString
      //  memeEditor.imageView.image = meme.originalImage


    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "openMemeForEditing" {
//            let editor = segue.destinationViewController as! UINavigationController
//            let editorViewController = editor.topViewController as! EditorViewController
//            editorViewController.topTextField.text = meme.topTextString
//            editorViewController.bottomTextField.text = meme.bottomTextString
//            editorViewController.imageView.image = meme.originalImage
//            editor.navigationBarHidden = false
//        }
//    }
}
