//
//  ViewController.swift
//  MemeMe
//
//  Created by Jianfeng Yang on 3/7/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    static let strokeWidthAttributeNumber = NSNumber(double: 3.0)
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : strokeWidthAttributeNumber
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        cameraButton.enabled = isCameraAvailable
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pickImage(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickFromAlbum(sender: AnyObject) {
        let source = UIImagePickerControllerSourceType.PhotoLibrary
        pickImage(source)
    }
    
    @IBAction func pickFromCamera(sender: AnyObject) {
        let source = UIImagePickerControllerSourceType.Camera
        pickImage(source)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
//    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        <#code#>
//    }

}

