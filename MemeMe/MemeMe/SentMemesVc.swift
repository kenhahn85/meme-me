//
//  VcWithCreateMemeLink.swift
//  MemeMe
//
//  Created by Ken Hahn on 5/3/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import UIKit

/**
 * This class handles shared functionality between the Sent Memes
 * collection and table views. Both the aforementioned views are
 * expected to extend this class.
 */
class SentMemeViewController: UIViewController {
    var memes: [Meme] {
        get {
            let object = UIApplication.sharedApplication().delegate
            let appDelegate = object as! AppDelegate
            return appDelegate.memes
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
    }
    
    // ensures table is redrawn when the device orientation changes
    override func updateViewConstraints() {
        super.updateViewConstraints()
        redrawView()
    }
    
    // goes to the create meme view
    internal func gotoCreate() {
        var createMemesVc = self.storyboard!.instantiateViewControllerWithIdentifier("createMeme") as! CreateMemeViewController
        
        // set up the callback that the create meme view will invoke when it is done saving
        createMemesVc.goToSentMemesFn = {
            self.navigationController?.popViewControllerAnimated(true)
        }
        self.presentViewController(createMemesVc, animated: true, completion: nil)
    }
    
    // sets up the title and "create" icon
    internal func setupNavbar() {
        let addIcon = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Add,
            target: self,
            action: "gotoCreate"
        )
        
        self.navigationItem.title = "Sent Memes"
        self.navigationItem.rightBarButtonItem = addIcon
    }
    
    // use the nav controller to present the detail view
    internal func showDetails(meme: Meme) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailsViewController") as! MemeDetailsViewController
        detailController.meme = meme
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    internal func redrawView() {
       NSException(name:"name", reason:"Must override this.", userInfo:nil).raise()
    }
}