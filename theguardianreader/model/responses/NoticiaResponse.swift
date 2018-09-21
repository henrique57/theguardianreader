//
//  NoticiaResponse.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 21/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation
import ObjectMapper

class NoticiaResponse : Mappable {

    var status: String?
    var noticia: Noticia?
    
    required init?(map: Map) {
        
    }
    
    // response.content.sectionName
    // response.content.fields...
    
    func mapping(map: Map) {
        status <- map["response.status"]
        noticia <- map["response.content"]
    }
    
}
