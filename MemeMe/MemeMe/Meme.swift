//
//  meme.swift
//  MemeMe
//
//  Created by Ken Hahn on 4/19/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import Foundation
import UIKit   

struct Meme {
    var upperText: String
    var lowerText: String
    var image: UIImage
    var memedImage: UIImage
    var text: String {
        var text = upperText
        if !lowerText.isEmpty {
            text += " - " + lowerText
        }
        return text
    }
}