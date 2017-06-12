//
//  User.swift
//  Dida
//
//  Created by 李政含 on 4/12/17.
//
//

import UIKit

class User: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.layer.cornerRadius = self.image.frame.size.width / 2;
        self.image.clipsToBounds = true;
        theCollectionView.delegate=self
        theCollectionView.dataSource=self
        theCollectionView.alwaysBounceVertical = true
        theCollectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        theCollectionView.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        theCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "mycell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("d")
        if collectionType{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mycell", for: indexPath) as! MovieCell
            print("F")
            cell.Image.image = UIImage(named: (posts[indexPath.item].statusImageName!+".png"))
            return cell
        }else{
            let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
            feedCell.post = posts[indexPath.item]
            feedCell.feedController = FeedController()
            print("E")
            return feedCell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionType){
            self.performSegue(withIdentifier: "showCell", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showCell" {
            let indexPaths = self.theCollectionView!.indexPathsForSelectedItems!
            let indexPath = indexPaths[0] as NSIndexPath
            print("a")
            let detailedVC = segue.destination as! DetialCell
//            let feedCell = FeedCell()
            detailedVC.post = posts[indexPath.item]
//            feedCell.feedController = FeedController()
//            print("b")
//            detailedVC.theCell?=feedCell
            
            // navigationController?.pushViewController(detialedVC, animated: true)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionType==false{
        if let statusText = posts[indexPath.item].statusText {
            
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 24)
        }
        return CGSize(width: view.frame.width, height: 500)
        }else{
            return CGSize(width: view.frame.width/3-10, height: view.frame.width/3-10)
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        theCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBOutlet weak var theCollectionView: UICollectionView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
   
    var collectionType:Bool=true
    
    @IBAction func TableCollection(_ sender: UIButton) {
        collectionType=false
        theCollectionView.reloadData()
        
    }
    @IBAction func PhotoCollection(_ sender: UIButton) {
        collectionType=true
        theCollectionView.reloadData()
    }
    @IBAction func Favorite(_ sender: UIButton) {
        
    }
    @IBAction func EditProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showProfile", sender: self)
    }
    
}
