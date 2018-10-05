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
    static let orderTag = "<order>"
    static let pageQttTag = "<pageQtt>"
    static let pageTag = "<page>"
    static let queryTag = "<query>"
    static let sectionTag = "<section>"
    
    // Nome da plist
    static let pathFile = "uri"
    static let pathType = "plist"
    
    // Keys na plist
    static let domain = "domain"
    static let apikey = "api-key"
    static let pageUrl = "page-url"
    static let orderBy = "order-url"
    static let queryUrl = "query-url"
    static let sectionUrl = "section-url"
    static let showUrl = "show-url"
    
    
    /// Get domain, api-key and resource
    ///
    /// - Parameter resource: Resource to be used
    /// - Returns: String with domain, api-key, resource
    static func getDomainApikeyResource(resource: String) -> String{
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        if var domain = contentFile?[domain] as? String {
            domain = domain.replacingOccurrences(of: resourceTag, with: resource)
            if let apikey = contentFile?[apikey] as? String {
                domain.append(apikey)
                return domain
            }
        }
        return ""
    }
    
    
    /// Get order string
    ///
    /// - Parameter order: order (Ex= newest, oldest, relevance)
    /// - Returns: String with order
    static func getOrderConfig(order: String) -> String{
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        if var orderConfig = contentFile?[orderBy] as? String {
            orderConfig = orderConfig.replacingOccurrences(of: orderTag, with: "\(order)")
            
            return orderConfig
        }
        return ""
    }
    
    
    /// Get page string
    ///
    /// - Parameters:
    ///   - pageQtt: Elements per page
    ///   - page: Page number
    /// - Returns: String with page and page quantity
    static func getPageConfig(pageQtt: Int, page: Int) -> String{
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        if var pageConfig = contentFile?[pageUrl] as? String {
            pageConfig = pageConfig.replacingOccurrences(of: pageQttTag, with: "\(pageQtt)")
            pageConfig = pageConfig.replacingOccurrences(of: pageTag, with: "\(page)")
            
            return pageConfig
        }
        return ""
    }
    
    
    /// Get fields string (Ex: all, body, headline...)
    ///
    /// - Returns: String with fields
    static func getFieldsConfig() -> String{
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        if let fieldsConfig = contentFile?[showUrl] as? String {
            return fieldsConfig
        }
        return ""
    }
    
    
    /// Get query string
    ///
    /// - Parameter query: Query to be added
    /// - Returns: String with query
    static func getQueryConfig(query: String) -> String{
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        if var queryConfig = contentFile?[queryUrl] as? String {
            queryConfig = queryConfig.replacingOccurrences(of: queryTag, with: "\(query)")
            return queryConfig
        }
        return ""
    }
    
    
    /// Get section string
    ///
    /// - Parameter section: Section to be added
    /// - Returns: String with section
    static func getSectionConfig(section: String) -> String{
        let contentFile = contentOfFile(path: pathFile, type: pathType)
        if var sectionConfig = contentFile?[sectionUrl] as? String {
            sectionConfig = sectionConfig.replacingOccurrences(of: sectionTag, with: "\(section)")
            return sectionConfig
        }
        return ""
    }
    
    
    /// Get url of notices in a section
    ///
    /// - Parameters:
    ///   - resource: Resource to be used
    ///   - pageQtt: Elements per page
    ///   - page: Page number
    /// - Returns: String with uri
    static func getUriSectionNotice(resource: String, pageQtt: Int, page: Int) -> String{
        var url = getDomainApikeyResource(resource: resource)
        url.append(getOrderConfig(order: "newest"))
        url.append(getPageConfig(pageQtt: pageQtt, page: page))
        url.append(getFieldsConfig())

        return url
    }
    
    
    /// Get uri of search
    ///
    /// - Parameters:
    ///   - section: Section(s) to be used
    ///   - pageQtt: Elements per page
    ///   - page: Page number
    ///   - resource: Resource to be used
    ///   - query: Query to be used
    /// - Returns: String with uri
    static func getUriSearch(section: String, pageQtt: Int, page: Int, resource: String, query: String) -> String{
        var url = getDomainApikeyResource(resource: resource)
        url.append(getFieldsConfig())
        url.append(getOrderConfig(order: "newest"))
        url.append(getPageConfig(pageQtt: pageQtt, page: page))
        if(section != ""){
            url.append(getSectionConfig(section: section))
        }
        
        return url
    }
    
    
    /// Get uri of a single notice
    ///
    /// - Parameter resource: Resource to be used
    /// - Returns: String with uri
    static func getUriNotice(resource: String) -> String {
        var url = getDomainApikeyResource(resource: resource)
        url.append(getFieldsConfig())
        return url
    }
    
    
    /// Get file to be used
    ///
    /// - Parameters:
    ///   - path: File's type
    ///   - type: File's type
    /// - Returns: Dictionary with keys,values
    static func contentOfFile(path: String, type: String)-> Dictionary<String,AnyObject>? {
        if let path = Bundle.main.path(forResource: path, ofType: type) {
            if let dictionary = NSDictionary(contentsOfFile: path) as? Dictionary<String,AnyObject> {
                return dictionary
            }
            
        }
        return nil
    }
}
