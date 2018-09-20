//
//  Response.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 20/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit
import ObjectMapper

/*
 response: {
 status: "ok",
 userTier: "developer",
 total: 75,
 results: []
 }*/

class SessaoResponse: Mappable {
    var status: String?
    var userTier: String?
    var total: Int?
    var sessoes: [Sessao]?
 
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["response.status"]
        sessoes <- map["response.results"]
    }
    
}
