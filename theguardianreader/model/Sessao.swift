//
//  Sessao.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 18/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

/*
"id": "crosswords",
"webTitle": "Crosswords",
"webUrl": "https://www.theguardian.com/crosswords",
"apiUrl": "https://content.guardianapis.com/crosswords"
*/

struct Session {
    let id : String?
    let webTitle : String?
    let webUrl : String?
    let apiUrl : String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        webTitle = try values.decodeIfPresent(String.self, forKey: .webTitle)
        webUrl = try values.decodeIfPresent(String.self, forKey: .webUrl)
        apiUrl = try values.decodeIfPresent(String.self, forKey: .apiUrl)
    }
    
}
