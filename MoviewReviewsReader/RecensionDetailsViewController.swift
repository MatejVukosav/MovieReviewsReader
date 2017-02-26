//
//  RecensionDetailsViewController.swift
//  MovieReaderScanner
//
//  Created by user on 2/21/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import UIKit

class RecensionDetailsViewController: UIViewController {
    
    //sta sad s tim ! ,kad ne mogu inicijalizirat
    private var recension:ApiRecension!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var reviewAuthor: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var shortSummary: UILabel!
    @IBOutlet weak var moreDetails: UILabel!
    
    private var animationBias: CGFloat = 1.0
    
    @IBOutlet weak var constraintAuthorLeftX: NSLayoutConstraint!
    @IBOutlet weak var constraingDateRightX: NSLayoutConstraint!
    @IBOutlet weak var constraintTitleRightX: NSLayoutConstraint!
    
    convenience init(recension : ApiRecension ){
        self.init()
        self.recension=recension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //makni ih s ekrana
        self.constraingDateRightX.constant -= view.bounds.width
        self.constraintAuthorLeftX.constant += view.bounds.width
        self.constraintTitleRightX.constant -= view.bounds.width
        self.moreDetails.alpha=0

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        navigationItem.title=recension.headline
        
        movieTitle.text=recension.displayTitle
        reviewAuthor.text=recension.byline
        reviewDate.text=recension.date_updated
        shortSummary.text=recension.summary_short
        moreDetails.text=recension.link.suggested_link_text
        
        
        DispatchQueue.global().async{
            let data = try? Data(contentsOf: URL( string: self.recension.multimedia.src )!)
            DispatchQueue.main.async{
                self.movieImage.image=UIImage(data:data!)
            }
        }
        // tap gestures za url labelu
        let tap=UITapGestureRecognizer(target:self,action: #selector(RecensionDetailsViewController.tapFunction))
        moreDetails.isUserInteractionEnabled=true
        moreDetails.addGestureRecognizer(tap)
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.8, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.constraingDateRightX.constant += self.view.bounds.width
            self.constraintAuthorLeftX.constant -= self.view.bounds.width
            self.constraintTitleRightX.constant += self.view.bounds.width
            
            self.movieTitle.alpha=1
            self.reviewDate.alpha=1
            self.reviewAuthor.alpha=1
            
            self.view.layoutIfNeeded()
        }, completion: {finished in
            self.moreDetails.alpha=1
        }
        )
    }
    
  
    
    func tapFunction(sender:UITapGestureRecognizer){
        let vc = ReviewDetailsWebViewViewController(urlString:recension.link.url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
   

    
}
