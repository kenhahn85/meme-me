//
//  SentMemesCollection.swift
//  MemeMe
//
//  Created by Ken Hahn on 4/26/15.
//  Copyright (c) 2015 Ken Hahn. All rights reserved.
//

import UIKit

//TODO: enable scrolling
class SentMemesCollectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    var memes = [Meme]()
    @IBOutlet var collectionView: UICollectionView?
    var layout: UICollectionViewFlowLayout!
    var navSetup: SentMemesNavSetup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateMemes()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        var thisWidth = screenWidth - 10
        
        layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        //collectionView!.backgroundView?.backgroundColor = UIColor.blueColor()
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(MemeCell.self, forCellWithReuseIdentifier: "MemeCollectionViewCell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navSetup = SentMemesNavSetup(vc: self)
        navSetup.setupNavbarItem()
        updateMemes()
        redrawView()
    }
    
    func gotoCreate() {
        navSetup.gotoCreate()
    }
    
    private func redrawView() {
        updateMemes()
        // ensure the frame is updated on rotation
        collectionView!.frame = self.view.frame
        collectionView!.reloadData()
    }
    
    private func updateMemes() {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let frameWidth = self.view.frame.width - 12 // minus 12 accounts for interitem spacing of 3, and row capacity of 4 items.
        return CGSize(width: frameWidth / 4, height: frameWidth / 4)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        println("MAKING INSETS? \(section)")
        // because layout.sectionInset is not respected when the screen is rotated...
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCell
        let meme = memes[indexPath.row]
        
        if let oldImage = cell.contentView.viewWithTag(1) {
            oldImage.removeFromSuperview()
        }
        
        // Set the name and image
        let frameWidth = self.view.frame.width
        let imageView = UIImageView(frame: CGRectMake(0.0, 0.0, frameWidth / 4, frameWidth / 4))
        imageView.tag = 1
        imageView.image = meme.memedImage
        cell.contentView.addSubview(imageView)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        println("DID SELECT ITEM AT PATH")
        // TODO
//        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController") as! VillainDetailViewController
//        detailController.villain = self.allVillains[indexPath.row]
//        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        redrawView()
    }
}
