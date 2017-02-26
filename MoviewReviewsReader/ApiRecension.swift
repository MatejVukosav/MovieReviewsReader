//
//  ApiRecension.swift
//  MovieReaderScanner
//
//  Created by user on 2/21/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import ObjectMapper

final class ApiRecension : Mappable{
    
    var displayTitle:String!
    var mpaa_rating:String!
    var critics_pick:Int!
    var byline:String!
    var headline:String!
    var summary_short:String!
    var publication_date:String!
    var opening_date:String!
    var date_updated:String!
    var link:ApiLink!
    var multimedia:ApiMultimedia!
    
  public init?(map: Map) {
    mapping(map:map)
    }
    
    func mapping(map:Map){
        displayTitle <- map["display_title"]
        mpaa_rating <- map["mpaa_rating"]
        critics_pick <- map["critics_pick"]
        byline <- map["byline"]
        headline <- map["headline"]
        summary_short <- map["summary_short"]
        publication_date <- map["publication_date"]
        opening_date <- map["opening_date"]
        date_updated <- map["date_updated"]
        link <- map["link"]
        multimedia <- map["multimedia"]
    }
    
}
