//
//  ViewController.swift
//  MemeMe
//
//  Created by Ken Hahn on 4/18/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate, UITextFieldDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var upperToolbar: UIToolbar!
    @IBOutlet weak var lowerToolbar: UIToolbar!

    @IBOutlet weak var upperText: UITextField!
    @IBOutlet weak var lowerText: UITextField!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLowerToolbar()
        setupUpperToolbar()
        setupTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        imageView.layer.zPosition = -1
        // TODO: try segue to sent memes if xyz?
        // I guess it makes more sense to make SentMemes the default controller and segue from there
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillShow:",
            name: UIKeyboardWillShowNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "keyboardWillHide:",
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillShowNotification,
            object: nil
        )
        
        NSNotificationCenter.defaultCenter().removeObserver(
            self,
            name: UIKeyboardWillHideNotification,
            object: nil
        )
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if lowerText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if lowerText.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3
    ]
    
    func setupTextFields() {
        upperText.text = "TOP"
        upperText.defaultTextAttributes = memeTextAttributes
        upperText.textAlignment = NSTextAlignment.Center
        upperText.delegate = self
        
        lowerText.text = "BOTTOM"
        lowerText.defaultTextAttributes = memeTextAttributes
        lowerText.textAlignment = NSTextAlignment.Center
        lowerText.delegate = self
    }
    
    var upperTextEdited = false
    var lowerTextEdited = false
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if !upperTextEdited && textField == upperText {
            upperTextEdited = true
            textField.text = ""
        }
        
        if !lowerTextEdited && textField == lowerText {
            lowerTextEdited = true
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    var shareButton: UIBarButtonItem!
    
    func setupUpperToolbar() {
        var flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,
            target: nil,
            action: nil
        )
        
        shareButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Action,
            target: self,
            action: "share"
        )
        shareButton.enabled = false
        
        // TODO: show sent memes view
        var cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "goToSentMemesView"
        )
        
        upperToolbar.setItems(
            [shareButton, flexibleSpace, cancelButton],
            animated: false
        )
    }
    
    func goToSentMemesView() {
       // TODO
        println("going to sent memes")
        performSegueWithIdentifier("gotoSentMemes", sender: self)
    }
    
    func generateMemedImage() -> UIImage {
        upperToolbar.hidden = true
        lowerToolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO:  Show toolbar and navbar
        upperToolbar.hidden = false
        lowerToolbar.hidden = false
        
        return memedImage
    }
    
    func saveMeme(memedImage: UIImage) {
        var meme = Meme(
            upperText: upperText.text,
            lowerText: lowerText.text,
            image: imageView.image!,
            memedImage: memedImage
        )
        
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        println("Saving meme")
        println(meme)
    }
    
    func share() {
        var memedImage: UIImage = generateMemedImage()
        var activityVc = UIActivityViewController(
            // TODO: generate meme image using this: https://www.udacity.com/course/viewer#!/c-ud788-nd/l-3669378557/m-3771758758
            // TODO: then save a Meme object using a shared model
            activityItems: [memedImage],
            applicationActivities: nil
        )
        
        activityVc.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
            self.saveMeme(memedImage)
            self.goToSentMemesView()
        }
       
        presentViewController(activityVc, animated: true, completion: nil)
    }
    
    func setupLowerToolbar() {
        var flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace,
            target: nil,
            action: nil
        )
        
        // Do any additional setup after loading the view, typically from a nib.
        var cameraButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Camera,
            target: self,
            action: "pickAnImageFromCamera"
        )
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        var albumButton = UIBarButtonItem(
            title: "Album",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "pickAnImageFromAlbum"
        )
        
        lowerToolbar.setItems(
            [flexibleSpace, cameraButton, flexibleSpace, albumButton, flexibleSpace],
            animated: false
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickAnImageFromCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func pickAnImageFromAlbum() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let img:UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage? {
            imageView.image = img
            shareButton.enabled = true
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tabBar(tabBar: UITabBar,
        didSelectItem item: UITabBarItem!) {
            if item.title == "Album" {
                pickAnImageFromAlbum()
            } else if item.title == "Camera" {
                pickAnImageFromCamera()
            }
    }
}

