//
//  LinkManager.swift
//  theguardianreader
//
//  Created by Henrique Pereira on 20/09/2018.
//  Copyright © 2018 Henrique Pereira. All rights reserved.
//

import Foundation

class LinkManager {
    static let resourceTag = "<resource>"
    static let pageQttTag = "<pageQtt>"
    static let pageTag = "<page>"
    
    static let pathFile = "dados"
    static let pathType = "plist"
    
    static let uriSessoes = "uriSessoes"
    static let uriSessao = "uriSessao"
    static let uriPesquisa = "uriPesquisa"
    
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
    
    static func getUriNoticia(recurso: String) -> String{
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        if var link = contentFile?[uriPesquisa] as? String {
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
