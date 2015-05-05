//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Ken Hahn on 4/26/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import UIKit

class SentMemesCollectionView: SentMemeViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var collectionView: UICollectionView?
    private var layout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        var thisWidth = screenWidth - 10
        
        layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // manually instantiating the collection view instead of using the Storyboard,
        // because that was the way I figured out how to customize the layout of the collection.
        // I found that a custom layout was needed to handle device orientation changes.
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(MemeCell.self, forCellWithReuseIdentifier: "MemeCollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        redrawView()
    }
    
    override internal func redrawView() {
        // ensure the frame is updated on rotation
        collectionView!.frame = self.view.frame
        collectionView!.reloadData()
    }
    
    ////////////////////////////////////////////
    // COLLECTION VIEW PROTOCOLS
    ////////////////////////////////////////////
    
    // set up collection view cells so that there are 4 per row, regardless of device size or orientation
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let frameWidth = self.view.frame.width - 12 // minus 12 accounts for interitem spacing of 3, and row capacity of 4 items.
        return CGSize(width: frameWidth / 4, height: frameWidth / 4)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCell
        let meme = memes[indexPath.row]
        
        // unlike the table view, cannot necessarily reuse same UIImageView
        // here since collection view cells are re-sized based on device orientation.
        // to be safe, just re-rendering image completely.
        if let oldImageView = cell.contentView.viewWithTag(1) {
            oldImageView.removeFromSuperview()
        }
        
        
        let image = meme.memedImage
        let frameWidth = self.view.frame.width
        let imageView = UIImageView(frame: CGRectMake(0.0, 0.0, frameWidth / 4, frameWidth / 4))
        imageView.tag = 1
        imageView.image = image
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath) {
        showDetails(memes[indexPath.row])
    }
}
