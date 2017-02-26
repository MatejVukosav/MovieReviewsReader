//
//  RecensionTableViewCell.swift
//  MovieReaderScanner
//
//  Created by user on 2/21/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import UIKit

class RecensionTableViewCell: UITableViewCell {
    
    private let imageDownloadQueue = OperationQueue()
    
    

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    func setup(image:UIImage,title:String){
        self.title.text=title
        self.movieImageView.image=image
    }
    
    override func awakeFromNib() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageDownloadQueue.cancelAllOperations()
    }

    func setup(){
        
      //  imageDownloadQueue.addOperation(imageDownloadOperation)
    }
    
    private func imageDownloadOperation(with operationIndex: Int, completion: @escaping StringClosure) -> Operation {
        let operation = ImageDownloadOperation(with: operationIndex, completion: completion)
        return operation
    }
    
}
