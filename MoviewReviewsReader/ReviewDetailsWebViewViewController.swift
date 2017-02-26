//
//  ReviewDetailsWebViewViewController.swift
//  MovieReaderScanner
//
//  Created by user on 2/22/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import UIKit

class ReviewDetailsWebViewViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
   private var urlString:String=""
    
    convenience init(urlString:String) {
        self.init()
        self.urlString=urlString
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        if let url = URL(string:urlString){
            let request = URLRequest(url:url)
                      //  webView.loadHTMLString( urlString, baseURL: nil)
            webView.loadRequest(request)
        }
    }


}
