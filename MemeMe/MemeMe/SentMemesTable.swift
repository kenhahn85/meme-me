//
//  SentMemesTable.swift
//  MemeMe
//
//  Created by Ken Hahn on 4/26/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var memes = [Meme]()
    let CELL_HEIGHT = CGFloat(100.0)
    let LABELVIEW_TAG = 10
    let IMGVIEW_TAG = 20
    var tableView: UITableView!
    var labelOffset: CGFloat!
    var labelWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMemes()
        if memes.isEmpty {
            self.gotoCreate()
        }
    }
    
    private func updateMemes() {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        println("MEMES")
        println(memes)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Sent Memes"
        
        updateMemes()
        calcCellViewParams()
        setupNavbarItem()
        redrawTable()
    }
    
    // TODO: move this common code into its own mixin or something
    private func setupNavbarItem() {
        let addIcon = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Add,
            target: self,
            action: "gotoCreate"
        )
        self.navigationItem.rightBarButtonItem = addIcon
    }
    
    // TODO: work on completion handler?
    func gotoCreate() {
        var vc = self.storyboard!.instantiateViewControllerWithIdentifier("createMeme") as! CreateMemeViewController
        vc.goToSentMemesFn = {
            self.navigationController?.popViewControllerAnimated(true)
        }
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    private func calcCellViewParams() {
        let cellWidth = self.view.frame.width
        let imgViewWidthLimit = cellWidth * 1 // by setting multiplier to 1, effectively disable this for now.
        
        var maxImgWidth: CGFloat = 0.0
        for meme in memes {
            let image = meme.memedImage
            
            let imageViewWidth = CELL_HEIGHT * image.size.width / image.size.height
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView = tableView
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = memes[indexPath.row]
        let image = meme.memedImage
        
        let imageWidth = image.size.width
        let cellWidth = self.view.frame.width
        
        if let oldLabel = cell.contentView.viewWithTag(LABELVIEW_TAG) {
            oldLabel.removeFromSuperview()
        }
        
        let labelView = UILabel(frame: CGRectMake(labelOffset, 0.0, labelWidth, CELL_HEIGHT))
        labelView.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
        labelView.tag = LABELVIEW_TAG
        labelView.text = meme.text
        
        cell.contentView.addSubview(labelView)
        
        if let oldImageView = cell.contentView.viewWithTag(IMGVIEW_TAG) {
            println(oldImageView)
        } else {
            println("adding img view")
            let imageViewWidth = CELL_HEIGHT * image.size.width / image.size.height
            let imageView = UIImageView(frame: CGRectMake(0.0, 0.0, imageViewWidth, CELL_HEIGHT))
            imageView.tag = IMGVIEW_TAG
            imageView.image = image
            cell.contentView.addSubview(imageView)
            println("imageViewWidth \(imageViewWidth)")
        }
        
        return cell
    }
    
    private func redrawTable() {
        calcCellViewParams()
        if let tableView = self.tableView {
            tableView.reloadData()
        }
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        redrawTable()
    }
}
