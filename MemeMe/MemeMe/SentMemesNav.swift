//
//  SentMemesNav.swift
//  MemeMe
//
//  Created by Ken Hahn on 5/3/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import UIKit

struct SentMemesNavSetup {
    private var vc: UIViewController!
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    // TODO: move this common code into its own mixin or something
    func setupNavbarItem() {
        let addIcon = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Add,
            target: vc,
            action: "gotoCreate"
        )
        
        vc.navigationItem.title = "Sent Memes"
        vc.navigationItem.rightBarButtonItem = addIcon
    }
    
    // TODO: work on completion handler?
    func gotoCreate() {
        var createMemesVc = vc.storyboard!.instantiateViewControllerWithIdentifier("createMeme") as! CreateMemeViewController
        createMemesVc.goToSentMemesFn = {
            vc.navigationController?.popViewControllerAnimated(true)
        }
        vc.presentViewController(createMemesVc, animated: true, completion: nil)
    }
}
