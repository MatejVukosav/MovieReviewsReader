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
    private var url:String = ""
    

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    
    func setup(url:String,title:String){
        self.title.text = title
        self.url = url

        //dohvat slike s interneta
        DispatchQueue.global().async{
            let data = try? Data(contentsOf: URL( string: self.url )!)
            DispatchQueue.main.async{
                self.movieImageView.image=UIImage(data:data!)
            }
        }

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageDownloadQueue.cancelAllOperations()
    }
    
    private func imageDownloadOperation(with operationIndex: Int, completion: @escaping StringClosure) -> Operation {
        let operation = ImageDownloadOperation(with: operationIndex, completion: completion)
        return operation
    }
    
}
