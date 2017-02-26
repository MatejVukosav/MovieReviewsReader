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
    
    
    convenience init(recension : ApiRecension ){
        self.init()
        self.recension=recension
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
        
        let tap=UITapGestureRecognizer(target:self,action: #selector(RecensionDetailsViewController.tapFunction))
        moreDetails.isUserInteractionEnabled=true
        moreDetails.addGestureRecognizer(tap)
        
    }
    
    func tapFunction(sender:UITapGestureRecognizer){
        let vc = ReviewDetailsWebViewViewController(urlString:recension.link.url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
   

    
}
