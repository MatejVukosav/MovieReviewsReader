//
//  ApiRecension.swift
//  MovieReaderScanner
//
//  Created by user on 2/21/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import ObjectMapper

final class ApiRecensionsResponse : Mappable{
    
    var status:String!
    var copyright:String!
    var has_more:Bool!
    var num_result:Int!
    var recensions:[ApiRecension]!
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    required init?(map: Map) {
        mapping(map:map)
    }
 
    func mapping(map:Map){
        status <- map["status"]
        copyright <- map["copyright"]
        has_more <- map["has_more"]
        num_result <- map["num_result"]
        recensions <- map["results"]
    }
    
}
