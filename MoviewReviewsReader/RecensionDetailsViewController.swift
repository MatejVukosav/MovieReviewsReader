//
//  RecensionDetailsViewController.swift
//  MovieReaderScanner
//
//  Created by user on 2/21/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import UIKit

class RecensionDetailsViewController: UIViewController,UITextViewDelegate {
    
    //sta sad s tim ! ,kad ne mogu inicijalizirat
    private var recension:Recension!
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var reviewAuthor: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var shortSummary: UILabel!
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var moreDetails: UILabel!
    
    
    var edit:UIButton = UIButton()
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var remove: UIButton!
    
    private var animationBias: CGFloat = 1.0


    convenience init(recension : Recension ){
        self.init()
        self.recension = recension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.movieTitle.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)
        self.reviewAuthor.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)
        self.reviewDate.transform = CGAffineTransform.identity.translatedBy(x: view.frame.width, y: 0)

        self.moreDetails.alpha = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = recension.title
        
        movieTitle.text = recension.displayTitle
        reviewAuthor.text = recension.author
        reviewDate.text = recension.date
        shortSummary.text = recension.summaryShort
        moreDetails.text = recension.link.suggestedLinkText
        
       
        
        DispatchQueue.global().async {
            if  !self.recension.multimedia.src.isEmpty {
                let data = try? Data(contentsOf: URL( string: self.recension.multimedia.src )!)
                DispatchQueue.main.async{
                    self.movieImage.image = UIImage(data:data!)
                }
            }
            
        }
        // tap gestures za url labelu
        let tap=UITapGestureRecognizer(target:self,action: #selector(RecensionDetailsViewController.tapFunction))
        moreDetails.isUserInteractionEnabled = true
        moreDetails.addGestureRecognizer(tap)
        
        comment.delegate=self
        
        //remove brise sadrzaj i omogucuje save
        
        save.addTarget(self, action: #selector(RecensionDetailsViewController.onSaveClick), for: .touchUpInside)
    
        
        edit.frame = save.frame
        // ne vidi se uopce??
        edit.setTitleColor(.red, for: .normal)
        
        edit.addTarget(self, action: #selector(RecensionDetailsViewController.onEditClick), for: .touchUpInside)
        remove.addTarget(self, action: #selector(RecensionDetailsViewController.onRemoveClick), for: .touchUpInside)

        //ako postoji tekst onda omoguci remove i edit
        if !recension.comment.text.isEmpty {
            comment.text = recension.comment.text
            
            comment.isEditable = false
            edit.isHidden = false
            remove.isHidden = false
            
            save.isHidden = true
        }else{
            remove.isHidden = true
            save.isHidden = true
            edit.isHidden = true
            comment.isEditable = true
        }

        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if !textView.text.isEmpty {
            save.isHidden = false
        }else{
            save.isHidden = true
        }
        
    }
    
    func onSaveClick(){
        //spremit komentar u bazu
        let c:Comment = Comment()
        c.text = comment.text
        c.author = "matej"
        
        recension.comment = c
        
        save.isHidden = true
        remove.isHidden = false
        edit.isHidden = false
        
        comment.isEditable = false
        
        //spremi u bazu
    }
    
    func onEditClick(){
        //editiraj komentar i spremi ga u bazu
        
        comment.isEditable = true
        save.isHidden = false
        remove.isHidden = false
        edit.isHidden = true
        //spremit komentar u bazu
    }
    
    func onRemoveClick(){
        //makni komentar iz baze
        
        save.isHidden = true
        remove.isHidden = true
        edit.isHidden = true
        
        comment.isEditable = true
        comment.text = ""
        recension.comment = Comment() //ne moze nil..?
        //spremit u bazu da je sad prazno
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.8, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.movieTitle.transform = CGAffineTransform.identity
            self.reviewAuthor.transform = CGAffineTransform.identity
            self.reviewDate.transform = CGAffineTransform.identity

            
            self.movieTitle.alpha = 1
            self.reviewDate.alpha = 1
            self.reviewAuthor.alpha = 1
            
            self.view.layoutIfNeeded()
        }, completion: {finished in
            self.moreDetails.alpha=1
        }
        )
    }
    
  
    
    func tapFunction(sender:UITapGestureRecognizer){
        if !recension.link.url.isEmpty {
            let vc = ReviewDetailsWebViewViewController(urlString: recension.link.url)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
   

    
}
