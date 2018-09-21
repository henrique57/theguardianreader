//
//  SessoesResponse.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 20/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation
import ObjectMapper

class NoticiaSessaoResponse: Mappable {
    var status: String?
    var noticias: [NoticiaSessao]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["response.status"]
        noticias <- map["response.results"]
    }    
}
