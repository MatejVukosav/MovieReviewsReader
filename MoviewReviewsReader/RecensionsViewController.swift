//
//  RecensionsViewController.swift
//  MovieReaderScanner
//
//  Created by user on 2/21/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import UIKit

class RecensionsViewController: UIViewController {
    
    fileprivate let cellIdentifier = String(describing:RecensionTableViewCell.self)
    fileprivate var persistanceService = PersistenceService()

    @IBOutlet weak var tableView: UITableView!
    
    var recensions:[Recension] = [Recension]()
    let url = URL(string:"https://api.nytimes.com/svc/movies/v2/reviews/search.json?api-key=160529a003a94985900c216bfb4ef232")
    
    convenience init(persistanceService: PersistenceService?){
        self.init()
        if let service = persistanceService {
            self.persistanceService = service
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Recensions"

        tableView.register(UINib(nibName:cellIdentifier,bundle:nil), forCellReuseIdentifier: cellIdentifier)
        
        tableView.delegate = self
        tableView.estimatedRowHeight = 10
        tableView.dataSource=self

        getDataFromServer()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //za ulazak iz pozadine registriraj metodu
        NotificationCenter.default.addObserver(self, selector:#selector(RecensionsViewController.methodToRefresh), name:NSNotification.Name.UIApplicationWillEnterForeground, object:UIApplication.shared
        )
    }
    
    func methodToRefresh(){
        recensions.removeAll()
        tableView.reloadData()
        getDataFromServer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func getDataFromServer(){
        //dohvati podatke s interneta
        
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:Any]

                let response = ApiRecensionsResponse(JSON: json)
                if let  apiRecensions = response?.recensions{
                    
                    //TODO ovdje dohvacam recenzije i spremam ih u bazu
                self.persistanceService.insertAllRecensions(apiRecensions: apiRecensions){
                        recensionsSaved in
                    print("Recensions saved: ", recensionsSaved)
                    self.recensions = recensionsSaved
                }
                    
                }
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }catch let error as NSError{
                print(error)
            }
        }).resume()
        
    }

}




extension RecensionsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recensions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: cellIdentifier,for:indexPath) as! RecensionTableViewCell
        let recension = recensions[indexPath.item]
        cell.setup(url: recension.multimedia.src,title: recension.title)
        return cell
    }
    
    
}


extension RecensionsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recension=recensions[indexPath.row]
        let recensionDetails=RecensionDetailsViewController(recension:recension)
        
        navigationController?.pushViewController(recensionDetails, animated: true)
    }
    
}

