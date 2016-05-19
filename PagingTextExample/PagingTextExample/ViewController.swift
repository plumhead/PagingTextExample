//
//  ViewController.swift
//  PagingTextExample
//
//  Created by Developer on 17/05/2016.
//  Copyright © 2016 Plumhead Software. All rights reserved.
//

import UIKit


struct EditPage {
    var editor    : UITextView?
    let container : NSTextContainer
}

class ViewController: UIViewController {
    @IBOutlet weak var pageCollection: UICollectionView!
    @IBOutlet weak var pageCanvas: UIView!

    var storage : NSTextStorage!
    var layout  : NSLayoutManager!
    
    var pages : [EditPage] = []
    var currentPage : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        configureContentPresentation()
    }
    
    func configureContentPresentation() {
        // Setup the layout manager
        layout = NSLayoutManager()
        layout.delegate = self
        
        // Setup our content storage
        storage = NSTextStorage(string: sampleText())
        storage.delegate = self
        storage.addLayoutManager(layout)

        layout.ensureLayoutForCharacterRange(NSRange(location: 0, length: storage.length))
    }

    func createPage() {
        let editBounds = CGRectInset(pageCanvas.bounds, 10, 10)
        let editContainer = NSTextContainer(size: editBounds.size)
        editContainer.widthTracksTextView = true
        editContainer.heightTracksTextView = true
        layout.addTextContainer(editContainer)
        editContainer.replaceLayoutManager(layout)
        
        print("[CREATING PAGE] : \(pages.count + 1)")
        pages.append(EditPage(editor: .None, container: editContainer))
    }
    
    func moveToPage(page: Int) {
        guard page <= pages.count else {return} // make sure page in range
        
        if pages[page].editor == .None {
            let container = pages[page].container

            print("[MOVE] page=\(page)")
            let cs = CGRect(x: 10, y: 10, width: container.size.width, height: container.size.height)
            let newEditor = UITextView(frame: cs, textContainer: container)
            newEditor.delegate = self
            
            self.pageCanvas.addSubview(newEditor)
            pages[page].editor = newEditor
        }
        
        print("[PAGE SWAP] \(currentPage) to \(page)")

        let prevEditor = pages[currentPage].editor
        let newEditor = pages[page].editor

        prevEditor?.resignFirstResponder()
        prevEditor?.userInteractionEnabled = false
        prevEditor?.editable = false
        prevEditor?.selectable = false
        
        newEditor?.userInteractionEnabled = true
        newEditor?.editable = true
        newEditor?.selectable = true
        newEditor?.becomeFirstResponder()

        prevEditor?.alpha = 0.0
        newEditor?.alpha = 1.0

   
        currentPage = page

//        UIView.animateWithDuration(0.25, animations: {
//                self.editor?.alpha = 0.0
//                newEditor.alpha = 1.0
//            }) { (b) in
//                self.editor?.removeFromSuperview()
//                self.editor = nil
//                self.editor = newEditor
//                self.editor?.becomeFirstResponder()
//        }
        
       
    }
    
    func sampleText() -> String {
        print("[Loading Sample Data]")
        guard let p = NSBundle.mainBundle().pathForResource("SampleText", ofType: "txt") else {
            return "Missing sample text"
        }
        
        do {
            return try String(contentsOfFile: p)
        }
        catch {
            return "Error Loading Content"
        }
    }
}


//MARK: - Layout Management
extension ViewController : NSLayoutManagerDelegate {
    func layoutManager(layoutManager: NSLayoutManager, didCompleteLayoutForTextContainer textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        
        guard layoutManager == layout else {return} // we are only interested in our layout manager
        print("[LAYOUT] container=\(textContainer != nil) complete=\(layoutFinishedFlag)")

        // if we don't have a container then need to create a new page
        if textContainer == nil {
            createPage()
            return
        }

        // check if we've finished layout or not
        guard !layoutFinishedFlag else {
            pageCollection.reloadData() // we may have added new pages
            return
        }
        
        // We may still be laying out an existing page so need to check against the ones we've already created
        
        let i = pages.indexOf { (pc) -> Bool in
            return pc.container === textContainer
        }
        
        if i == .None {
            
        }
        

    }
}


//MARK: - Text Storage Management
extension ViewController : NSTextStorageDelegate {
    func textStorage(textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
    }
}

//MARK: - Text View Management
extension ViewController : UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
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
        return pages.count // replace with real page count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        moveToPage(indexPath.row)
    }
}


//MARK: - Page Delegate
extension ViewController : UICollectionViewDelegate {
    
}


