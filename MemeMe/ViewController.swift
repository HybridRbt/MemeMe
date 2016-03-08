//
//  ViewController.swift
//  MemeMe
//
//  Created by Jianfeng Yang on 3/7/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickFromAlbum(sender: AnyObject) {
        let imageViewController = UIImagePickerController()
        self.presentViewController(imageViewController, animated: true, completion: nil)
    
    }

}

