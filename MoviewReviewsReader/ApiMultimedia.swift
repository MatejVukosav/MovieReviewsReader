//
//  ApiMultimedia.swift
//  MovieReaderScanner
//
//  Created by user on 2/21/17.
//  Copyright © 2017 vuki. All rights reserved.
//

import ObjectMapper

final class ApiMultimedia : Mappable{
    
    var type:String!
    var src:String!
    var width:Int!
    var height:Int!
    
    public init?(map: Map) {
        mapping(map:map)
    }
    
    func mapping(map:Map){
        type <- map["type"]
        src <- map["src"]
        width <- map["width"]
        height <- map["height"]
    }
    
}
