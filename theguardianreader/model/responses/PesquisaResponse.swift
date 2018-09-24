//
//  PesquisaResponse.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 24/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation
import ObjectMapper

class PesquisaResponse : Mappable {
    
    var status: String?
    var pesquisa: [Pesquisa]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.status <- map["response.status"]
        self.pesquisa <- map["response.results"]
    }

}
