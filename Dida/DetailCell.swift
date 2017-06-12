//
//  DetailCell.swift
//  Dida
//
//  Created by 李政含 on 4/12/17.
//
//

import UIKit
class DetialCell:UICollectionViewController,UICollectionViewDelegateFlowLayout{
    var post:Post?
   // @IBOutlet weak var theCell: UICollectionViewCell!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)

        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        feedCell.post = post
        feedCell.feedController = FeedController()
        print("E")
        return feedCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            if let statusText = posts[indexPath.item].statusText {
                
                let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                
                let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
                
                return CGSize(width: view.frame.width, height: rect.height + knownHeight + 24)
            }
            return CGSize(width: view.frame.width, height: 500)
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }

}
