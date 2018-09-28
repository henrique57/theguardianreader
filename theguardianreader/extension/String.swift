//
//  String.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 27/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation

extension String {
    
    func getPercentString() -> String {
        if let tmpString = self.addingPercentEncoding(withAllowedCharacters: NSMutableCharacterSet.alphanumeric() as CharacterSet){
            return tmpString
        }
        return ""
    }
    
    func formatData() -> String {
        var date = self.split(separator: "T")
        var dateTmp = date[0].split(separator: "-")
        let anoFormatado = "\(dateTmp[2])/\(dateTmp[1])/\(dateTmp[0])"
        date[1].removeLast()
        return ("\(anoFormatado) \(date[1])")
    }
    
    func formatAttribute() -> NSAttributedString? {
        if let data = self.data(using: String.Encoding.unicode){
            let attrStr = try? NSAttributedString(
                data: data,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil)
            return attrStr
        }
        return nil
    }
    
}
