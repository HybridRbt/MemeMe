//
//  ViewController.swift
//  MemeMe
//
//  Created by Jianfeng Yang on 3/7/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!

    static let strokeWidthAttributeNumber = NSNumber(double: 0.0)
    
    struct Meme {
        var topTextString : String
        var bottomTextString: String
        var originalImage: UIImage?
        var memedImage: UIImage?
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : strokeWidthAttributeNumber
    ]
    
    enum InitialText : String {
        case Top = "TOP"
        case Bottom = "BOTTOM"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.text = InitialText.Top.rawValue
        topTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.text = InitialText.Bottom.rawValue
        bottomTextField.delegate = self
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        cameraButton.enabled = isCameraAvailable
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
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
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField.text {
        case InitialText.Top.rawValue?, InitialText.Bottom.rawValue?:
            textField.text = ""
        default: break
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        //sub to kb will show notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        //sub to kb will hide notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.CGRectValue().height
        return keyboardHeight
    }
    
    //for testing save func
    @IBAction func saveMeme(sender: AnyObject) {
        let meme = save()
        
        //set img view to show the meme
        self.imageView.image = meme.memedImage
        
        //hide top and bottom text fields
        self.topTextField.hidden = true
        self.bottomTextField.hidden = true
    }
    
    func save() -> Meme {
        //Create the meme
        let topText = self.topTextField.text
        let bottomText = self.bottomTextField.text
        let oriImg = self.imageView.image
        
        let memeImg = generateMemedImage()
        let meme = Meme(topTextString: topText!, bottomTextString: bottomText!, originalImage: oriImg, memedImage: memeImg)
        
        return meme
    }
    
    func generateMemedImage() -> UIImage {
        toggleNavbarAndToolBar(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        toggleNavbarAndToolBar(false)
        return memedImage
    }
    
    func toggleNavbarAndToolBar(hide: Bool) {
        // If hide == true then hide both bars
        self.navigationController?.navigationBarHidden = hide
        self.navigationController?.toolbar.hidden = hide
        self.bottomToolbar.hidden = true
    }
}

