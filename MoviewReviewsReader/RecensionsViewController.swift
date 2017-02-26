//
//  RecensionsViewController.swift
//  MovieReaderScanner
//
//  Created by user on 2/21/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import UIKit

class RecensionsViewController: UIViewController {
    
    fileprivate let cellIdentifier=String(describing:RecensionTableViewCell.self)

    @IBOutlet weak var tableView: UITableView!
    
    var recensions:[ApiRecension]=[ApiRecension]()
    let url=URL(string:"https://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=160529a003a94985900c216bfb4ef232")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName:cellIdentifier,bundle:nil), forCellReuseIdentifier: cellIdentifier)
        
        navigationItem.title="Recensions"

        tableView.dataSource=self
        tableView.delegate=self
        tableView.estimatedRowHeight = 10

        
        getData()
    }
    
    func getData(){
        //dohvati podatke s interneta
        
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }else{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:Any]
                    
                
                    let response = ApiRecensionsResponse(JSON: json)
                    if let  r = response?.recensions{
                        self.recensions=r
                    }

                
                    
                    OperationQueue.main.addOperation({
                        self.tableView.reloadData()
                    })
                    
                }catch let error as NSError{
                    print(error)
                }
            }
        }).resume()
        
    }
}

extension RecensionsViewController : UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recensions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for:indexPath) as! RecensionTableViewCell
        
        if recensions.count != 0{
            let r = recensions[indexPath.item]
            cell.setup(image: UIImage(),title: r.headline)
        }
        
        return cell
    }
    
    
}

extension RecensionsViewController : UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recension=recensions[indexPath.row]
        let recensionDetails=RecensionDetailsViewController(recension:recension)
        
        navigationController?.pushViewController(recensionDetails, animated: true)
    }
    
}

