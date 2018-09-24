//
//  ApiService.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 24/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation

class ApiService {
    
    static func formataData(data: String?) -> String {
        if let data = data {
            var date = data.split(separator: "T")
            var dateTmp = date[0].split(separator: "-")
            let anoFormatado = "\(dateTmp[2])/\(dateTmp[1])/\(dateTmp[0])"
            date[1].removeLast()
            return ("\(anoFormatado) \(date[1])")
        }
        return ""
    }
    
}
