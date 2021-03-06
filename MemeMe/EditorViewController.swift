//
//  EditorViewController.swift
//  MemeMe
//
//  Created by Jianfeng Yang on 3/7/16.
//  Copyright © 2016 Jianfeng Yang. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var meme = Meme(topTextString: Meme.InitialText.Top.rawValue, bottomTextString: Meme.InitialText.Bottom.rawValue, originalImage: nil, memedImage: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetTextFields()
        
        // opened as editor
        if meme.memedImage != nil {
            setupMemeContents(meme)
        }
    }

    //need to set to number less than 0. set to any number greater than 0 will result in a halo effect on the text
    static let strokeWidthAttributeNumber = NSNumber(double: -2.0)
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : strokeWidthAttributeNumber
    ]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //enable/disable camera button
        let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        cameraButton.enabled = isCameraAvailable
        
        //enable/disable share button
        if imageView.image != nil {
            shareButton.enabled = true
        } else {
            shareButton.enabled = false
        }
        
        subscribeToKeyboardNotifications()
        toggleNavbarAndToolBar(false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
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
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(shareActivityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        //clear input in text fields and restore to default
        resetTextFields()
        
        //another way to dismiss keyboard
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
        
        //clear image
        imageView.image = nil
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func resetTextFields() {
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.delegate = self
        
        topTextField.text = Meme.InitialText.Top.rawValue
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.delegate = self
        
        bottomTextField.text = Meme.InitialText.Bottom.rawValue
    }
    
    func setupMemeContents(meme: Meme) {
        resetTextFields()
    
        topTextField.text = meme.topTextString
        bottomTextField.text = meme.bottomTextString
        imageView.image = meme.originalImage
    }
    
    func pickImage(source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        switch textField.text {
        //clears the text only if it's showing the default one
        case Meme.InitialText.Top.rawValue?, Meme.InitialText.Bottom.rawValue?:
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        //sub to kb will hide notification
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
        let topText = topTextField.text
        let bottomText = bottomTextField.text
        let oriImg = imageView.image
        
        let memeImg = generateMemedImage()
        let savedMeme = Meme(topTextString: topText!, bottomTextString: bottomText!, originalImage: oriImg, memedImage: memeImg)
        
        //save to AppDelegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memes.append(savedMeme)
    }
    
    func generateMemedImage() -> UIImage {
        resignFirstResponder()
        toggleNavbarAndToolBar(true)
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        toggleNavbarAndToolBar(false)
        return memedImage
    }
    
    func toggleNavbarAndToolBar(hide: Bool) {
        // If hide == true then hide both bars
        navigationController?.navigationBarHidden = hide
        bottomToolbar.hidden = hide
    }
}

