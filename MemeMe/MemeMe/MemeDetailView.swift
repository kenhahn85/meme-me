//
//  MemeDetailsView.swift
//  MemeMe
//
//  Created by Ken Hahn on 5/3/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import UIKit

class MemeDetailsViewController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        
        self.imageView!.image = meme.memedImage
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
}
