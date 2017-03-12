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
    
    //zasto ne radi s ?
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
        
        
        //   if let frc = persistanceService?.fetchController(forRequest: request){
        //      tableView.dataSource = UITableViewDataSource(tableView: tableView,
        //                                      cellIdentifier: cellIdentifier,
        //                                      fetchedResultController: frc,
        //                                     delegate: self)
        //}else{
        //    tableView.dataSource = self
        // }
        tableView.dataSource=self

        
        if let data = getDataFromCoreData() as? [Recension], !data.isEmpty {
            recensions = data
        }else{
            getDataFromServer()
        }
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
    
    func getDataFromCoreData() -> [Recension]{
        //dohvati podatke iz core data
        var data:[Recension] = [Recension]()
        
        
        return data
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
                if let  r = response?.recensions{
                    
                    
                    for apiRecension in r {
                        let recension = Recension()
                        recension.title = apiRecension.headline
                        recension.displayTitle = apiRecension.displayTitle
                        recension.summaryShort = apiRecension.summary_short
                        recension.date = apiRecension.publication_date
                        
                        recension.link.url = apiRecension.link.url
                        recension.link.type = apiRecension.link.type
                        recension.link.suggestedLinkText = apiRecension.link.suggested_link_text

                        recension.multimedia.src = apiRecension.multimedia.src
                        recension.multimedia.type = apiRecension.multimedia.type
                        recension.multimedia.height = apiRecension.multimedia.height
                        recension.multimedia.width = apiRecension.multimedia.width
                        
                        recension.author = apiRecension.byline
                        
                        self.recensions.append(recension)
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

