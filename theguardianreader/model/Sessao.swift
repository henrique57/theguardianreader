//
//  Sessao.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 18/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit
import ObjectMapper

/*
"id": "crosswords",
"webTitle": "Crosswords",
"apiUrl": "https://content.guardianapis.com/crosswords"
*/

class Sessao: Mappable {
   
    var id : String?
    var webTitle : String?
    var apiUrl : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        webTitle <- map["webTitle"]
        apiUrl <- map["apiUrl"]
        //print("\(id) - \(webTitle) - \(apiUrl)")
    }
    
}
