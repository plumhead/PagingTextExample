//
//  ViewController.swift
//  PagingTextExample
//
//  Created by Developer on 17/05/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var editor: UITextView!
    @IBOutlet weak var pageCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


//MARK: - Page Data Source
extension ViewController : UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = pageCollection.dequeueReusableCellWithReuseIdentifier("IdPageCell", forIndexPath: indexPath) as! PageViewCell
        
        cell.pageLabel.text = "page: \(indexPath.row + 1)"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 // replace with real page count
    }
}


//MARK: - Page Delegate
extension ViewController : UICollectionViewDelegate {
    
}


