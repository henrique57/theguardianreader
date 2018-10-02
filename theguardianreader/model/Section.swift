//
//  Sessao.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 18/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

class Section {
   
    var id : String?
    var webTitle : String?
    var apiUrl : String?
    
    init (id: String, webTitle: String, apiUrl: String){
        self.id = id
        self.webTitle = webTitle
        self.apiUrl = apiUrl
    }
    
}
