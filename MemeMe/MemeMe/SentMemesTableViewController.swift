//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ken Hahn on 4/26/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import UIKit

class SentMemesTableViewController: SentMemeViewController, UITableViewDataSource, UITableViewDelegate {
    private let cellHeight = CGFloat(100.0)
    private let labelViewTag = 10
    private let imgViewTag = 20
    private var labelOffset: CGFloat!
    private var labelWidth: CGFloat!
    private var startedUp = false
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // only redirect to the create view one time.
        if !startedUp && memes.isEmpty {
            startedUp = true
            gotoCreate()
        } else {
            calcCellViewParams()
            redrawView()
        }
    }
    
    // images have varying aspect ratios. in order to left align all captions,
    // we iterate through each of the images, calculate the width of the widest image
    // after being scaled to the pre-designated cell height, and then record that value.
    // that value is used when constructing the cells to set the offset of the label.
    private func calcCellViewParams() {
        let cellWidth = self.view.frame.width
        let imgViewWidthLimit = cellWidth * 1 // by setting multiplier to 1, effectively disable this for now.
        
        var maxImgWidth: CGFloat = 0.0
        for meme in memes {
            let image = meme.memedImage
            
            let imageViewWidth = cellHeight * image.size.width / image.size.height
            if imageViewWidth > maxImgWidth && imageViewWidth <= imgViewWidthLimit {
                maxImgWidth = imageViewWidth
            }
        }
        
        if maxImgWidth == 0.0 {
            maxImgWidth = imgViewWidthLimit
        }
        
        labelOffset = maxImgWidth + 20
        labelWidth = cellWidth - (maxImgWidth + 40)
    }
    
    override internal func redrawView() {
        calcCellViewParams()
        if let tableView = self.tableView {
            tableView.reloadData()
        }
    }
    
    ////////////////////////////////////////////
    // TABLE VIEW PROTOCOLS
    ////////////////////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    // this custom logic was the only way I could seem to get the image view to have 0 left padding.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = memes[indexPath.row]
        let image = meme.memedImage
        
        let imageWidth = image.size.width
        let cellWidth = self.view.frame.width
        
        // this ensures that when the device is rotated, old and new labels are overlapping
        // could have explored re-using the existing UILabel as well, but this works fine
        // for the purposes of this project.
        if let oldLabel = cell.contentView.viewWithTag(labelViewTag) {
            oldLabel.removeFromSuperview()
        }
        
        let labelView = UILabel(frame: CGRectMake(labelOffset, 0.0, labelWidth, cellHeight))
        // truncates text by putting the ".." in the middle
        labelView.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
        labelView.tag = labelViewTag
        labelView.text = meme.text
        
        cell.contentView.addSubview(labelView)
        
        if let oldImageView = cell.contentView.viewWithTag(imgViewTag) {
            // using the old image here should be safe, since there is no way for 
            // images to be re-ordered in this implementation of the spec (there's no deletion).
        } else {
            // shrink the image but keep it proportional
            let imageViewWidth = cellHeight * image.size.width / image.size.height
            let imageView = UIImageView(frame: CGRectMake(0.0, 0.0, imageViewWidth, cellHeight))
            imageView.tag = imgViewTag
            imageView.image = image
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            imageView.clipsToBounds = true
            cell.contentView.addSubview(imageView)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showDetails(memes[indexPath.row])
    }
}
