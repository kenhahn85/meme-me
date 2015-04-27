//
//  TabBar.swift
//  MemeMe
//
//  Created by Ken Hahn on 4/26/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.clearColor()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
