//
//  ApiLink.swift
//  MovieReaderScanner
//
//  Created by user on 2/21/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import ObjectMapper

final class ApiLink:Mappable{
    
    var type:String!
    var url:String!
    var suggested_link_text:String!

    public init?(map: Map) {
        mapping(map:map)
    }
    
    func mapping(map:Map){
        type <- map["type"]
        url <- map["url"]
        suggested_link_text <- map["suggested_link_text"]
    }
    
}
