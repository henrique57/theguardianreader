//
//  LinkNoticia.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 19/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit
import ObjectMapper

/*
 - Os dados que deverão ser mostrados em cada linha:
     - Título da notícia.
     - Data de registro da publicação.
     - Imagem da notícia.
*/
 
class NoticiaSessao: Mappable{
    var id: String?
    var webPublicationDate: String? // data
    var webTitle: String?           // título
    var apiUrl: String?
    var img: String?             // image
    
    required init?(map: Map) {
    
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.webPublicationDate <- map["webPublicationDate"]
        self.webTitle <- map["webTitle"]
        self.apiUrl <- map["apiUrl"]
        self.img <- map["fields.thumbnail"]
    }
    
}
