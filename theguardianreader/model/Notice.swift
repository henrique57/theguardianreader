//
//  Noticia.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 21/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation

/*
 - Título da notícia.
 - Data de registro da publicação.
 - Sessão da notícia.
 - O corpo da notícia.
 */

class Notice {
    
    var headline: String?
    var firstPublicationDate: String?
    var sectionName: String?
    var thumbnail: String?
    var body: String?
    var bodyText: String?
    
    init(){}
    
    init(headline: String, firstPublicationDate: String, sectionName: String, thumbnail: String, body: String, bodyText: String) {
        self.headline = headline
        self.firstPublicationDate = firstPublicationDate
        self.sectionName = sectionName
        self.thumbnail = thumbnail
        self.body = body
        self.bodyText = bodyText
    }
    
}
