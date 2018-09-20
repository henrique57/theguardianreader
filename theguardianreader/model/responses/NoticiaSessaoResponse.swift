//
//  SessoesResponse.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 20/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation
import ObjectMapper

class SessoesResponse: Mappable {
    var status: String?
    var userTier: String?
    var total: Int?
    var noticias: [Noticia]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["response.status"]
        sessoes <- map["response.results"]
    }
    
}
