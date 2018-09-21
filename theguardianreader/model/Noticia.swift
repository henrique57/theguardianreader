//
//  Noticia.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 21/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation
import ObjectMapper

/*
 - Título da notícia.
 - Data de registro da publicação.
 - Sessão da notícia.
 - O corpo da notícia.
 */

class Noticia: Mappable {
    
    var headline: String?
    var firstPublicationDate: String?
    var sectionName: String?
    var bodyText: String?
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        self.headline <- map["fields.headline"]
        self.firstPublicationDate <- map["fields.firstPublicationDate"]
        self.sectionName <- map["sectionName"]
        self.bodyText <- map["fields.bodyText"]
    }
    
}
