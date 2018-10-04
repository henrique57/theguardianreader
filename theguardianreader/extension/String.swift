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
    
    func removeSpecialCharsFromString() -> String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890àÀáéíóúÁÉÍÓÚâêîôûÂÊÎÔÛ")
        return self.filter {okayChars.contains($0)}
    }
    
}
