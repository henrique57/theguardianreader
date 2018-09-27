//
//  LinkManager.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 20/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation

class LinkManager { 
    
    // Tags
    static let resourceTag = "<resource>"
    static let pageQttTag = "<pageQtt>"
    static let pageTag = "<page>"
    static let queryTag = "<query>"
    static let sectionTag = "<section>"
    
    // Nome da plist
    static let pathFile = "dados"
    static let pathType = "plist"
    
    // Keys na plist
    static let uriSessoes = "uriSessoes"
    static let uriSessao = "uriSessao"
    static let uriPesquisa = "uriPesquisa"
    static let uriPesquisaSessao = "uriPesquisaSessao"
    static let uriNoticia = "uriNoticia"
    
    static func getUriSessoes(recurso: String) -> String{
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        if var link = contentFile?[uriSessoes] as? String {
            link = link.replacingOccurrences(of: resourceTag, with: recurso)
            return link
        }
        return ""
    }
    
    static func getUriSessao(recurso: String, pageQtt: Int, page: Int) -> String{
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        if var link = contentFile?[uriSessao] as? String {
            link = link.replacingOccurrences(of: resourceTag, with: recurso)
            link = link.replacingOccurrences(of: pageQttTag, with: "\(pageQtt)")
            link = link.replacingOccurrences(of: pageTag, with: "\(page)")
            
            return link
        }
        return ""
    }
    
    static func getUriPesquisa(section: String,page: Int, recurso: String, query: String) -> String{
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        
        if var link = ((section == "") ? contentFile?[uriPesquisa] : contentFile?[uriPesquisaSessao]) as? String {
            link = link.replacingOccurrences(of: resourceTag, with: recurso)
            
            link = link.replacingOccurrences(of: queryTag, with: query)
            
            link = link.replacingOccurrences(of: pageQttTag, with: "15")
            link = link.replacingOccurrences(of: pageTag, with: "\(page)")
            
            if(section != ""){
                let section = section.getPercentString()
                link = link.replacingOccurrences(of: sectionTag, with: section)
            }
            return link
        }
        return ""
    }
    
    static func getUriNoticia(recurso: String) -> String {
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        
        if var link = contentFile?[uriNoticia] as? String {
            link = link.replacingOccurrences(of: resourceTag, with: recurso)
            return link
        }
        return ""
    }
    
    static func contentOfFile(path: String, type: String)-> Dictionary<String,AnyObject>? {
        if let path = Bundle.main.path(forResource: path, ofType: type) {
            if let dictionary = NSDictionary(contentsOfFile: path) as? Dictionary<String,AnyObject> {
                return dictionary
            }
            
        }
        return nil
    }
}
