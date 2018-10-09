//
//  String.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 27/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import UIKit

extension String {
    
    func getPercentString() -> String {
        if let tmpString = self.addingPercentEncoding(withAllowedCharacters: NSMutableCharacterSet.alphanumeric() as CharacterSet){
            return tmpString
        }
        return ""
    }
    
    func formatWithFont(font: String) -> NSAttributedString?{
        if let myself = self.formatAttribute(){
            let newAttributedString = NSMutableAttributedString(attributedString: myself)
            
            // Enumerate through all the font ranges
            newAttributedString.enumerateAttribute(NSAttributedStringKey.font, in: NSMakeRange(0, newAttributedString.length), options: [])
            {
                value, range, stop in
                guard let currentFont = value as? UIFont else {
                    return
                }
                
                // An NSFontDescriptor describes the attributes of a font: family name, face name, point size, etc.
                // Here we describe the replacement font as coming from the "Hoefler Text" family
                let fontDescriptor = currentFont.fontDescriptor.addingAttributes([UIFontDescriptor.AttributeName.family: font])
                
                // Ask the OS for an actual font that most closely matches the description above
                if let newFontDescriptor = fontDescriptor.matchingFontDescriptors(withMandatoryKeys: [UIFontDescriptor.AttributeName.family]).first {
                    let newFont = UIFont(descriptor: newFontDescriptor, size: currentFont.pointSize)
                    newAttributedString.addAttributes([NSAttributedStringKey.font: newFont], range: range)
                }
            }
            return newAttributedString
        }
        return self.formatAttribute()
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
