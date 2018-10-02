//
//  Pesquisa.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 24/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation

class Search {
    
    var id: String?
    var section: String?
    var webPublicationDate: String?
    var webTitle: String?
    
    init(id: String, section: String, webPublicationDate: String, webTitle: String) {
        self.id = id
        self.section = section
        self.webPublicationDate = webPublicationDate
        self.webTitle = webTitle
    }
}
