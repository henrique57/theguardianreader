//
//  LinkNoticia.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 19/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

/*
 - Os dados que deverão ser mostrados em cada linha:
     - Título da notícia.
     - Data de registro da publicação.
     - Imagem da notícia.
*/
 
class NoticeSection {
    var id: String?
    var webPublicationDate: String? // data
    var webTitle: String?           // título
    var apiUrl: String?
    var thumbnail: String?             // image
    
    init(id: String, webPublicationDate: String, webTitle: String, apiUrl: String, thumbnail: String) {
        self.id =  id
        self.webPublicationDate = webPublicationDate
        self.webTitle = webTitle
        self.apiUrl = apiUrl
        self.thumbnail = thumbnail
    }
    
}
