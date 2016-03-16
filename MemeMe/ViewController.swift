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
    @IBOutlet weak var shareButton: UIBarButtonItem!

    //need to set to number less than 0. set to any number greater than 0 will result in a halo effect on the text
    static let strokeWidthAttributeNumber = NSNumber(double: -2.0)
    
    var savedMeme = Meme(topTextString: InitialText.Top.rawValue, bottomTextString: InitialText.Bottom.rawValue, originalImage: nil, memedImage: nil)
    
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
        resetTextFields()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //enable/disable camera button
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        cameraButton.enabled = isCameraAvailable
        
        //enable/disable share button
        if self.imageView.image != nil {
            shareButton.enabled = true
        } else {
            shareButton.enabled = false
        }
        
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
    
    @IBAction func pickFromAlbum(sender: AnyObject) {
        let source = UIImagePickerControllerSourceType.PhotoLibrary
        pickImage(source)
    }
    
    @IBAction func pickFromCamera(sender: AnyObject) {
        let source = UIImagePickerControllerSourceType.Camera
        pickImage(source)
    }

    @IBAction func shareButtonTapped(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let shareActivityViewController = UIActivityViewController(activityItems:[memedImage], applicationActivities: nil)
        
        shareActivityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                self.save()
                //shareActivityViewController.dismissViewControllerAnimated(true, completion: nil)
                //self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(shareActivityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        //clear input in text fields and restore to default
        resetTextFields()
        
        //another way to dismiss keyboard
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
        
        //clear image
        self.imageView.image = nil
    }
    
    func resetTextFields() {
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.text = InitialText.Top.rawValue
        topTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.text = InitialText.Bottom.rawValue
        bottomTextField.delegate = self
    }
    
    func pickImage(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.presentViewController(imagePicker, animated: true, completion: nil)
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
        //clears the text only if it's showing the default one
        case InitialText.Top.rawValue?, InitialText.Bottom.rawValue?:
            textField.text = ""
        default: break
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //one way to dismiss the keyboard
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
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.CGRectValue().height
        return keyboardHeight
    }
    
    func save() {
        //Create the meme
        let topText = self.topTextField.text
        let bottomText = self.bottomTextField.text
        let oriImg = self.imageView.image
        
        let memeImg = generateMemedImage()
        self.savedMeme = Meme(topTextString: topText!, bottomTextString: bottomText!, originalImage: oriImg, memedImage: memeImg)
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
        self.bottomToolbar.hidden = hide
    }
}

