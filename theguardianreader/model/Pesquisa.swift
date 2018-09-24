//
//  Pesquisa.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 24/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation
import ObjectMapper

class Pesquisa: Mappable {
    
    var id: String?
    var section: String?
    var webPublicationDate: String?
    var webTitle: String?
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.section <- map["sectionName"]
        self.webPublicationDate <- map["webPublicationDate"]
        self.webTitle <- map["webTitle"]
    }
    
}
